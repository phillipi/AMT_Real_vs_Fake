
import numpy as np
import csv
from collections import OrderedDict
import argparse
from tqdm import tqdm

from IPython import embed

def collect_csv_results(filename):
	with open(filename, newline='') as csvfile:
		reader = csv.DictReader(csvfile)
		for rr,row in enumerate(reader):
			if(rr==0):
				raw_dict = row
				for key in row.keys():
					raw_dict[key] = [raw_dict[key],]
			else:
				for key in row.keys():
					raw_dict[key].append(row[key])

	return raw_dict


def read_csv(filename, N_practice, N_imgs):
	raw_dict = collect_csv_results(filename)

	gt_prefix = 'Input.gt_side'
	ans_prefix = 'Answer.selection'

	gts = []
	ans = []
	for nn in range(N_imgs):
		gts.append(1.*(np.array(raw_dict['%s%i'%(gt_prefix,nn)])=='right'))
		ans.append(1.*(np.array(raw_dict['%s%i'%(ans_prefix,nn)])=='right'))
	gts = np.array(gts)
	ans = 1-np.array(ans)
	N_turkers = gts.shape[1]

	def get_method(in_string):
		return ('/').join(in_string.split('/')[:-1])

	mleft_prefix = 'Input.images_left'
	mright_prefix = 'Input.images_right'

	methods_left = []
	methods_right = []
	for nn in range(N_imgs):
		methods_left.append([get_method(val) for val in raw_dict['%s%i'%(mleft_prefix,nn)]])
		methods_right.append([get_method(val) for val in raw_dict['%s%i'%(mright_prefix,nn)]])

	# [np.sum(methods_left==method) for method in np.unique(methods_left)]
	all_method_names = np.unique(np.array(methods_left+methods_right))
	methods_left = np.array(methods_left)
	methods_right = np.array(methods_right)

	a = []
	for method in all_method_names:
		a.append(np.sum(methods_left==method)+np.sum(methods_right==method))

	gt_method_name = all_method_names[np.argmax(a)]
	all_method_names = np.setdiff1d(all_method_names, gt_method_name)
	# all_method_names = np.setdiff1d(np.unique(np.array(methods_left+methods_right)), gt_method)
	# all_method_names = np.unique(np.array(methods_left+methods_right))
	method_nums = np.zeros((N_imgs, N_turkers))
	for (mm,method) in enumerate(all_method_names):
		method_nums[(method==methods_left) + (method==methods_right)] = mm

	return (gts[N_practice:], ans[N_practice:], method_nums[N_practice:], all_method_names, gt_method_name)


def calculate_results(gts, ans, method_nums):
	fools = []
	for mm in range(int(np.max(method_nums)+1)):
		mask = (method_nums==mm)
		acc = np.mean((gts==ans)*mask)/(np.mean(mask)+.000001)
		fool = 1-acc
		fools.append(fool)

	return fools


def bootstrap(gts, ans, method_nums):
	N,A = gts.shape
	gts_out = gts.copy()
	ans_out = ans.copy()
	method_nums_out = method_nums.copy()

	a_inds = np.random.randint(A, size=A)
	n_inds = np.random.randint(N, size=(N,A))
	for (aa,a_ind) in enumerate(a_inds):
		aa
		gts_out[:,aa] = gts[n_inds[:,aa], a_ind]
		ans_out[:,aa] = ans[n_inds[:,aa], a_ind]
		method_nums_out[:,aa] = method_nums[n_inds[:,aa], a_ind]

	return gts_out, ans_out, method_nums_out
		

parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-f','--filename', type=str, default='expt/results0.csv')
parser.add_argument('--N_practice', type=int, default=10)
parser.add_argument('--N_imgs', type=int, default=60)
parser.add_argument('--N_bootstrap', type=int, default=10000)

opt = parser.parse_args()

gts, ans, method_nums, all_method_names, gt_method_name = read_csv(opt.filename, opt.N_practice, opt.N_imgs)
fools = calculate_results(gts, ans, method_nums)

print('Turkers [%i], each do images [%i]'%(gts.shape[1], gts.shape[0]))

# results
print('\nMean')
for (mm,method) in enumerate(all_method_names):
	print('%2.2f%% \t[%s] (%i)'%(fools[mm]*100,method,np.sum(method_nums==mm)))


print('\nBootstrapping')
bootstrap_fools = []
for a in tqdm(range(opt.N_bootstrap)):
	bootstrap_fools.append(calculate_results(*bootstrap(gts, ans, method_nums)))
bootstrap_fools = np.array(bootstrap_fools)

fool_means = np.mean(bootstrap_fools, axis=0)
fool_stds = np.std(bootstrap_fools, axis=0)

for (mm,method) in enumerate(all_method_names):
	print('%2.2f\t+/-\t%2.2f%%\t [%s]'%(fool_means[mm]*100,fool_stds[mm]*100,method))

betters = np.zeros((len(all_method_names),len(all_method_names)))
for (mm,method) in enumerate(all_method_names):
	print('\n[%s] >'%method)
	for (nn,method2) in enumerate(all_method_names):
		betters[mm,nn] = np.mean(bootstrap_fools[:,mm] > bootstrap_fools[:,nn]) + .5*np.mean(bootstrap_fools[:,mm]==bootstrap_fools[:,nn])
		if(mm!=nn):
			print('\t%02.1f%% \t[%s]'%(betters[mm,nn]*100.,method2))





%% Usage
% images to test must be accessible at "url/n.png", where url is a publicly readable url and and n is some integer

%% expt parameters
opt = {};
opt.expt_name = 'loss_variations_cityscapes';
opt.which_algs = {'L1cGAN'};
opt.vigilance_alg = 'random';
opt.Nimgs = 500;          % number of images to test
opt.Npairs = 60;          % number of paired comparisons per HIT
opt.Nhits_per_alg = 100;  % number of HITs per algorithm
opt.csvs_dir = './csvs';  % where to output the csv files for AMT
opt.vigilance_freq = 0.1; % percent of trials that are vigilance tests
opt.ut_id = 'unset';      % set this using http://uniqueturker.myleott.com/
opt.base_url = 'unset';   % url where images to test are accessible as "opt.base_url/n.png", for integers n

%% check parameters
if (opt.ut_id=='unset')
	error('must set a unique id for this HIT using http://uniqueturker.myleott.com/');
end
if (opt.base_url = 'unset')
	error('must provide a url where test images are accessible')
end

%%
rng('shuffle');

if(~exist(opt.csvs_dir,'dir'))
    mkdir(opt.csvs_dir);
end

%% matched 2afc
csv_fname = fullfile(csvs_dir,sprintf('expt_%s.csv',expt_name));

gt_side = {};
images_left = {};
images_right = {};

for i=1:Npairs
    gt_side{1,i} = sprintf('gt_side%d',i);
    images_left{1,i} = sprintf('images_left%d',i);
    images_right{1,i} = sprintf('images_right%d',i);
end

for which_alg_curr=1:length(which_algs) % each trial tests just one alg
    
    for j=1:Nhits_per_alg % same number of HITs for each alg
        
        which_imgs = randperm(Nimgs); which_imgs = which_imgs(1:Npairs); % choose random set of images to test on, from test set
        
        for i=1:length(which_imgs)
            
            if (rand(1)<=opt.vigilance_freq) % opt.vigilance_freq proportion of trials are vigilance checks
                alg_im_name = sprintf('%s/%d',vigilance_alg,which_imgs(i));
            else
                alg_im_name = sprintf('%s/%d',which_algs{which_alg_curr},which_imgs(i));
            end
            
            if (randi(2)==1) % randomize which side of UI gt is on
                gt_side{(which_alg_curr-1)*Nhits_per_alg+j+1,i} = 'left';
                images_left{(which_alg_curr-1)*Nhits_per_alg+j+1,i} = sprintf('gt_imgs_0/%d',which_imgs(i));
                images_right{(which_alg_curr-1)*Nhits_per_alg+j+1,i} = alg_im_name;
            else
                gt_side{(which_alg_curr-1)*Nhits_per_alg+j+1,i} = 'right';
                images_left{(which_alg_curr-1)*Nhits_per_alg+j+1,i} = alg_im_name;
                images_right{(which_alg_curr-1)*Nhits_per_alg+j+1,i} = sprintf('gt_imgs_0/%d',which_imgs(i));
            end
        end
    end
end

A = cat(2,gt_side,images_left,images_right);

rp = randperm(size(A,1)-1)+1; A = A([1,rp],:); % randomize HIT order (I think MTurk does this but let's do it here as well for safety)

fid = fopen(csv_fname,'w');
for i=1:size(A,1)
    for j=1:size(A,2)-1
       fprintf(fid,[A{i,j},',']);
    end
    fprintf(fid,A{i,end});
    fprintf(fid,'\n');
end
fclose(fid);


%% html code generator
if (exist('index.html','file'))
	system('rm index.html');
end

html = fileread('index_template.html');

html = strrep(html, '{{UT_ID}}', opt.ut_id);
html = strrep(html, '{{BASE_URL}}', opt.base_url);

s = [];
for i=1:Npairs
    s = cat(1,s,sprintf('sequence_helper("${gt_side%d}","${images_left%d}","${images_right%d}");\n',i,i,i));
end
html = strrep(html, '{{SEQUENCE}}', s);

s = [];
for i=1:Npairs
    s = cat(1,s,sprintf('<input type="hidden" name="selection%d" id="selection%d" value="unset">\n',i,i));
end
html = strrep(html, '{{SELECTION}}', s);

fid = fopen('index.html','w');
fprintf(fid,html);
fclose(fid);





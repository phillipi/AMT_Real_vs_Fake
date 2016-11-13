function [opt] = getOpts(expt_name)
	
	switch expt_name
		case 'cityscapes_all_variations'
			opt = getDefaultOpts();
			
			opt.which_algs_paths = {'L1cGAN'}; %{'L1','GAN','cGAN','L1GAN','L1cGAN','0layers','1layers','6layers','encoderdecoderL1','encoderdecoderL1cGAN'};
			opt.Nimgs = 100;
			opt.ut_id = 'asdf';
			opt.base_url = 'https://people.eecs.berkeley.edu/~isola/pix2pix/turk/cityscapes/all_variations/';
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
			opt.use_vigilance = false;
			opt.im_height = 256;
			opt.im_width = 256;
			opt.paired = false;
			
		case 'map2sat_all_variations'
			opt = getDefaultOpts();
		
			opt.which_algs_paths = {'L1','L1cGAN'};
			opt.Nimgs = 100;
			opt.ut_id = '5c484f2f9647ff5b7d25eb2aa1bd60c7';
			opt.base_url = 'https://people.eecs.berkeley.edu/~isola/pix2pix/turk/map2sat/all_variations/';
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
			opt.use_vigilance = false;
			opt.im_height = 256;
			opt.im_width = 256;
			opt.paired = false;
			opt.Nhits_per_alg = 50;
			
		case 'sat2map_all_variations'
			opt = getDefaultOpts();
		
			opt.which_algs_paths = {'L1','L1cGAN'};
			opt.Nimgs = 100;
			opt.ut_id = '5c484f2f9647ff5b7d25eb2aa1bd60c7';
			opt.base_url = 'https://people.eecs.berkeley.edu/~isola/pix2pix/turk/sat2map/all_variations/';
			opt.instructions_file = './instructions_sat2map.html';
			opt.short_instructions_file = './short_instructions_sat2map.html';
			opt.consent_file = './consent_basic.html';
			opt.use_vigilance = false;
			opt.im_height = 256;
			opt.im_width = 256;
			opt.paired = false;
			opt.Nhits_per_alg = 50;
		
		otherwise
			error(sprintf('no opts defined for experiment %s',expt_name));
	end
	
	opt.expt_name = expt_name;
end
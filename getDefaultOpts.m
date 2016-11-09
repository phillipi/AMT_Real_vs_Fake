function [opt] = getDefaultOpts()
	opt = {};
	opt.expt_name = 'unset';
	opt.which_algs_paths = 'unset';
	opt.vigilance_path = 'vigilance';
	opt.gt_path = 'gt';
	opt.Nimgs = 500;                        % number of images to test
	opt.Npairs = 60;                        % number of paired comparisons per HIT
	opt.Nhits_per_alg = 100;                % number of HITs per algorithm
	opt.vigilance_freq = 0.1;               % percent of trials that are vigilance tests
	opt.ut_id = 'unset';                    % set this using http://uniqueturker.myleott.com/
	opt.base_url = 'unset';                 % url where images to test are accessible as "opt.base_url/n.png", for integers n
	opt.instructions_file = 'unset';        % instructions appear at the beginning of the HIT
	opt.short_instructions_file = 'unset';  % short instructions are shown at the top of every trial
	opt.consent_file = 'unset';             % informed consent text appears the beginning of the HIT	
end
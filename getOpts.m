function [opt] = getOpts(expt_name)
	
	switch expt_name
        
		case 'example_expt'
			opt = getDefaultOpts();
		
			opt.which_algs_paths = {'my_alg','baseline_alg'};
			opt.Nimgs = 1000;
			opt.ut_id = 'unset'; % set this using http://uniqueturker.myleott.com/
			opt.base_url = 'https://www.mywebsite.com/example_expt_data/';
			opt.instructions_file = './instructions_basic.html';
			opt.short_instructions_file = './short_instructions_basic.html';
			opt.consent_file = './consent_basic.html';
			opt.use_vigilance = false;
			opt.paired = true;
		
		otherwise
			error(sprintf('no opts defined for experiment %s',expt_name));
	end
	
	opt.expt_name = expt_name;
end
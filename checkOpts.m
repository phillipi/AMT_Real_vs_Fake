function [] = checkOpts(opt)
	if (strcmp(opt.which_algs_paths,'unset'))
		error('must provide a list of algorithms to test');
	end
	if (strcmp(opt.ut_id,'unset'))
		error('must set a unique id for this HIT using http://uniqueturker.myleott.com/');
	end
	if (strcmp(opt.base_url,'unset'))
		error('must provide a url where test images are accessible');
	end
	if (strcmp(opt.instructions_file,'unset'))
		error('must provide a file containing html formatted instructions to display once at start of experiment');
	end
	if (strcmp(opt.short_instructions_file,'unset'))
		error('must provide a file containing html formatted instructions to display on each trial');
	end
	if (strcmp(opt.consent_file,'unset'))
		error('must provide a file containing html formatted infromed consent test, display at start of experiment');
	end
end
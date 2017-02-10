function [] = mk_expt(expt_name)
	
	%% expt parameters
	opt = getOpts(expt_name);
	
	%% check parameters
	checkOpts(opt);
	
	%% make dir for expt, overwriting if it already exists
	if (exist(opt.expt_name,'dir'))
		system(sprintf('rm -r ./%s',opt.expt_name));
	end
	mkdir(opt.expt_name);
	
	%%
	rng('shuffle');
	
	%% 
	csv_fname = fullfile(opt.expt_name,sprintf('expt_input_data.csv'));
	
	gt_side = {};
	images_left = {};
	images_right = {};
	
	for i=1:opt.Npairs
	    gt_side{1,i} = sprintf('gt_side%d',i);
	    images_left{1,i} = sprintf('images_left%d',i);
	    images_right{1,i} = sprintf('images_right%d',i);
	end
	
	for which_alg_curr=1:length(opt.which_algs_paths) % each trial tests just one alg
	    
	    for j=1:opt.Nhits_per_alg % same number of HITs for each alg
	        
	        which_imgs_alg = randperm(opt.Nimgs); which_imgs_alg = which_imgs_alg(1:opt.Npairs); % choose random set of images to test on, from test set
			which_imgs_gt = [];
			if (opt.paired)
				which_imgs_gt = which_imgs_alg;
			else
				which_imgs_gt = randperm(opt.Nimgs); which_imgs_gt = which_imgs_gt(1:opt.Npairs); % choose random set of images to test on, from test set
			end
			
	        for i=1:opt.Npairs
	            
				
	            if (opt.use_vigilance && (rand(1)<=opt.vigilance_freq)) % opt.vigilance_freq proportion of trials are vigilance checks
	                alg_im_name = sprintf('%s/%d',opt.vigilance_path,which_imgs_alg(i));
	            else
	                alg_im_name = sprintf('%s/%d',opt.which_algs_paths{which_alg_curr},which_imgs_alg(i));
	            end
	            
	            if (randi(2)==1) % randomize which side of UI gt is on
	                gt_side{(which_alg_curr-1)*opt.Nhits_per_alg+j+1,i} = 'left';
	                images_left{(which_alg_curr-1)*opt.Nhits_per_alg+j+1,i} = sprintf('%s/%d',opt.gt_path,which_imgs_gt(i));
	                images_right{(which_alg_curr-1)*opt.Nhits_per_alg+j+1,i} = alg_im_name;
	            else
	                gt_side{(which_alg_curr-1)*opt.Nhits_per_alg+j+1,i} = 'right';
	                images_left{(which_alg_curr-1)*opt.Nhits_per_alg+j+1,i} = alg_im_name;
	                images_right{(which_alg_curr-1)*opt.Nhits_per_alg+j+1,i} = sprintf('%s/%d',opt.gt_path,which_imgs_gt(i));
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
	html = fileread('index_template.html');
	
	html = strrep(html, '{{UT_ID}}', opt.ut_id);
	html = strrep(html, '{{BASE_URL}}', opt.base_url);
	
	html = strrep(html, '{{INSTRUCTIONS}}', fileread(opt.instructions_file));
	html = strrep(html, '{{SHORT_INSTRUCTIONS}}', fileread(opt.short_instructions_file));
	html = strrep(html, '{{CONSENT}}', fileread(opt.consent_file));
	
	html = strrep(html, '{{IM_DIV_HEIGHT}}', num2str(opt.im_height+2));
	html = strrep(html, '{{IM_DIV_WIDTH}}', num2str(opt.im_width+2));
	html = strrep(html, '{{IM_HEIGHT}}', num2str(opt.im_height));
	html = strrep(html, '{{IM_WIDTH}}', num2str(opt.im_width));
    
    html = strrep(html, '{{N_PRACTICE}}', num2str(opt.Npractice));
    html = strrep(html, '{{TOTAL_NUM_IMS}}', num2str(opt.Npairs));
	
	s = [];
	for i=1:opt.Npairs
	    s = cat(2,s,sprintf('sequence_helper("${gt_side%d}","${images_left%d}","${images_right%d}");\n',i,i,i));
	end
	html = strrep(html, '{{SEQUENCE}}', s);
	
	s = [];
	for i=1:opt.Npairs
	    s = cat(2,s,sprintf('<input type="hidden" name="selection%d" id="selection%d" value="unset">\n',i,i));
	end
	html = strrep(html, '{{SELECTION}}', s);
	
	fid = fopen(fullfile(opt.expt_name,'index.html'),'w');
	fprintf(fid,'%s',html);
	fclose(fid);
end
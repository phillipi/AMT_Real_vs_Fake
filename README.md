# AMT_Real_vs_Fake

Running "real vs fake" experiments on Amazon Mechanical Turk (AMT).

## Synopsis
Runs a series "real vs fake" trials. Each trial pits a real image against a generated image. 

## Usage
- Put all images to test in a web accessible folder. This folder should have subfolders for the results of each algorithm you would like to test. Must also contain a subfolder for the real images and (optionally) a folder for vigilance test images, which can be obviously fake images used to verify that the Turkers are paying attention. Images should be names "1.jpg", "2.jpg", etc, in consecutive order up to some total number of images N.
- Set experiment parameters by modifying "opt" in mk_expt.m.
- Run mk_expt.m to generate csv and index.html for Turk.
- Create experiment using AMT website or command line tools. Paste contents of index.html into HIT html code. Upload HIT data from the generated csv.

## Features
- Can enforce that each Turker can only do HIT once (uses http://uniqueturker.myleott.com/; see `opt.ut_id` in `getDefaultOpts`)
- Can run a multiple experiments at once, with each Turker being assigned a random experiment (this way the population is sampled iid w.r.t. time for each experiment)

## Citation

This tool was initially developed for ``Colorful Image Colorization".
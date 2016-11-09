# AMT_Real_vs_Fake

Running "real vs fake" experiments on Amazon Mechanical Turk.

# Synopsis
Runs a series "real vs fake" trials. Each trial pits a real image against a generated image. 

## Usage
- Put all images to test in a web accessible folder. This folder should have subfolders for the results of each algorithm you would like to test. Must also contain a subfolder for the real images and a folder for vigilance test images, which can be obviously fake images used to verify that the Turkers are paying attention.
- Set experiment parameters by modifying "opt" in mk_expt.m.
- Run mk_expt.m to generate csv and index.html for Turk.
- Create experiment on Turk. Paste contents of index.html into HIT html code. Upload HIT data from the generated csv.


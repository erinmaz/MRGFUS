#!/bin/bash
cd /Users/erin/Desktop/Projects/MRGFUS/development/Diffusion_Montreal/Subject053_forEM
fslroi eddy_corrected_data nodif 0 1
bet nodif nodif_brain -m -g 0.1 -f 0.3
mv *.eddy_rotated_bvecs bvecs
mv *.bval bvals
mv eddy_corrected_data.nii.gz data.nii.gz
bedpostx .


cd /Users/erin/Desktop/Projects/MRGFUS/development/Diffusion_Montreal 
mkdir concat
cut -f 1-60 -d " " Subject053_forEM/bvals > concat/bvals
#manually made 60 entry bvecs, cut didn't want to work for some reason
fslroi Subject053_forEM/data concat/data 0 60
cd concat
bedpostx .
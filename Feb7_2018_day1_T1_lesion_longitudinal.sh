#!/bin/bash

mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal
mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion
waytotal_pre=`more /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled/waytotal`

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths.nii.gz -div $waytotal_pre /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm

flirt -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms/diff_pre_2_T1_day1.mat -in /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm.nii.gz -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/T1.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre -interp nearestneighbour

waytotal_day1=`more /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/diffusion.bedpostX/T1_lesion_mask_filled/waytotal`

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths.nii.gz -div $waytotal_day1 /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm

flirt -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/diffusion/xfms/diff2str.mat -in  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm.nii.gz -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/T1.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_day1 -interp nearestneighbour


waytotal_3M=`more /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-12271/diffusion.bedpostX/T1_lesion_mask_filled/waytotal`

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-12271/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths.nii.gz -div $waytotal_3M /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-12271/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm

convert_xfm -omat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms/diff_3M_2_T1_day1.mat -concat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms/T1_3M_2_day1.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-12271/diffusion/xfms/diff2str.mat

flirt -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms/diff_3M_2_T1_day1.mat -in /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-12271/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm.nii.gz -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/T1.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_3M -interp nearestneighbour

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/mT1 /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/mT1

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/mT1 /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre -dr .01 .2 -cm red-yellow /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_day1 -dr 0.01 .2 -cm blue-lightblue /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_3M -dr 0.01 .2 -cm green

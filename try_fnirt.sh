fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/spm_mask -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9001_SH-11692/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/day1_mask

/usr/local/fsl/bin/fnirt --iout=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/day1_to_pre_warped --in=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/mT1 --inmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/day1_mask --aff=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/day1_to_pre_warp --jout=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/day1_to_pre_jac --config=T1_2_MNI152_2mm --ref=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/mT1  --refmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/spm_mask --warpres=10,10,10

invwarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/day1_to_pre_warp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/mT1 -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/pre_to_day1_warp

cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/first
#not sure when I ran this first analysis, it was already here
fslmaths first_all_fast_firstseg.nii.gz -thr 9.5 -uthr 10.5 -bin first_L_thal 
fslmaths first_all_fast_firstseg.nii.gz -thr 48.5 -uthr 49.5 -bin first_R_thal

applywarp -i first_L_thal -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/pre_to_day1_warp -o first_L_thal_to_day1 -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/mT1

applywarp -i first_L_thal -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/pre_to_day1_warp -o first_L_thal_to_day1_nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/mT1 --interp=nn

fslmaths first_L_thal_to_day1 -thr 0.5 -bin first_L_thal_to_day1_thr_bin
fslstats first_L_thal_to_day1_nn -V
fslstats first_L_thal_to_day1_thr_bin -V
fslstats first_L_thal -V
###### MAKE FIGURES ######################################################################

#THIS FIGURE HASN'T CHANGED, DON'T HAVE TO RERUN

mkdir ${CURRENT_ANALYSIS}/figure_lesion
mkdir ${CURRENT_ANALYSIS}/figure_lesion/9001
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9001/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9001/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9001/.
applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9001_SH-11692/anat/T1_lesion_mask_filled -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1 -o ${CURRENT_ANALYSIS}/figure_lesion/9001/lesion_day1_2_pre --interp=nn

applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9001_SH-12271/anat/T1_lesion_mask_filled -r  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1 -o ${CURRENT_ANALYSIS}/9001/figure_lesion/lesion_month3_2_pre --interp=nn

fsleyes ${CURRENT_ANALYSIS}/figure_lesion/9001/*.nii.gz

mkdir ${CURRENT_ANALYSIS}/figure_lesion/9004
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/anat/T1.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9004/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9004/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9004/.
applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9004_EP-12203/anat/T1_lesion_mask_filled -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/anat/T1 -o ${CURRENT_ANALYSIS}/figure_lesion/9004/lesion_day1_2_pre --interp=nn

applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9004_EP-12955/anat/T1_lesion_mask_filled -r  /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/anat/T1 -o ${CURRENT_ANALYSIS}/figure_lesion/9004/lesion_month3_2_pre --interp=nn

fsleyes ${CURRENT_ANALYSIS}/figure_lesion/9004/*.nii.gz




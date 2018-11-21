pre=$1
day1=$2

vol=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${day1}/anat/T1_lesion_mask_filled.nii.gz -V`
vol_in_thal=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${day1}/anat/T1_lesion_mask_filled.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_R_thal_to_month3_thr_bin -V`

echo $pre $vol ${vol_in_thal}


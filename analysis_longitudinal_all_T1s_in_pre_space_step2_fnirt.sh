sub=$1
pre=${sub}-$2
day1=${sub}-$3
month3=${sub}-$4

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${day1}/anat/spm_mask -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${day1}/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_mask

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/spm_mask -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${month3}/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_mask

/usr/local/fsl/bin/fnirt --iout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warped --in=/Users/erin/Desktop/Projects/MRGFUS/analysis/${day1}/anat/mT1 --inmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_mask --aff=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warp --jout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_jac --config=T1_2_MNI152_2mm --ref=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1  --refmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/spm_mask --warpres=10,10,10 &

/usr/local/fsl/bin/fnirt --iout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warped --in=/Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/mT1 --inmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_mask --aff=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warp --jout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_jac --config=T1_2_MNI152_2mm --ref=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1  --refmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/spm_mask --warpres=10,10,10

wait

invwarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${day1}/anat/mT1 -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_day1_warp

invwarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/mT1 -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_month3_warp

wait 

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1 /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warped /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warped &

done
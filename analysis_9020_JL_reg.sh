#!/bin/bash

#for f in 9020_JL-14121 9020_JL-14340 9020_JL-14836
for f in 9020_JL-14340 9020_JL-14836
do
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/anat

flirt -in flair -ref T1 -out xfms/flair2T1 -omat xfms/flair2T1.mat -dof 6 -nosearch
fsleyes xfms/flair2T1 T1

flirt -in SWAN_mag -ref T1 -out xfms/SWAN_mag2T1 -omat xfms/SWAN_mag2T1.mat -dof 6 -nosearch 
fsleyes xfms/SWAN_mag2T1 T1

flirt -applyxfm -init xfms/SWAN_mag2T1.mat -in SWAN_phase -out xfms/SWAN_phase2T1 -ref T1

flirt -applyxfm -init xfms/SWAN_mag2T1.mat -in SWAN_MIN_IP -out xfms/SWAN_MIN_IP2T1 -ref T1
done

cd /Users/erin/Desktop/Projects/MRGFUS/analysis

#bring everything into T1 pre space
pre=9020_JL-14121
day1=9020_JL-14340 
month3=9020_JL-14836
sub=9020_JL
mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat
applywarp -i ${day1}/anat/flair --premat=${day1}/anat/xfms/flair2T1.mat -w 9020_JL_longitudinal_xfms_T1/day1_to_pre_warp -r ${pre}/anat/T1 -o 9020_JL_longitudinal_xfms_anat/flair_day1_2_T1_pre
fsleyes 9020_JL_longitudinal_xfms_anat/flair_day1_2_T1_pre ${pre}/anat/T1


#month3 to pre warp is missing - generate (copied and modified line from analysis_fnirt_no_first.sh)
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/spm_mask -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${month3}/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_mask

/usr/local/fsl/bin/fnirt --iout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warped --in=/Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/mT1 --inmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_mask --aff=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warp --jout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_jac --config=T1_2_MNI152_2mm --ref=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1  --refmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/spm_mask --warpres=10,10,10

applywarp -i ${month3}/anat/flair --premat=${month3}/anat/xfms/flair2T1.mat -w 9020_JL_longitudinal_xfms_T1/month3_to_pre_warp -r ${pre}/anat/T1 -o 9020_JL_longitudinal_xfms_anat/flair_month3_2_T1_pre
fsleyes 9020_JL_longitudinal_xfms_anat/flair_month3_2_T1_pre ${pre}/anat/T1

applywarp -i ${day1}/anat/SWAN_mag --premat=${day1}/anat/xfms/SWAN_mag2T1.mat -w 9020_JL_longitudinal_xfms_T1/day1_to_pre_warp -r ${pre}/anat/T1 -o 9020_JL_longitudinal_xfms_anat/SWAN_mag_day1_2_T1_pre
fsleyes 9020_JL_longitudinal_xfms_anat/SWAN_mag_day1_2_T1_pre ${pre}/anat/T1

applywarp -i ${month3}/anat/SWAN_mag --premat=${month3}/anat/xfms/SWAN_mag2T1.mat -w 9020_JL_longitudinal_xfms_T1/month3_to_pre_warp -r ${pre}/anat/T1 -o 9020_JL_longitudinal_xfms_anat/SWAN_mag_month3_2_T1_pre
fsleyes 9020_JL_longitudinal_xfms_anat/SWAN_mag_month3_2_T1_pre ${pre}/anat/T1

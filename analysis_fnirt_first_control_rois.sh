#run after analysis_fnirt_first

pre=$1
day1=$2
month3=$3
sub=$4

#mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first
#run_first_all -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1 -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first &

#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${day1}/anat/spm_mask -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${day1}/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_mask

#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/spm_mask -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${month3}/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_mask

#/usr/local/fsl/bin/fnirt --iout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warped --in=/Users/erin/Desktop/Projects/MRGFUS/analysis/${day1}/anat/mT1 --inmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_mask --aff=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warp --jout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_jac --config=T1_2_MNI152_2mm --ref=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1  --refmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/spm_mask --warpres=10,10,10 &

#/usr/local/fsl/bin/fnirt --iout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warped --in=/Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/mT1 --inmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_mask --aff=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warp --jout=/Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_jac --config=T1_2_MNI152_2mm --ref=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1  --refmask=/Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/spm_mask --warpres=10,10,10

#wait

#invwarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${day1}/anat/mT1 -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_day1_warp

#invwarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${month3}/anat/mT1 -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_month3_warp

#wait 

#fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/mT1 /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/day1_to_pre_warped /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/month3_to_pre_warped /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_all_fast_firstseg &

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_all_fast_firstseg.nii.gz -thr 50.5 -uthr 51.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_R_putamen 
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_all_fast_firstseg.nii.gz -thr 11.5 -uthr 12.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_L_putamen

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_all_fast_firstseg.nii.gz -thr 52.5 -uthr 53.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_R_hipp 
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_all_fast_firstseg.nii.gz -thr 16.5 -uthr 17.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_L_hipp

for side in L R
do
for roi in putamen hipp
do
echo first_${side}_${roi} `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi} -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_${roi}_vol.txt
for tp in day1 month3
do
applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi} -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_${tp}_warp -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi}_to_${tp} -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${!tp}/anat/mT1

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi}_to_${tp} -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi}_to_${tp}_thr_bin

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi} -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_${tp}_warp -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi}_to_${tp}_nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${!tp}/anat/mT1 --interp=nn

echo first_${side}_${roi}_to_${tp}_nn `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi}_to_${tp}_nn -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_${roi}_vol.txt
echo first_${side}_${roi}_to_${tp}_thr_bin `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_${roi}_to_${tp}_thr_bin -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_${roi}_vol.txt

done
done
done
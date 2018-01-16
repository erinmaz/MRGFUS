#!/bin/bash

mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
for f in 9001_SH-11692 9002_RA-11833 9003_RB-12064 9004_EP-12203 9006_EO-12487 9007_RB-12910 9008_JO-12667
do
mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}
mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}/anat
cp /Users/erin/Desktop/Projects/MRGFUS/analysis_UBUNTU_has_lesion_masks/${f}/anat/SWAN_mag_lesion_mask.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis_UBUNTU_has_lesion_masks/${f}/anat/T1_lesion_mask_filled.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis_UBUNTU_has_lesion_masks/${f}/anat/T1.nii /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis_UBUNTU_has_lesion_masks/${f}/anat/T1.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis_UBUNTU_has_lesion_masks/${f}/anat/SWAN_mag.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${f}/anat/.
done
rm /Users/erin/Desktop/Projects/MRGFUS/analysis_UBUNTU_has_lesion_masks/9008_JO-12667/anat/T1.nii 
f=9009_CRB-13043_has_lesion_mask
g=9009_CRB-13043
mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${g}
mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${g}/anat
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/anat/SWAN_mag_lesion_mask.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${g}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/anat/T1_lesion_mask_filled.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${g}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/anat/T1.nii /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${g}/anat/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/anat/SWAN_mag.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${g}/anat/.
#!/bin/bash

bet /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-07457/anat/ANONYMIZED_s3_e1_susan.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-07457/anat/ANONYMIZED_s3_e1_susan_brain.nii.gz -m 

flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-07457/anat/ANONYMIZED_s3_e1_susan_brain -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14121/anat/T1_brain -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/preSRS_to_pre_6dof -omat /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/preSRS_to_pre_6dof.mat -dof 6 

for f in 9020_JL-14121 9020_JL-14340 9020_JL-14836
do
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/anat

flirt -in flair -ref T1 -out xfms/flair2T1 -omat xfms/flair2T1.mat -dof 6 -nosearch
fsleyes xfms/flair2T1 T1 &

flirt -in SWAN_mag -ref T1 -out xfms/SWAN_mag2T1 -omat xfms/SWAN_mag2T1.mat -dof 6 -nosearch 
fsleyes xfms/SWAN_mag2T1 T1 &

flirt -applyxfm -init xfms/SWAN_mag2T1.mat -in SWAN_phase -out xfms/SWAN_phase2T1 -ref T1

flirt -applyxfm -init xfms/SWAN_mag2T1.mat -in SWAN_MIN_IP -out xfms/SWAN_MIN_IP2T1 -ref T1
done

cd /Users/erin/Desktop/Projects/MRGFUS/analysis

#bring everything into T1 pre space

mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat

convert_xfm -omat /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_day1_2_T1_pre.mat -concat /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat  /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14340/anat/xfms/flair2T1.mat

flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14340/anat/flair.nii.gz -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_day1_2_T1_pre.mat -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14121/anat/T1.nii.gz  -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_day1_2_T1_pre


convert_xfm -omat /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_month3_2_T1_pre.mat -concat /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat  /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14836/anat/xfms/flair2T1.mat

flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14836/anat/flair.nii.gz -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_month3_2_T1_pre.mat -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14121/anat/T1.nii.gz  -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_month3_2_T1_pre

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_day1_2_T1_pre.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_anat/flair_month3_2_T1_pre.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14121/anat/xfms/flair2T1.nii.gz

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/preSRS_to_pre_6dof.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9020_JL-14121/anat/mT1_brain.nii.gz
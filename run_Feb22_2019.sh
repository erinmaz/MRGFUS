#!/bin/bash

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
analysis_longitudinal_diffusion_in_pre_T1_space.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done


epi_reg --epi=/Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/diffusion/mean_b0_unwarped --t1=/Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/anat/T1 --t1brain=/Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/anat/T1_brain --out=/Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/diffusion/xfms/diff_2_T1_bbr
convert_xfm -omat /Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/diffusion/xfms/T1_2_diff_bbr.mat -inverse /Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/diffusion/xfms/diff_2_T1_bbr.mat
fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/diffusion/xfms/diff_2_T1_bbr /Users/erin/Desktop/Projects/MRGFUS/analysis/9010_RR-13536/anat/T1 &


for MYSUB in 9010_RR 9011_BB 9016_EB 9021_WM 
do
mkdir ~/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal
analysis_longitudinal_diffusion_in_pre_T1_space.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done


analysis_flip_day1_lesion_into_other_hemisphere.sh
analysis_Kwon_ROIs_probtrackx_thalterm_check_lesion_overlap.sh

analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts.sh 9001_SH 11644 11692

#NEED TO RUN
for MYSUB in 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done
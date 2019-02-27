#!/bin/bash
# For new manucript
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

MYSUB=9010_RR
analysis_longitudinal_diffusion_in_pre_T1_space.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`

analysis_flip_day1_lesion_into_other_hemisphere.sh
analysis_Kwon_ROIs_probtrackx_thalterm_check_lesion_overlap.sh

analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts.sh 9001_SH 11644 11692
analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts.sh 9005_BG 13004 13126


for MYSUB in 9002_RA 9004_EP 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
analysis_Kwon_ROIs_probtrackx_thalterm_mark_SCP_decus.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done

for MYSUB in 9002_RA 9004_EP 9006_EO 9007_RB 9009_CRB 9010_RR 9013_JD 9016_EB 9021_WM 
do
analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done

MYSUB=9011_BB 
analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`


mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_thalterm
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
analysis_Kwon_ROIs_probtrackx_thalterm_get_results.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh` /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results/${MYSUB}_results_260219
done

rm /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_thalterm/*_L_*
rm /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_thalterm/*_R_*
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_thalterm
paste `ls -d *d2s` > results_d2s
paste `ls -d *s2l` > results_s2l



analysis_Kwon_ROIs_probtrackx_lesionterm.sh

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
analysis_Kwon_ROIs_probtrackx_lesionterm_split_tracts.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh` 
done

mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_lesionterm
for MYSUB in 9001_SH 9002_RA 9004_EP 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
analysis_Kwon_ROIs_probtrackx_lesionterm_get_results.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh` /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_lesionterm/${MYSUB}_results_260219
done
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/analysis_Kwon_ROIs_probtrackx_results_lesionterm 
paste `ls -d *d2s` > results_d2s
paste `ls -d *s2l` > results_s2l

analysis_diffusion_run_tbss_preproc_022619.sh
cd /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/stats
randomise -i all_FA_skeletonised.nii.gz -o tbss_day1 -m mean_FA_skeleton_mask -d ../models/preday1.mat -t ../models/preday1.con -n 5000 --T2 -e ../models/preday1.grp 
randomise -i all_FA_skeletonised.nii.gz -o tbss_month3 -m mean_FA_skeleton_mask -d ../models/premonth3.mat -t ../models/premonth3.con -n 5000 --T2 -e ../models/premonth3.grp

mkdir uncor
cd uncor
randomise -i ../all_FA_skeletonised.nii.gz -o tbss_day1 -m ../mean_FA_skeleton_mask -d ../../models/preday1.mat -t ../../models/preday1.con -n 5000 --T2 -e ../../models/preday1.grp --uncorrp

randomise -i ../all_FA_skeletonised.nii.gz -o tbss_month3 -m ../mean_FA_skeleton_mask -d ../../models/premonth3.mat -t ../../models/premonth3.con -n 5000 --T2 -e ../../models/premonth3.grp --uncorrp
#!/bin/bash
# For new manuscript
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
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
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

cd /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/stats
mkdir /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/diff_month3_minus_baseline
fslsplit all_FA_skeletonised.nii.gz /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/diff_month3_minus_baseline/FA_skeletonized -t
cd  /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/diff_month3_minus_baseline
fslmaths FA_skeletonized0002 -sub FA_skeletonized0000 9001_SH
fslmaths FA_skeletonized0005 -sub FA_skeletonized0003 9002_RA
fslmaths FA_skeletonized0008 -sub FA_skeletonized0006 9004_EP
fslmaths FA_skeletonized0011 -sub FA_skeletonized0009 9005_BG
fslmaths FA_skeletonized0014 -sub FA_skeletonized0012 9006_EO
fslmaths FA_skeletonized0017 -sub FA_skeletonized0015 9007_RB
fslmaths FA_skeletonized0020 -sub FA_skeletonized0018 9009_CRB
fslmaths FA_skeletonized0023 -sub FA_skeletonized0021 9010_RR
fslmaths FA_skeletonized0026 -sub FA_skeletonized0024 9011_BB
fslmaths FA_skeletonized0029 -sub FA_skeletonized0027 9013_JD
fslmaths FA_skeletonized0032 -sub FA_skeletonized0030 9016_EB
fslmaths FA_skeletonized0035 -sub FA_skeletonized0033 9021_WM
rm *skeletonized* 
fslmerge -t all_skeletonized `ls`
Glm_gui # to make model

randomise -i all_skeletonized -o tbss_month3_crst -m /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/stats/mean_FA_skeleton_mask -d /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/models/CRST_diff.mat -t /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/models/CRST_diff.con -n 5000 --T2 --uncorrp
 
OUTPUT NOTE FROM TERMINAL: 4096 sign-flips required for exhaustive test of t-test 1
Doing all 4096 unique permutations

 
 
#Before I do this, I need to run/find registrations with lesions masked out. 
#May want to rerun TBSS reg step with the masks too.... 
analysis_generate_lesion_heatmap_and_CoM.sh lesions_022719
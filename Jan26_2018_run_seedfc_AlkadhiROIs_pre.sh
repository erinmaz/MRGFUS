#!/bin/bash


analysis_seedfc_step1A_standardspace.sh 9001_SH-11644 12ch /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/L_hand_COG_8mm.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs.feat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg

analysis_seedfc_step1A_standardspace.sh 9001_SH-11644 12ch /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/L_foot_COG_8mm.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs.feat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg

analysis_seedfc_step1A_standardspace.sh 9001_SH-11644 12ch /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/L_tongue_COG_8mm.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs.feat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg

for roi in L_hand_COG_8mm L_foot_COG_8mm L_tongue_COG_8mm
do
for f in 9002_RA-11764 9003_RB-12013 9004_EP-12126 9006_EO-12389 9008_JO-12613 9009_CRB-12609
do
analysis_seedfc_step1A_standardspace.sh $f 12ch /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/${roi} /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/fmri/rs.feat /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/fmri/rs_reg.feat/reg &
done
wait
done
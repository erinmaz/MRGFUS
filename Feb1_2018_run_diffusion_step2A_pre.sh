#!/bin/bash
for f in 9006_EO-12389 9008_JO-12613 9009_CRB-12609 9010_RR-13130
do
analysis_diffusion_step2A_standardspace.sh $f /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/L_hand_COG_8mm.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/diffusion/xfms/str2diff.mat
analysis_diffusion_step2A_standardspace.sh $f /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/L_foot_COG_8mm.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/diffusion/xfms/str2diff.mat
analysis_diffusion_step2A_standardspace.sh $f /Users/erin/Desktop/Projects/MRGFUS/scripts/AlkadhiSomatotopy/L_tongue_COG_8mm.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}/diffusion/xfms/str2diff.mat
done

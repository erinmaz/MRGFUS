#for new manuscript

#!/bin/bash

analysis_ants_reg.sh

#rerun thalterm tractography using ants to get thalamus into diffusion space
#rerun tbss with inmasks
#rerun lesion heatmaps and CoM calculations

mkdir /Users/erin/Desktop/Projects/MRGFUS/tbss_022719
cp -r /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/origdata/*  /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/.
cd Users/erin/Desktop/Projects/MRGFUS/tbss_022719
tbss_1_preproc *.nii.gz

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
pre_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
day1_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 
for exam in $pre_exam $day1_exam $month3_exam
do
#grab everyone's ants inmask if it exists
if [ -f /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/anat/xfms/ants/inmask.nii.gz ] ; then
flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/anat/xfms/ants/inmask -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/diffusion/mean_b0_unwarped -o /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/FA/${MYSUB}-${exam}_FA_FA_inmask -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/diffusion/xfms/T1_2_diff_bbr.mat -interp nearestneighbour
fi

done
done

tbss_2_reg_inmask.sh

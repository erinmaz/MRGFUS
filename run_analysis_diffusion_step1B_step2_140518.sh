#!/bin/bash 

# 05/14/2018

# QA.sh already run for everyone
# analysis_diffusion_step1A_bedpostX.sh already run for everyone
# analysis_step1_T1_lesion_trace.sh already run for everyone

#first edit analysis_diffusion_step1B_run_tbss_preproc.sh to include new runs. 
#9008 is not in TBSS although I have processed it below.
analysis_diffusion_step1B_run_tbss_preproc.sh tbss_140518

# Need to clean up longitudinal transforms and re-run for all
cd /Users/erin/Desktop/Projects/MRGFUS/analysis
for f in `ls -d *longitudinal_xfms`
do
mv $f ${f}_bk
done

analysis_longitudinal_step1.sh 9001_SH 11644 11692
analysis_longitudinal_step1.sh 9002_RA 11764 11833
analysis_longitudinal_step1.sh 9004_EP 12126 12203
analysis_longitudinal_step1.sh 9005_BG 13004 13126 
analysis_longitudinal_step1.sh 9006_EO 12389 12487
analysis_longitudinal_step1.sh 9007_RB 12461 12910 
analysis_longitudinal_step1.sh 9008_JO 12613 12667 
analysis_longitudinal_step1.sh 9009_CRB 12609 13043

analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9001_SH 11644 11692 tracking_day1_lesion_140518 L
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9002_RA 11764 11833 tracking_day1_lesion_140518 L
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9004_EP 12126 12203 tracking_day1_lesion_140518 L
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9005_BG 13004 13126 tracking_day1_lesion_140518 R
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9006_EO 12389 12487 tracking_day1_lesion_140518 L
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9007_RB 12461 12910 tracking_day1_lesion_140518 R
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9008_JO 12613 12667 tracking_day1_lesion_140518 L
analysis_diffusion_step2_track_pre_from_day1_lesion.sh 9009_CRB 12609 13043 tracking_day1_lesion_140518 L


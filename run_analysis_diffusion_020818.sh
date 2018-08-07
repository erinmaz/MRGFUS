#!/bin/bash 

# 17/07/2018

# QA.sh already run for everyone
# analysis_diffusion_step1A_bedpostX.sh already run for everyone
# analysis_step1_T1_lesion_trace.sh already run for everyone
# analysis_longitudinal_step1.sh already run for everyone

analysis_diffusion_step2_track_pre_atlas_seeds_lesion_waypoint_and_exclude.sh 9001_SH 11644 11692 020818 L tbss_160718 /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz
analysis_diffusion_step2_track_pre_atlas_seeds_lesion_waypoint_and_exclude.sh 9002_RA 11764 11833 020818 L tbss_160718 /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz


analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9002_RA 11764 11833 tracking_atlasROIs_300718 L tbss_160718
analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9004_EP 12126 12203 tracking_atlasROIs_300718 L tbss_160718
analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9005_BG 13004 13126 tracking_atlasROIs_300718 R tbss_160718
analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9006_EO 12389 12487 tracking_atlasROIs_300718 L tbss_160718
analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9007_RB 12461 12910 tracking_atlasROIs_300718 R tbss_160718
analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9009_CRB 12609 13043 tracking_atlasROIs_300718 L tbss_160718
analysis_diffusion_step2_track_pre_atlas_seeds_dentate_exclude_contra.sh 9013_JD 13455 13722 tracking_atlasROIs_300718 L tbss_160718

analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9001_SH 11644 11692 tracking_atlasROIs_300718 
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9002_RA 11764 11833 tracking_atlasROIs_300718 
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9004_EP 12126 12203 tracking_atlasROIs_300718 
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9005_BG 13004 13126 tracking_atlasROIs_300718 
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9006_EO 12389 12487 tracking_atlasROIs_300718 
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9007_RB 12461 12910 tracking_atlasROIs_300718 
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9009_CRB 12609 13043 tracking_atlasROIs_300718
analysis_diffusion_step2b_get_overlap_atlas_tracts.sh 9013_JD 13455 13722 tracking_atlasROIs_300718

analysis_diffusion_step3_atlasROIs_get_summary_stats_from_TBSS_images.sh tracking_atlasROIs_300718 tbss_160718

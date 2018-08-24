analysis_mrtrix_basic_tensor.sh 9001_SH-11644 L R
analysis_mrtrix_basic_tensor.sh 9002_RA-11764 L R
analysis_mrtrix_basic_tensor.sh 9004_EP-12126 L R
analysis_mrtrix_basic_tensor.sh 9005_BG-13004 R L
analysis_mrtrix_basic_tensor.sh 9006_EO-12389 L R
analysis_mrtrix_basic_tensor.sh 9007_RB-12461 R L
analysis_mrtrix_basic_tensor.sh 9009_CRB-12609 L R
analysis_mrtrix_basic_tensor.sh 9013_JD-13455 L R

analysis_mrtrix_checkclean.sh 9001_SH-11644 L R 
analysis_mrtrix_checkclean.sh 9002_RA-11764 L R
analysis_mrtrix_checkclean.sh 9004_EP-12126 L R
analysis_mrtrix_checkclean.sh 9005_BG-13004 R L
analysis_mrtrix_checkclean.sh 9006_EO-12389 L R 
analysis_mrtrix_checkclean.sh 9007_RB-12461 R L 
analysis_mrtrix_checkclean.sh 9009_CRB-12609 L R 
analysis_mrtrix_checkclean.sh 9013_JD-13455 L R

analysis_mrtrix_gettckinfo.sh 9001_SH-11644 
analysis_mrtrix_gettckinfo.sh 9002_RA-11764
analysis_mrtrix_gettckinfo.sh 9004_EP-12126
analysis_mrtrix_gettckinfo.sh 9005_BG-13004
analysis_mrtrix_gettckinfo.sh 9006_EO-12389
analysis_mrtrix_gettckinfo.sh 9007_RB-12461
analysis_mrtrix_gettckinfo.sh 9009_CRB-12609
analysis_mrtrix_gettckinfo.sh 9013_JD-13455

analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9001_SH-11644 9001_SH-11692 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9002_RA-11764 9002_RA-11833 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9004_EP-12126 9004_EP-12203 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9005_BG-13004 9005_BG-13126 R 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9006_EO-12389 9006_EO-12487 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9007_RB-12461 9007_RB-12910 R  
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9009_CRB-12609 9009_CRB-13043 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9013_JD-13455 9013_JD-13722 L  

analysis_mrtrix_get_summary_stats_from_TBSS_images.sh tbss_160718

analysis_mrtrix_along_tract_pre_T1_space.sh 9001_SH 11644 11692 12271
#manually pick a start and end that aren't too close to the extremes of the tract
#based on include_lesion_clean_nocerebellum_t1space track
tckresample -line 100 -3,35,-23 -13,31,47 /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck -force

analysis_mrtrix_tcksample_line.sh 9001_SH 11644 rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck

analysis_mrtrix_along_tract_pre_T1_space.sh 9002_RA 11764 11833 12388
tckresample -line 100 -1,27,-29 -16,8,38 /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck -force
analysis_mrtrix_tcksample_line.sh 9002_RA 11764 rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck

analysis_mrtrix_along_tract_pre_T1_space.sh 9004_EP 12126 12203 12955
tckresample -line 100 2,52,-20 -6,38,42 /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck -force
analysis_mrtrix_tcksample_line.sh 9004_EP 12126 rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck

analysis_mrtrix_along_tract_pre_T1_space.sh 9005_BG 13004 13126 13837 
analysis_mrtrix_along_tract_pre_T1_space.sh 9006_EO 12389 12487 13017

tckresample -line 100 -6,35,-1 -8,17,70 /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck -force
analysis_mrtrix_tcksample_line.sh 9006_EO 12389 rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck

analysis_mrtrix_along_tract_pre_T1_space.sh 9007_RB 12461 12910 13055
analysis_mrtrix_along_tract_pre_T1_space.sh 9009_CRB 12609 13043 13623
analysis_mrtrix_along_tract_pre_T1_space.sh 9013_JD 13455 13722 14227












tckresample -line 100 10,34,-29 10,29,49 /Users/erin/Desktop/Projects/MRGFUS/analysis/9005_BG-13004/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9005_BG-13004/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck -force












tckresample -line -1,37,-21 -12,31,55 /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space_line.tck -force

analysis_mrtrix_basic_tensor.sh 9002_RA-11764 L R
analysis_mrtrix_basic_tensor.sh 9001_SH-11644 L R
analysis_mrtrix_basic_tensor.sh 9004_EP-12126 L R
analysis_mrtrix_basic_tensor.sh 9005_BG-13004 R L
analysis_mrtrix_basic_tensor.sh 9006_EO-12389 L R
analysis_mrtrix_basic_tensor.sh 9007_RB-12461 R L
analysis_mrtrix_basic_tensor.sh 9009_CRB-12609 L R
analysis_mrtrix_basic_tensor.sh 9013_JD-13455 L R


#fix tracks that are orig

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mean_b0_unwarped

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/exclude -add /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/manual_exclude  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final

tckedit -exclude /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck

tckmap -template /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain_mask.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz 

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz 

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mean_b0_unwarped /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/exclude -add /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/manual_exclude  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final

tckedit -exclude /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck

tckedit -exclude /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_fix.tck

tckmap -template /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/nodif_brain_mask.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz 

tckmap -template /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/nodif_brain_mask.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_fix.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_fix.nii.gz 

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/nodif_brain /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_fix.nii.gz 

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mean_b0_unwarped /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/exclude -add /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/manual_exclude  /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final

tckedit -exclude /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/exclude_final.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck

tckmap -template /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/nodif_brain_mask.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz 

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mean_b0_unwarped /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion


mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_orig.nii.gz
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz  /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.nii.gz 

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion.nii.gz  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_orig.nii.gz 
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_fix.nii.gz  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion.nii.gz 

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.nii.gz  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_orig.nii.gz 
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.nii.gz 

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_orig.nii.gz
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.nii.gz

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_orig.tck
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9009_CRB-12609/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck 

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_orig.tck 
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion_fix.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_exclude_lesion.tck 

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_orig.tck 
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck 

mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_orig.tck
mv /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion_fix.tck /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/rtt_from_cortex_include_lesion.tck

analysis_mrtrix_basic_tensor_getoverlap.sh 9001_SH-11644 L R
analysis_mrtrix_basic_tensor_getoverlap.sh 9002_RA-11764 L R
analysis_mrtrix_basic_tensor_getoverlap.sh 9004_EP-12126 L R
analysis_mrtrix_basic_tensor_getoverlap.sh 9005_BG-13004 R L
analysis_mrtrix_basic_tensor_getoverlap.sh 9006_EO-12389 L R
analysis_mrtrix_basic_tensor_getoverlap.sh 9007_RB-12461 R L
analysis_mrtrix_basic_tensor_getoverlap.sh 9009_CRB-12609 L R
analysis_mrtrix_basic_tensor_getoverlap.sh 9013_JD-13455 L R

analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9001_SH-11644 9001_SH-11692 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9002_RA-11764 9002_RA-11833 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9004_EP-12126 9004_EP-12203 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9005_BG-13004 9005_BG-13126 R 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9006_EO-12389 9006_EO-12487 L 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9007_RB-12461 9007_RB-12910 R 
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9009_CRB-12609 9009_CRB-13043 L
analysis_mrtrix_basic_tensor_getroisforsummarystats.sh 9013_JD-13455 9013_JD-13722 L 

analysis_mrtrix_get_summary_stats_from_TBSS_images.sh tbss160718



MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
flirt -in ${MAINDIR}/9001_SH-11692/diffusion/dtifit_MD.nii.gz -ref ${MAINDIR}/9001_SH-11644/diffusion/mean_b0_unwarped -applyxfm -init ${MAINDIR}/9001_SH_longitudinal_xfms/diff_day1_to_pre.mat -out ${MAINDIR}/9001_SH_diffusion_longitudinal/MD_day1_to_pre
flirt -in ${MAINDIR}/9001_SH-11692/diffusion/dtifit_FA.nii.gz -ref ${MAINDIR}/9001_SH-11644/diffusion/mean_b0_unwarped -applyxfm -init ${MAINDIR}/9001_SH_longitudinal_xfms/diff_day1_to_pre.mat -out ${MAINDIR}/9001_SH_diffusion_longitudinal/FA_day1_to_pre

 erin$ convert_xfm -omat diff_day1_2_T1_pre.mat -concat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/xfms/diff_2_T1_bbr.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms/diff_day1_to_pre.mat
 
transformconvert /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms/diff_day1_2_T1_pre.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/diffusion/mean_b0_unwarped.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/mT1.nii.gz flirt_import /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/mrtrix_basic_tensor_det_exclude/day1_diff_2_pre_T1_bbr_mrtrix.txt 

 mrtransform -linear pre_diff_2_T1_bbr_mrtrix.txt -template /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/mT1.nii.gz  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/dtifit_FA.nii.gz pre_FA_pre_T1.nii.gz -force
 
 tckresample -num_points 50 rtt_from_cortex_include_lesion.tck rtt_from_cortex_include_lesion_resample_line_50.tck -force


 tcksample rtt_from_cortex_include_lesion_resample_line_50.tck ../dtifit_FA.nii.gz rtt_from_cortex_include_lesion_resample_50_FA_pre.txt -force



 sed "s/^[ \t]*//" rtt_from_cortex_include_lesion_resample_50_FA_day1.txt > rtt_from_cortex_include_lesion_resample_50_FA_day1_remove_leading_white.txt


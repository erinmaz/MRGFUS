analysis_diffusion_step3_day1_T1_lesion_2_pre.sh 9006_EO 12389 12487 /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9006_EO-12487/anat/T1_lesion_mask_filled.nii.gz

fslmaths harvardoxford-subcortical_prob_Left_Cerebral_Cortex.nii.gz -thr 2 -bin harvardoxford-subcortical_prob_Left_Cerebral_Cortex_thr2

applywarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical_prob_Left_Cerebral_Cortex_thr2.nii.gz --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/xfms/str2diff.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/HO_SC_LCC --interp=nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain.nii.gz 


/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/T1_lesion_mask_filled.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_LCC --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_LCC/waypoints.txt  --waycond=AND
Log directory is: /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_LCC


fslmaths harvardoxford-subcortical_prob_Right_Cerebral_Cortex.nii.gz -thr 2 -bin harvardoxford-subcortical_prob_Right_Cerebral_Cortex_thr2

applywarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical_prob_Right_Cerebral_Cortex_thr2.nii.gz --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/xfms/str2diff.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/HO_SC_RCC --interp=nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain.nii.gz 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/juelich_prob_WM_Callosal_body.nii.gz -mas /Users/erin/Desktop/Projects/MRGFUS/scripts/mask_MNI2mm_R.nii.gz -bin /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/juelich_prob_WM_Callosal_body_R


applywarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/juelich_prob_WM_Callosal_body_R --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/xfms/str2diff.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/juelich_prob_WM_Callosal_body_R --interp=nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain.nii.gz

fslmaths /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum.nii.gz  -thr 10 -bin /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10

fslmaths /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10 -mas /Users/erin/Desktop/Projects/MRGFUS/scripts/mask_MNI2mm_R /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_R

applywarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_R --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/xfms/str2diff.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/mni_prob_Cerebellum_thr10_R --interp=nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain.nii.gz


mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_R_cerebellum_exclude_R_corpus_callosum
/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/T1_lesion_mask_filled.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/juelich_prob_WM_Callosal_body_R.nii.gz --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_R_cerebellum_exclude_R_corpus_callosum --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_R_cerebellum_exclude_R_corpus_callosum/waypoints.txt  --waycond=AND


fslmaths /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10 -mas /Users/erin/Desktop/Projects/MRGFUS/scripts/mask_MNI2mm_L /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_L


applywarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_L --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/xfms/str2diff.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/mni_prob_Cerebellum_thr10_L --interp=nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/nodif_brain.nii.gz

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/juelich_prob_WM_Callosal_body_R.nii.gz -add /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/mni_prob_Cerebellum_thr10_L /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/exclude_L_cerebellum_R_callosal_body

mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_R_cerebellum_exclude_R_corpus_callosum_L_cerebellum
/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/T1_lesion_mask_filled.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/exclude_L_cerebellum_R_callosal_body.nii.gz --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_R_cerebellum_exclude_R_corpus_callosum_L_cerebellum --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled_waypoint_R_cerebellum_exclude_R_corpus_callosum_L_cerebellum/waypoints.txt  --waycond=AND



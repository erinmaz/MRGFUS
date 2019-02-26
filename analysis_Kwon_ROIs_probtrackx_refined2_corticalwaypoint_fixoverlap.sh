#for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 
#for MYSUB in 9001_SH-11644 
#for MYSUB in 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 
#for MYSUB in HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
for MYSUB in 9001_SH-11644 9010_RR-13130 9011_BB-13042 9013_JD-13455
do

#invwarp -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/mT1

rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint
#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil


echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil > /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waypoints.txt

#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_dil_overlap /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil



echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waypoints.txt

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Precentral+Juxtapositional_L -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_L --interp=nn

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_L >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waypoints.txt

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_L -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil 

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/brainstem_slice_below_pons -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/optic_chiasm -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Frontal_Pole -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical/thalamus_R_final_1mm -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/jhu-labels_Label_Anterior_Limb_of_internal_capsule_L -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/histthal_label_anterior_commissure_dil2 -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_OccipitalLobe_thr25_bin -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/occipital_lobe --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_TemporalLobe_thr25_bin -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/temporal_lobe --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/c3T1 -thr .99 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/c3T1.99

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/c3T1.99 -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole  -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm  -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R  -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/temporal_lobe -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/occipital_lobe -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -add  /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R2
 

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waypoints.txt  --waycond=AND --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R2

rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint
#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil
echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil > /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waypoints.txt

#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_dil_overlap /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waypoints.txt

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Precentral+Juxtapositional_R -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_R --interp=nn

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_R >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waypoints.txt

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_R -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC -dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil 

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/brainstem_slice_below_pons -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/optic_chiasm -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Frontal_Pole -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical/thalamus_L_final_1mm -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L --interp=nn

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/jhu-labels_Label_Anterior_Limb_of_internal_capsule_R -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole  -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm  -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L  -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/temporal_lobe -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/occipital_lobe -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -add /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L2
 
/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waypoints.txt  --waycond=AND --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L2

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/fdt_paths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/fdt_paths &
done
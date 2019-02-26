#for updated thalterm analysis

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace
#for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 
for MYSUB in 9001_SH-11644
#HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
do

#applywarp -i ${ROIDIR}/harvardoxford-cortical_prob_Precentral+Juxtapositional_L -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_L --interp=nn

#applywarp -i ${ROIDIR}/mni_prob_Cerebellum_thr10_L -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L --interp=nn

#applywarp -i ${ROIDIR}/midsag_plane_CC_MNI152_T1_2mm -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC --interp=nn

#fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC -dilM ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil 

#applywarp -i ${ROIDIR}/brainstem_slice_below_pons -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons --interp=nn

#fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons -dilM ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil

applywarp -i ${ROIDIR}/optic_chiasm_thalterm -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm_thalterm --interp=nn

applywarp -i ${ROIDIR}/jhu-tracts_prob_Cingulum_hippocampus_L -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cingulum_hipp_L --interp=nn

applywarp -i ${ROIDIR}/jhu-tracts_prob_Cingulum_hippocampus_R -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cingulum_hipp_R --interp=nn

#applywarp -i ${ROIDIR}/harvardoxford-subcortical/thalamus_R_final_1mm -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R --interp=nn

#applywarp -i ${ROIDIR}/harvardoxford-subcortical/thalamus_L_final_1mm -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L --interp=nn

#applywarp -i ${ROIDIR}/jhu-labels_Label_Anterior_Limb_of_internal_capsule_L -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L --interp=nn

#applywarp -i ${ROIDIR}/histthal_label_anterior_commissure_dil2 -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC --interp=nn

fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm_thalterm_edit_for_R_dentate -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cingulum_hipp_R -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cingulum_hipp_L -bin ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R_thalterm
 
#applywarp -i ${ROIDIR}/harvardoxford-cortical_prob_Precentral+Juxtapositional_R -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_R --interp=nn

#applywarp -i ${ROIDIR}/mni_prob_Cerebellum_thr10_R -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R --interp=nn

#applywarp -i ${ROIDIR}/jhu-labels_Label_Anterior_Limb_of_internal_capsule_R -r ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R --interp=nn

fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm_thalterm -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cingulum_hipp_R -add ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cingulum_hipp_L -bin ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L_thalterm
 
fsleyes ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIS/RN_L_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R_thalterm ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIS/RN_R_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L_thalterm &

done
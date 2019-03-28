#!/bin/bash
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace
for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 

do

mkdir ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_R_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_L_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/SCP_R_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/SCP_L_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/RN_R_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/RN_L_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/RN_R
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/RN_L

fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_decus ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/SCP_decus
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff_bin ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin

done

for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9011_BB-13042 9013_JD-13455 9021_WM-14127 
do
for ROI in mni_prob_Cerebellum_thr10_L mni_prob_Cerebellum_thr10_R midsag_plane_CC_MNI152_T1_2mm optic_chiasm_thalterm jhu-tracts_prob_Cingulum_hippocampus_L jhu-tracts_prob_Cingulum_hippocampus_R harvardoxford-subcortical_thalamus_R_final_1mm harvardoxford-subcortical_thalamus_L_final_1mm jhu-labels_Label_Anterior_Limb_of_internal_capsule_L jhu-labels_Label_Anterior_Limb_of_internal_capsule_R histthal_label_anterior_commissure_dil2 brainstem_slice_below_pons optic_chiasm_thalterm
do

antsApplyTransforms -d 3 -i ${ROIDIR}/${ROI}.nii.gz -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}.nii.gz -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/bet/MNI_1mm_2_mT10GenericAffine.mat -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/bet/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

done
done

for MYSUB in 9010_RR-13130 9016_EB-13634
do
for ROI in mni_prob_Cerebellum_thr10_L mni_prob_Cerebellum_thr10_R midsag_plane_CC_MNI152_T1_2mm optic_chiasm_thalterm jhu-tracts_prob_Cingulum_hippocampus_L jhu-tracts_prob_Cingulum_hippocampus_R harvardoxford-subcortical_thalamus_R_final_1mm harvardoxford-subcortical_thalamus_L_final_1mm jhu-labels_Label_Anterior_Limb_of_internal_capsule_L jhu-labels_Label_Anterior_Limb_of_internal_capsule_R histthal_label_anterior_commissure_dil2 brainstem_slice_below_pons optic_chiasm_thalterm
do

antsApplyTransforms -d 3 -i ${ROIDIR}/${ROI}.nii.gz -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}.nii.gz -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/MNI_1mm_2_mT10GenericAffine.mat -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

done
done

for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 
do

for ROI in mni_prob_Cerebellum_thr10_L mni_prob_Cerebellum_thr10_R midsag_plane_CC_MNI152_T1_2mm optic_chiasm_thalterm jhu-tracts_prob_Cingulum_hippocampus_L jhu-tracts_prob_Cingulum_hippocampus_R harvardoxford-subcortical_thalamus_R_final_1mm harvardoxford-subcortical_thalamus_L_final_1mm jhu-labels_Label_Anterior_Limb_of_internal_capsule_L jhu-labels_Label_Anterior_Limb_of_internal_capsule_R histthal_label_anterior_commissure_dil2 brainstem_slice_below_pons optic_chiasm_thalterm
do
flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -in ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI} -out ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff -ref ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -interp nearestneighbour
done

fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/brainstem_slice_below_pons2diff -dilM ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/brainstem_slice_below_pons2diff_dil
fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/midsag_plane_CC_MNI152_T1_2mm2diff -dilM ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/midsag_plane_CC_MNI152_T1_2mm2diff_dil

cd ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants

fslmaths mni_prob_Cerebellum_thr10_L2diff -add midsag_plane_CC_MNI152_T1_2mm2diff_dil -add optic_chiasm_thalterm2diff -add jhu-tracts_prob_Cingulum_hippocampus_L2diff -add jhu-tracts_prob_Cingulum_hippocampus_R2diff -add harvardoxford-subcortical_thalamus_R_final_1mm2diff -add jhu-labels_Label_Anterior_Limb_of_internal_capsule_L2diff -add jhu-labels_Label_Anterior_Limb_of_internal_capsule_R2diff -add histthal_label_anterior_commissure_dil22diff -add brainstem_slice_below_pons2diff_dil -add optic_chiasm_thalterm2diff -add RN_R exclude_R

fslmaths mni_prob_Cerebellum_thr10_R2diff -add midsag_plane_CC_MNI152_T1_2mm2diff_dil -add optic_chiasm_thalterm2diff -add jhu-tracts_prob_Cingulum_hippocampus_L2diff -add jhu-tracts_prob_Cingulum_hippocampus_R2diff -add harvardoxford-subcortical_thalamus_L_final_1mm2diff -add jhu-labels_Label_Anterior_Limb_of_internal_capsule_L2diff -add jhu-labels_Label_Anterior_Limb_of_internal_capsule_R2diff -add histthal_label_anterior_commissure_dil22diff -add brainstem_slice_below_pons2diff_dil -add optic_chiasm_thalterm2diff -add RN_L exclude_L

fslmaths SCP_L_dil -dilM -binv SCP_L_dil2_binv
fslmaths exclude_L exclude_L_orig
fslmaths exclude_L -mas SCP_L_dil2_binv -bin exclude_L

fslmaths SCP_R_dil -dilM -binv SCP_R_dil2_binv
fslmaths exclude_R exclude_R_orig
fslmaths exclude_R -mas SCP_R_dil2_binv -bin exclude_R

fslstats exclude_L -k SCP_L_dil -V
fslstats exclude_R -k SCP_R_dil -V

fsleyes ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped exclude_L exclude_R dentate_R_dil dentate_L_dil RN_L_dil RN_R_dil SCP_R_dil SCP_L_dil harvardoxford-subcortical_thalamus_L_final_1mm2diff harvardoxford-subcortical_thalamus_R_final_1mm2diff &

done
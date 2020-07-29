MYSUB=${1}-${2}

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace


for ROI in harvardoxford-cortical_prob_Precentral+Juxtapositional_L harvardoxford-cortical_prob_Precentral+Juxtapositional_R
do
antsApplyTransforms -d 3 -i ${ROIDIR}/${ROI}.nii.gz -r ${MAINDIR}/analysis/${MYSUB}/anat/T1.nii.gz -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}.nii.gz -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/bet/MNI_1mm_2_T10GenericAffine.mat -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/bet/MNI_1mm_2_T11Warp.nii.gz -n NearestNeighbor

flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -in ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI} -out ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff -ref ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -interp nearestneighbour

fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff -dilM ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff_dilM


done
fsleyes ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped  ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_R  ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_L &


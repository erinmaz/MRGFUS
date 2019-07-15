#!/bin/bash
#run after makeROI_ants.sh
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace

for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9011_BB-13042 9013_JD-13455 9019_TB-14038 9021_WM-14127 9023_WS-14863
do
for ROI in harvardoxford-cortical_prob_Precentral+Juxtapositional_L harvardoxford-cortical_prob_Precentral+Juxtapositional_R
do

antsApplyTransforms -d 3 -i ${ROIDIR}/${ROI}.nii.gz -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}.nii.gz -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/bet/MNI_1mm_2_mT10GenericAffine.mat -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/bet/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

done
done

for MYSUB in 9010_RR-13130 9016_EB-13634
do
for ROI in harvardoxford-cortical_prob_Precentral+Juxtapositional_L harvardoxford-cortical_prob_Precentral+Juxtapositional_R
do

antsApplyTransforms -d 3 -i ${ROIDIR}/${ROI}.nii.gz -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -o ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}.nii.gz -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/MNI_1mm_2_mT10GenericAffine.mat -t ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

done
done

for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9019_TB-14038 9021_WM-14127 9023_WS-14863

do

for ROI in harvardoxford-cortical_prob_Precentral+Juxtapositional_L harvardoxford-cortical_prob_Precentral+Juxtapositional_R
do
flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -in ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI} -out ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff -ref ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped -interp nearestneighbour

fslmaths ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff -dilM ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/${ROI}2diff_dilM
done

cd ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants


fsleyes ${MAINDIR}/analysis/${MYSUB}/diffusion/mean_b0_unwarped harvardoxford-cortical_prob_Precentral+Juxtapositional_R harvardoxford-cortical_prob_Precentral+Juxtapositional_L &

done
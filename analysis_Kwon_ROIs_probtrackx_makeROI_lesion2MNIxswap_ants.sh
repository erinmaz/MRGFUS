#!/bin/bash
#run after makeROI_ants.sh
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis

#LESIONFILE generated in check_stn_ANTs.sh
LESIONFILE=T1_lesion_filled_mask_2_MNI152_T1_1mm
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9011_BB 9013_JD 9021_WM 
do

PRE_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'`
DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
REGDIR=${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/xfms/ants/bet

fslswapdim ${REGDIR}/${LESIONFILE} -x y z ${REGDIR}/${LESIONFILE}_xswap
fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm ${REGDIR}/${LESIONFILE} ${REGDIR}/${LESIONFILE}_xswap
antsApplyTransforms -d 3 -i ${REGDIR}/${LESIONFILE}_xswap.nii.gz -r ${MAINDIR}/analysis/${MYSUB}-${DAY1_EXAM}/anat/mT1.nii.gz -o ${REGDIR}/${LESIONFILE}_xswap2T1.nii.gz -t ${REGDIR}/MNI_1mm_2_mT10GenericAffine.mat -t ${REGDIR}/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

fsleyes ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/mT1 ${REGDIR}/${LESIONFILE}_xswap2T1 ${MAINDIR}/analysis_lesion_masks/${MYSUB}-${DAY1_EXAM}/anat/T1_lesion_mask_filled
#flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr.mat -in ${REGDIR}/${LESIONFILE}_xswap2T1 -out ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_xswap2diff -ref ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped -interp nearestneighbour

#fsleyes ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_xswap2diff ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin &

done



#for MYSUB in 9010_RR 9016_EB
#do
#PRE_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'`
#DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
#REGDIR=${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/xfms/ants

#fslswapdim ${REGDIR}/${LESIONFILE} -x y z ${REGDIR}/${LESIONFILE}_xswap

#antsApplyTransforms -d 3 -i ${REGDIR}/${LESIONFILE}_xswap.nii.gz -r ${MAINDIR}/analysis/${MYSUB}-${DAY1_EXAM}/anat/mT1.nii.gz -o ${REGDIR}/${LESIONFILE}_xswap2T1.nii.gz -t ${REGDIR}/MNI_1mm_2_mT10GenericAffine.mat -t ${REGDIR}/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

#flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr.mat -in ${REGDIR}/${LESIONFILE}_xswap2T1 -out ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_xswap2diff -ref ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped -interp nearestneighbour

#fsleyes ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_xswap2diff ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin &


#done



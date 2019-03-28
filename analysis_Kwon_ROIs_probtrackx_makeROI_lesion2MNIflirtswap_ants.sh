#!/bin/bash
#run after makeROI_ants.sh
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts

#LESIONFILE generated in check_stn_ANTs.sh
LESIONFILE=T1_lesion_filled_mask_2_MNI152_T1_1mm
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9011_BB 9013_JD 9021_WM 
do

PRE_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'`
DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
REGDIR=${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/xfms/ants/bet
REGDIR_PRE=${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/anat/xfms/ants/bet

flirt -in ${REGDIR}/${LESIONFILE} -applyxfm -init ${SCRIPTSDIR}/mni1mm_xswap.mat -out ${REGDIR}/${LESIONFILE}_flirtswap -ref ${FSLDIR}/data/standard/MNI152_T1_1mm -interp nearestneighbour

#fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm ${REGDIR}/${LESIONFILE} ${REGDIR}/${LESIONFILE}_flirtswap
#antsApplyTransforms -d 3 -i ${REGDIR}/${LESIONFILE}_flirtswap.nii.gz -r ${MAINDIR}/analysis/${MYSUB}-${DAY1_EXAM}/anat/mT1.nii.gz -o ${REGDIR}/${LESIONFILE}_flirtswap2T1.nii.gz -t ${REGDIR}/MNI_1mm_2_mT10GenericAffine.mat -t ${REGDIR}/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

antsApplyTransforms -d 3 -i ${REGDIR}/${LESIONFILE}_flirtswap.nii.gz -r ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/anat/mT1.nii.gz -o ${REGDIR_PRE}/${LESIONFILE}_flirtswap2T1_pre.nii.gz -t ${REGDIR_PRE}/MNI_1mm_2_mT10GenericAffine.mat -t ${REGDIR_PRE}/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

#fsleyes ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/mT1 ${REGDIR_PRE}/${LESIONFILE}_flirtswap2T1_pre ${MAINDIR}/analysis_lesion_masks/${MYSUB}-${DAY1_EXAM}/anat/T1_lesion_mask_filled

flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/xfms/T1_2_diff_bbr.mat -in ${REGDIR_PRE}/${LESIONFILE}_flirtswap2T1_pre -out ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_flirtswap2diff_v2 -ref ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped -interp nearestneighbour

fsleyes ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_flirtswap2diff ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_flirtswap2diff_v2 ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin &

done



for MYSUB in 9010_RR 9016_EB
do
PRE_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'`
DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
REGDIR=${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/xfms/ants
REGDIR_PRE=${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/anat/xfms/ants

flirt -in ${REGDIR}/${LESIONFILE} -applyxfm -init ${SCRIPTSDIR}/mni1mm_xswap.mat -out ${REGDIR}/${LESIONFILE}_flirtswap -ref ${FSLDIR}/data/standard/MNI152_T1_1mm -interp nearestneighbour

#fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm ${REGDIR}/${LESIONFILE} ${REGDIR}/${LESIONFILE}_flirtswap
#antsApplyTransforms -d 3 -i ${REGDIR}/${LESIONFILE}_flirtswap.nii.gz -r ${MAINDIR}/analysis/${MYSUB}-${DAY1_EXAM}/anat/mT1.nii.gz -o ${REGDIR}/${LESIONFILE}_flirtswap2T1.nii.gz -t ${REGDIR}/MNI_1mm_2_mT10GenericAffine.mat -t ${REGDIR}/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

antsApplyTransforms -d 3 -i ${REGDIR}/${LESIONFILE}_flirtswap.nii.gz -r ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/anat/mT1.nii.gz -o ${REGDIR_PRE}/${LESIONFILE}_flirtswap2T1_pre.nii.gz -t ${REGDIR_PRE}/MNI_1mm_2_mT10GenericAffine.mat -t ${REGDIR_PRE}/MNI_1mm_2_mT11Warp.nii.gz -n NearestNeighbor

#fsleyes ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/anat/mT1 ${REGDIR_PRE}/${LESIONFILE}_flirtswap2T1_pre ${MAINDIR}/analysis_lesion_masks/${MYSUB}-${DAY1_EXAM}/anat/T1_lesion_mask_filled

flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/xfms/T1_2_diff_bbr.mat -in ${REGDIR_PRE}/${LESIONFILE}_flirtswap2T1_pre -out ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_flirtswap2diff_v2 -ref ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped -interp nearestneighbour

fsleyes ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_flirtswap2diff ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/${LESIONFILE}_flirtswap2diff_v2 ${MAINDIR}/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin &


done



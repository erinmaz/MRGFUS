#!/bin/bash
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
mkdir ${MAINDIR}/analysis/${MYSUB}/anat/xfms
/usr/local/fsl/bin/flirt -in ${MAINDIR}/analysis/${MYSUB}/anat/mT1_brain -ref ${FSLDIR}/data/standard/MNI152_T1_1mm_brain -out ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_brain_2_MNI_1mm_lin -omat ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_brain_2_MNI_1mm_lin.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 
if [ -f ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled.nii.gz ]; then
  fslmaths ${MAINDIR}/analysis/${MYSUB}/anat/spm_mask -dilM -sub ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled ${MAINDIR}/analysis/${MYSUB}/anat/xfms/fnirt_inmask
  DOFIRST=0
else
  fslmaths ${MAINDIR}/analysis/${MYSUB}/anat/spm_mask -dilM ${MAINDIR}/analysis/${MYSUB}/anat/xfms/fnirt_inmask
  DOFIRST=1
fi

#to fix weird problem with image dimensions being wrong
flirt -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/scripts/ident.mat -in ${MAINDIR}/analysis/${MYSUB}/anat/xfms/fnirt_inmask -ref ${MAINDIR}/analysis/${MYSUB}/anat/mT1 -out ${MAINDIR}/analysis/${MYSUB}/anat/xfms/fnirt_inmask2mT1 -interp nearestneighbour

/usr/local/fsl/bin/fnirt --in=${MAINDIR}/analysis/${MYSUB}/anat/mT1 --inmask=${MAINDIR}/analysis/${MYSUB}/anat/xfms/fnirt_inmask2mT1 --aff=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_brain_2_MNI_1mm_lin.mat --cout=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp --iout=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped --jout=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_jac --config=T1_2_MNI152_2mm --ref=${FSLDIR}/data/standard/MNI152_T1_1mm --refmask=${FSLDIR}/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10

invwarp -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp -o ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1 
if [ ${DOFIRST} -eq 1 ]; then
  run_first_all -i ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped -o ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first # -s L_Hipp,R_Hipp,L_Thal,R_Thal
  fslmaths `ls ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_all_*_firstseg.nii.gz` -thr 9.5 -uthr 10.5 -bin ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_L_thal 
  fslmaths `ls ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_all_*_firstseg.nii.gz` -thr 48.5 -uthr 49.5 -bin ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_R_thal
  fslmaths `ls ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_all_*_firstseg.nii.gz` -thr 52.5 -uthr 53.5 -bin ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_R_hipp 
  fslmaths `ls ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_all_*_firstseg.nii.gz` -thr 16.5 -uthr 17.5 -bin ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_L_hipp
  
fi
  
fsleyes ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_L_thal.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_L_hipp.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_R_hipp.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_R_thal.nii.gz 
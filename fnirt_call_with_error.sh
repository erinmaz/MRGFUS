#!/bin/bash
MYSUB=9001_SH-11692
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
/usr/local/fsl/bin/fnirt --in=${MAINDIR}/analysis/${MYSUB}/anat/mT1 --inmask=${MAINDIR}/analysis/${MYSUB}/anat/xfms/fnirt_inmask --aff=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_brain_2_MNI_1mm_lin.mat --cout=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp --iout=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped --jout=${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_jac --config=T1_2_MNI152_2mm --ref=${FSLDIR}/data/standard/MNI152_T1_1mm --refmask=${FSLDIR}/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10

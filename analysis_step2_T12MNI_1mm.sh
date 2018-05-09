#!/bin/bash
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
mkdir ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms
fslmaths ${MAINDIR}/analysis/${MYSUB}/anat/T1_brain ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T1_brain
/usr/local/fsl/bin/flirt -in ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T1_brain -ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain -out ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm -omat ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 

fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1 ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T1 

/usr/local/fsl/bin/fnirt --in=${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T1 --aff=${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm.mat --cout=${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm_warp --iout=${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm --jout=${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm_jac --config=T1_2_MNI152_2mm --ref=/usr/local/fsl/data/standard/MNI152_T1_1mm --refmask=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10

/usr/local/fsl/bin/applywarp -i ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled -r ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm -o ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2MNI_1mm -w ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm_warp --interp=nn

fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2MNI_1mm 

mkdir /Users/erin/Dropbox/BigBrainAnalysis/lesions/mni_1mm/${MYSUB}
mkdir /Users/erin/Dropbox/BigBrainAnalysis/lesions/native_space/${MYSUB}

fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/xfms/T12MNI_1mm /Users/erin/Dropbox/BigBrainAnalysis/lesions/mni_1mm/${MYSUB}/T12MNI_1mm

fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2MNI_1mm  /Users/erin/Dropbox/BigBrainAnalysis/lesions/mni_1mm/${MYSUB}/T1_lesion_mask_filled2MNI_1mm  

fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1   /Users/erin/Dropbox/BigBrainAnalysis/lesions/native_space/${MYSUB}/T1

fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled /Users/erin/Dropbox/BigBrainAnalysis/lesions/native_space/${MYSUB}/T1_lesion_mask_filled
#!/bin/bash
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
INDEX_FILE=${MAINDIR}/scripts/IDs_and_ExamNums.sh
ANALYSISDIR=${MAINDIR}/analysis
MYSUB=$1

# SETUP
pre_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $2}'` 
day1_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $4}'` 

#For all post-treatment exams, get lesion mask into mT1 space and binv
for EXAM in $day1_exam $month3_exam
do
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet
if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII.nii.gz ] ; then
flirt -applyxfm -init ${FSLDIR}/etc/flirtsch/ident.mat -in ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII -out ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2mT1 -ref ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1 -interp nearestneighbour
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2mT1 -binv ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2mT1_binv
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2mT1_binv ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask
fi
done

EXAM=$pre_exam
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet

#brain extract. c1T1 and c2T1 are GM and WM masks created with SPM12's Segment (see QA.sh script)
for EXAM in $pre_exam $day1_exam $month3_exam
do
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/c1T1 -add ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/c2T1 -dilM ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/gm_wm_dilM 

fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1 -mas ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/gm_wm_dilM  ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain

cd ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet

#setup inmask
if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask.nii.gz ] ; then
INMASK=`echo -x ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask.nii.gz`
else
INMASK=""
fi

antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1] --transform Rigid[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox ${INMASK}

if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1.nii ] ; then
fslchfiletype NIFTI_GZ ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1
fi

antsApplyTransforms -d 3 -i ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

fsleyes mT1_2_MNI152_T1_1mm ${FSLDIR}/data/standard/MNI152_T1_1mm &
done


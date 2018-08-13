#!/bin/bash

MYSUB=$1
TREATMENTSIDE=$2
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix_adv
mkdir ${WORKDIR}

flirt -in ${ANALYSISDIR}/${MYSUB}/anat/T1.nii.gz -out ${WORKDIR}/T1_2_diff -applyxfm -init ${DIFFDIR}/xfms/T1_2_diff_bbr.mat -ref ${DIFFDIR}/mean_b0_unwarped.nii.gz 

5ttgen fsl ${WORKDIR}/T1_2_diff.nii.gz ${WORKDIR}/T1_5tt.nii.gz 
 
dwi2response tournier ${DIFFDIR}/data.nii.gz ${WORKDIR}/wm_response.txt -fslgrad ${DIFFDIR}/data.eddy_rotated_bvecs ${DIFFDIR}/bvals -voxels ${WORKDIR}/voxels.nii.gz -force



dwi2fod -fslgrad ${DIFFDIR}/data.eddy_rotated_bvecs ${DIFFDIR}/bvals -mask ${DIFFDIR}/nodif_brain_mask.nii.gz csd ${DIFFDIR}/data.nii.gz ${WORKDIR}/wm_response.txt ${WORKDIR}/fod.nii.gz 

tckgen -algorithm SD_STREAM -act ${WORKDIR}/T1_5tt.nii.gz -seed_image ${DIFFDIR}/rois_tracking_atlasROIs_300718/RN_standard_1mm_${TREATMENTSIDE}.nii.gz -include ${DIFFDIR}/rois_tracking_atlasROIs_300718/harvardoxford-cortical_prob_Precentral+Juxtapositional_${TREATMENTSIDE}.nii.gz ${WORKDIR}/fod.nii.gz ${WORKDIR}/rtt.tck

tckedit -exclude ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt.tck ${WORKDIR}/rtt_exclude_lesion.tck

tckedit -include ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt.tck ${WORKDIR}/rtt_include_lesion.tck

tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_include_lesion.tck ${WORKDIR}/rtt_include_lesion.nii.gz

tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_exclude_lesion.tck ${WORKDIR}/rtt_exclude_lesion.nii.gz

fsleyes ${DIFFDIR}/data ${WORKDIR}/rtt_include_lesion.nii.gz  ${WORKDIR}/rtt_exclude_lesion.nii.gz

fslmaths ${WORKDIR}/rtt_exclude_lesion.nii.gz -mas ${WORKDIR}/rtt_include_lesion.nii.gz ${WORKDIR}/rtt_overlap.nii.gz

echo -n $MYSUB " "
fslstats  ${WORKDIR}/rtt_overlap.nii.gz -V
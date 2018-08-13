#!/bin/bash

MYSUB=$1
TREATMENTSIDE=$2
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix_basic
mkdir ${WORKDIR}

#dwi2response tournier ${DIFFDIR}/data.nii.gz ${WORKDIR}/wm_response.txt -fslgrad ${DIFFDIR}/data.eddy_rotated_bvecs ${DIFFDIR}/bvals -voxels ${WORKDIR}/voxels.nii.gz -force
#shview ${WORKDIR}/wm_response.txt
#mrview ${WORKDIR}/voxels.nii.gz 

#dwi2fod -fslgrad ${DIFFDIR}/data.eddy_rotated_bvecs ${DIFFDIR}/bvals -mask ${DIFFDIR}/nodif_brain_mask.nii.gz csd ${DIFFDIR}/data.nii.gz ${WORKDIR}/wm_response.txt ${WORKDIR}/fod.nii.gz 

#fslmaths ${DIFFDIR}/rois_tracking_atlasROIs_300718/RN_standard_1mm_${TREATMENTSIDE}.nii.gz -dilM  ${DIFFDIR}/rois_tracking_atlasROIs_300718/RN_standard_1mm_${TREATMENTSIDE}_dilM.nii.gz

#tckgen -algorithm SD_STREAM -seed_image ${DIFFDIR}/rois_tracking_atlasROIs_300718/RN_standard_1mm_${TREATMENTSIDE}_dilM.nii.gz -include ${DIFFDIR}/rois_tracking_atlasROIs_300718/harvardoxford-cortical_prob_Precentral+Juxtapositional_${TREATMENTSIDE}.nii.gz ${WORKDIR}/fod.nii.gz ${WORKDIR}/rtt_reddilM.tck
tckgen -algorithm SD_STREAM -seed_image ${DIFFDIR}/rois_tracking_atlasROIs_300718/harvardoxford-cortical_prob_Precentral+Juxtapositional_${TREATMENTSIDE}.nii.gz -include ${DIFFDIR}/rois_tracking_atlasROIs_300718/RN_standard_1mm_${TREATMENTSIDE}_dilM.nii.gz ${WORKDIR}/fod.nii.gz ${WORKDIR}/rtt_from_cortex.tck

#tckedit -exclude ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt_reddilM.tck ${WORKDIR}/rtt_reddilM_exclude_lesion.tck

#tckedit -include ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt_reddilM.tck ${WORKDIR}/rtt_reddilM_include_lesion.tck

#tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_reddilM_include_lesion.tck ${WORKDIR}/rtt_reddilM_include_lesion.nii.gz

#tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_reddilM_exclude_lesion.tck ${WORKDIR}/rtt_reddilM_exclude_lesion.nii.gz

#fsleyes ${DIFFDIR}/data ${WORKDIR}/rtt_reddilM_include_lesion.nii.gz ${WORKDIR}/rtt_reddilM_exclude_lesion.nii.gz

tckedit -exclude ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck

tckedit -include ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_include_lesion.tck

tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_reddilM_include_lesion.tck ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz

tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_reddilM_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz

fsleyes ${DIFFDIR}/data ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz

#fslmaths ${WORKDIR}/rtt_reddilM_exclude_lesion.nii.gz -mas ${WORKDIR}/rtt_reddilM_include_lesion.nii.gz ${WORKDIR}/rtt_reddilM_overlap.nii.gz

fslmaths ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz -mas ${WORKDIR}/rtt_rfrom_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_overlap.nii.gz

#inc_les=`fslstats ${WORKDIR}/rtt_reddilM_include_lesion.nii.gz -V`
#exc_les=`fslstats ${WORKDIR}/rtt_reddilM_exclude_lesion.nii.gz -V`
#overlap=`fslstats  ${WORKDIR}/rtt_reddilM_overlap.nii.gz -V`

inc_les=`fslstats ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz -V`
exc_les=`fslstats ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz -V`
overlap=`fslstats  ${WORKDIR}/rtt_from_cortex_overlap.nii.gz -V`

echo $MYSUB $inc_les $exc_les $overlap


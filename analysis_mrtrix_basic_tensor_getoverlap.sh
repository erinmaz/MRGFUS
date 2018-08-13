#!/bin/bash

MYSUB=$1
TREATMENTSIDE=$2
OTHERSIDE=$3
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix_basic_tensor_det_exclude


fslmaths ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz -mas ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_overlap.nii.gz

inc_les=`fslstats ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz -V`
exc_les=`fslstats ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz -V`
overlap=`fslstats ${WORKDIR}/rtt_from_cortex_overlap.nii.gz -V`

echo $MYSUB $inc_les $exc_les $overlap

tckinfo ${WORKDIR}/rtt_from_cortex_include_lesion.tck

tckinfo ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck

fslmaths ${WORKDIR}/rtt_from_cortex_overlap -binv ${WORKDIR}/rtt_from_cortex_overlap_binv
fslmaths ${WORKDIR}/rtt_from_cortex_include_lesion -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap
fslmaths ${WORKDIR}/rtt_from_cortex_exclude_lesion -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap
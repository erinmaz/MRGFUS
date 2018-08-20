#!/bin/bash

MYSUB=$1
TREATMENTSIDE=$2
OTHERSIDE=$3
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix

if [ -e ${WORKDIR}/manual_exclude.nii.gz ]; then
  fsleyes ${DIFFDIR}/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz ${WORKDIR}/manual_exclude.nii.gz
else
  fsleyes ${DIFFDIR}/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz 
fi


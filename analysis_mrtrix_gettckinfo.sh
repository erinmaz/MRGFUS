#!/bin/bash

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix

tckinfo ${WORKDIR}/rtt_from_cortex_include_lesion_clean.tck

tckinfo ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.tck

#!/bin/bash

#subject IDs as input
MYSUB=$1
MAINDIR=~/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
LESIONDIR=${MAINDIR}/analysis_lesion_masks

ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
LESIONANATDIR=${LESIONDIR}/${MYSUB}/anat

mkdir ${LESIONDIR}/${MYSUB}
mkdir ${LESIONANATDIR}

fslmaths ${ANATDIR}/T1 ${LESIONANATDIR}/T1

#Trace lesion on post scan's T1
fsleyes ${LESIONANATDIR}/T1

#!/bin/bash
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
cp $0 ${ANALYSISDIR}/${MYSUB}/.

#subject IDs as input (no exam #)
MYSUB=$1
MYTRACT=$2
MYREG2STR=$3
MYREG2LONG=$4

TRACTNAME=`basename ${MYTRACT} .nii.gz`
mkdir ${ANALYSISDIR}/${MYSUB}_longitudinal_diffusion

convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_2_T1_day1.mat -concat $MYREG2LONG $MYREG2STR
flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_2_T1_day1.mat -in $MYTRACT -ref ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_brain_pre_2_day1 -out ${ANALYSISDIR}/${MYSUB}_longitudinal_diffusion/${TRACTNAME} -interp nearestneighbour
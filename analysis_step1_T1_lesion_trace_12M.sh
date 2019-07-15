#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2

MONTH12=${MYSUB_PREFIX}-$3

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms_T1
MAINDIR=~/Desktop/Projects/MRGFUS
LESIONDIR=${MAINDIR}/analysis_lesion_masks

LESIONANATDIR=${LESIONDIR}/${MONTH12}/anat

mkdir ${LESIONDIR}/${MONTH12}
mkdir ${LESIONANATDIR}

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat

ANATDIR_MONTH12=${ANALYSISDIR}/${MONTH12}/anat

convert_xfm -omat ${RESULTSDIR}/mT1_brain_pre_2_month12_6dof.mat -inverse ${RESULTSDIR}/mT1_brain_month12_2_pre_6dof.mat

flirt -in ${ANATDIR_PRE}/mT1_brain -ref ${ANATDIR_MONTH12}/mT1_brain -out ${RESULTSDIR}/mT1_brain_pre_2_month12_6dof -applyxfm -init ${RESULTSDIR}/mT1_brain_pre_2_month12_6dof.mat  

fsleyes  ${RESULTSDIR}/mT1_brain_pre_2_month12_6dof ${ANATDIR_MONTH12}/mT1_brain 

fslstats ${LESIONANATDIR}/T1_lesion_mask_filled -V

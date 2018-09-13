#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2
DAY1=${MYSUB_PREFIX}-$3
MONTH3=${MYSUB_PREFIX}-$4
#MONTH12=${MYSUB_PREFIX}-$5

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms_T1
mkdir $RESULTSDIR

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat
ANATDIR_MONTH3=${ANALYSISDIR}/${MONTH3}/anat

#ANATDIR_MONTH12=${ANALYSISDIR}/${MONTH12}/anat

fslmaths ${ANATDIR_PRE}/mT1 -mas ${ANATDIR_PRE}/spm_mask ${ANATDIR_PRE}/mT1_brain
fslmaths ${ANATDIR_DAY1}/mT1 -mas ${ANATDIR_DAY1}/spm_mask ${ANATDIR_DAY1}/mT1_brain
fslmaths ${ANATDIR_MONTH3}/mT1 -mas ${ANATDIR_MONTH3}/spm_mask ${ANATDIR_MONTH3}/mT1_brain
#fslmaths ${ANATDIR_MONTH12}/mT1 -mas ${ANATDIR_MONTH12}/spm_mask ${ANATDIR_MONTH12}/mT1_brain

flirt -in ${ANATDIR_DAY1}/mT1_brain -ref ${ANATDIR_PRE}/mT1_brain -out ${RESULTSDIR}/mT1_brain_day1_2_pre_6dof -omat ${RESULTSDIR}/mT1_brain_day1_2_pre_6dof.mat -dof 6

flirt -in ${ANATDIR_MONTH3}/mT1_brain -ref ${ANATDIR_PRE}/mT1_brain -out ${RESULTSDIR}/mT1_brain_month3_2_pre_6dof -omat ${RESULTSDIR}/mT1_brain_month3_2_pre_6dof.mat -dof 6

#flirt -in ${ANATDIR_MONTH12}/mT1_brain -ref ${ANATDIR_PRE}/mT1_brain -out ${RESULTSDIR}/mT1_brain_month12_2_pre_6dof -omat ${RESULTSDIR}/mT1_brain_month12_2_pre_6dof.mat -dof 6

fsleyes ${ANATDIR_PRE}/mT1_brain ${RESULTSDIR}/mT1_brain_day1_2_pre_6dof ${RESULTSDIR}/mT1_brain_month3_2_pre_6dof 
#${RESULTSDIR}/mT1_brain_month12_2_pre_6dof
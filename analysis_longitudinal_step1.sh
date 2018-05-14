#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2
DAY1=${MYSUB_PREFIX}-$3

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms
mkdir $RESULTSDIR

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat
DIFFDIR_PRE=${ANALYSISDIR}/${PRE}/diffusion

fslmaths ${ANATDIR_PRE}/mT1 -mas ${ANATDIR_PRE}/spm_mask ${ANATDIR_PRE}/mT1_brain
fslmaths ${ANATDIR_DAY1}/mT1 -mas ${ANATDIR_DAY1}/spm_mask ${ANATDIR_DAY1}/mT1_brain

flirt -in ${ANATDIR_PRE}/mT1_brain -ref ${ANATDIR_DAY1}/mT1_brain -out ${RESULTSDIR}/mT1_brain_pre_2_day1_6dof -omat ${RESULTSDIR}/mT1_pre_2_day1_6dof.mat -dof 6

convert_xfm -omat ${RESULTSDIR}/mT1_day1_2_pre_6dof.mat -inverse ${RESULTSDIR}/mT1_pre_2_day1_6dof.mat

#day1 T1 to diff pre
convert_xfm -omat ${RESULTSDIR}/mT1_day1_2_diff_pre_bbr.mat -concat ${DIFFDIR_PRE}/xfms/T1_2_diff_bbr.mat ${RESULTSDIR}/mT1_day1_2_pre_6dof.mat 

fsleyes ${ANATDIR_DAY1}/mT1 ${RESULTSDIR}/mT1_brain_pre_2_day1_6dof &

flirt -applyxfm -init ${RESULTSDIR}/mT1_day1_2_diff_pre_bbr.mat -ref ${ANALYSISDIR}/${PRE}/diffusion/mean_B0_unwarped -in ${ANALYSISDIR}/${DAY1}/anat/T1 -out ${RESULTSDIR}/mT1_day1_2_diff_pre_bbr 

fsleyes ${RESULTSDIR}/mT1_day1_2_diff_pre_bbr ${ANALYSISDIR}/${PRE}/diffusion/mean_B0_unwarped
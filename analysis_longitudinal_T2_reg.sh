#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2
DAY1=${MYSUB_PREFIX}-$3

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat

bet ${ANATDIR_PRE}/T2 ${ANATDIR_PRE}/T2_brain -f 0.3 -S -m
bet ${ANATDIR_DAY1}/T2 ${ANATDIR_DAY1}/T2_brain -f 0.3 -S -m

#flirt -ref ${ANATDIR_PRE}/T2 -in ${ANATDIR_DAY1}/T2 -out ${RESULTSDIR}/T2_day1_2_pre -omat ${RESULTSDIR}/T2_day1_2_pre.mat -dof 6
flirt -ref ${ANATDIR_PRE}/T2_brain -in ${ANATDIR_DAY1}/T2_brain -out ${RESULTSDIR}/T2_brain_day1_2_pre -omat ${RESULTSDIR}/T2_brain_day1_2_pre.mat -dof 6
fsleyes ${ANATDIR_PRE}/T2_brain ${RESULTSDIR}/T2_brain_day1_2_pre
mkdir /Volumes/Pikelab/MRGFUS-shared/T2_lesions/${DAY1}/xfms
cp ${RESULTSDIR}/T2_brain_day1_2_pre.mat /Volumes/Pikelab/MRGFUS-shared/T2_lesions/${DAY1}/xfms/.
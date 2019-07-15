#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2
DAY1=${MYSUB_PREFIX}-$3
MONTH3=${MYSUB_PREFIX}-$4
MONTH12=${MYSUB_PREFIX}-$5

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms
mkdir $RESULTSDIR

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat

if [ -e ${ANATDIR_PRE}/T2_avg.nii.gz ]; then
T2_pre=${ANATDIR_PRE}/T2_avg
else
T2_pre=${ANATDIR_PRE}/T2
fi


for run in $DAY1 $MONTH3 $MONTH12
do
ANATDIR_RUN=${ANALYSISDIR}/${run}/anat
if [ -e ${ANATDIR_RUN}/T2_avg.nii.gz ]; then
T2=${ANATDIR_RUN}/T2_avg
else
T2=${ANATDIR_RUN}/T2
fi

flirt -in ${T2} -ref ${ANATDIR_PRE}/T1 -out ${RESULTSDIR}/T2_${run}_2_T1_pre_6dof -omat ${RESULTSDIR}/T2_${run}_2_T1_pre_6dof.mat -dof 6 -interp sinc

fsleyes ${RESULTSDIR}/T2_${run}_2_T1_pre_6dof ${ANATDIR_PRE}/T1
done

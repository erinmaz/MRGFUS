#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2
DAY1=${MYSUB_PREFIX}-$3
T1_2_FUNC_PRE=$4


ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms

convert_xfm -omat ${RESULTSDIR}/T1_day1_2_func_pre.mat -concat ${T1_2_FUNC_PRE} ${RESULTSDIR}/T1_day1_2_pre.mat 

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat

flirt -applyxfm -init ${RESULTSDIR}/T1_day1_2_func_pre.mat -in ${ANATDIR_DAY1}/T1 -ref ${ANALYSISDIR}/${PRE}/fmri/rs.feat/example_func -out ${RESULTSDIR}/T1_day1_2_func_pre

fsleyes ${RESULTSDIR}/T1_day1_2_func_pre ${ANALYSISDIR}/${PRE}/fmri/rs.feat/example_func
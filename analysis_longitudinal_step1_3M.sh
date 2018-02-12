#!/bin/bash

MYSUB_PREFIX=$1
DAY1=${MYSUB_PREFIX}-$2
THREEMONTH=${MYSUB_PREFIX}-$3

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms
mkdir $RESULTSDIR

ANATDIR_3M=${ANALYSISDIR}/${THREEMONTH}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat

flirt -in ${ANATDIR_3M}/T1_brain -ref ${ANATDIR_DAY1}/T1_brain -out ${RESULTSDIR}/T1_brain_3M_2_day1 -omat ${RESULTSDIR}/T1_3M_2_day1.mat
convert_xfm -omat ${RESULTSDIR}/T1_day1_2_3M.mat -inverse ${RESULTSDIR}/T1_3M_2_day1.mat

fsleyes ${ANATDIR_DAY1}/T1 ${RESULTSDIR}/T1_brain_3M_2_day1
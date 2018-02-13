#!/bin/bash

MYSUB_PREFIX=$1
DAY1=${MYSUB_PREFIX}-$2
THREEMONTH=${MYSUB_PREFIX}-$3

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms


ANATDIR_3M=${ANALYSISDIR}/${THREEMONTH}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat

fslmaths ${ANATDIR_3M}/mT1 -mas ${ANATDIR_3M}/spm_mask ${ANATDIR_3M}/mT1_brain

flirt -in ${ANATDIR_3M}/mT1_brain -ref ${ANATDIR_DAY1}/mT1_brain -out ${RESULTSDIR}/mT1_brain_3M_2_day1_6dof -omat ${RESULTSDIR}/mT1_3M_2_day1_6dof.mat -dof 6

convert_xfm -omat ${RESULTSDIR}/mT1_day1_2_3M_6dof.mat -inverse ${RESULTSDIR}/mT1_3M_2_day1_6dof.mat

fsleyes ${ANATDIR_DAY1}/mT1 ${RESULTSDIR}/mT1_brain_3M_2_day1_6dof

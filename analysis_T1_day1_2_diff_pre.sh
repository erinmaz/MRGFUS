#!/bin/bash

MYSUB_PREFIX=$1
PRE=${MYSUB_PREFIX}-$2
DAY1=${MYSUB_PREFIX}-$3

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
RESULTSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms
T1XFMSDIR=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms_T1
DIFFDIR_PRE=${ANALYSISDIR}/${PRE}/diffusion

mkdir $RESULTSDIR

convert_xfm -omat ${RESULTSDIR}/T1_day1_2_diff_pre_bbr.mat -concat ${DIFFDIR_PRE}/xfms/T1_2_diff_bbr.mat ${T1XFMSDIR}/T1_brain_day1_2_pre_6dof.mat 

flirt -applyxfm -init ${RESULTSDIR}/T1_day1_2_diff_pre_bbr.mat -ref ${ANALYSISDIR}/${PRE}/diffusion/mean_b0_unwarped -in ${ANALYSISDIR}/${DAY1}/anat/T1 -out ${RESULTSDIR}/T1_day1_2_diff_pre_bbr 

fsleyes ${RESULTSDIR}/T1_day1_2_diff_pre_bbr ${ANALYSISDIR}/${PRE}/diffusion/mean_b0_unwarped

applywarp -i ${ANALYSISDIR}/${DAY1}/anat/T1_lesion_mask_filled -r ${ANALYSISDIR}/${PRE}/diffusion/mean_b0_unwarped -o ${ANALYSISDIR}/${PRE}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff --interp=trilinear --premat=${ANALYSISDIR}/${MYSUB_PREFIX}_longitudinal_xfms/T1_day1_2_diff_pre_bbr.mat

fslmaths ${ANALYSISDIR}/${PRE}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff -thr 0.5 -bin ${ANALYSISDIR}/${PRE}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin

fsleyes ${ANALYSISDIR}/${PRE}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${PRE}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin
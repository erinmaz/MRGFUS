#!/bin/bash
#assumes we have run analysis_longitudinal_step1.sh already

MYSUB=$1
PRE=$2
DAY1=$3

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis

${FSLDIR}/flirt -in ${MAINDIR}/${MYSUB}-${PRE}/anat/T1 -ref ${MAINDIR}/${MYSUB}-${PRE}/anat/T2 -out ${MAINDIR}/${MYSUB}-${PRE}/anat/T1_to_T2 -omat ${MAINDIR}/${MYSUB}-${PRE}/anat/T1_to_T2.mat -bins 256 -cost corratio -searchrx 0 0 -searchry 0 0 -searchrz 0 0 -dof 6  -interp trilinear

fsleyes ${MAINDIR}/${MYSUB}-${PRE}/anat/T1_to_T2 ${MAINDIR}/${MYSUB}-${PRE}/anat/T2

convert_xfm -omat ${MAINDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_T2_pre.mat -concat ${MAINDIR}/${MYSUB}-${PRE}/anat/T1_to_T2.mat ${MAINDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_pre_6dof.mat

flirt -in ${MAINDIR}/${MYSUB}-${DAY1}/anat/T1 -applyxfm -init  ${MAINDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_T2_pre.mat -ref ${MAINDIR}/${MYSUB}-${PRE}/anat/T2 -out ${MAINDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_T2_pre

fsleyes ${MAINDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_T2_pre ${MAINDIR}/${MYSUB}-${PRE}/anat/T2

cp ${MAINDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_T2_pre.mat ${DESTDIR}/${MYSUB}-${DAY1}/.
#!/bin/bash

ANALYSISDIR=$1 #directory where the files are located
MYSUB=$2 # e.g., 9001_SH
PRE=${MYSUB}-${3} # input 3: exam number for pre
DAY1=${MYSUB}-${4} # input 4: exam number for day1

RESULTSDIR=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms_T1
mkdir $RESULTSDIR

ANATDIR_PRE=${ANALYSISDIR}/${PRE}/anat
ANATDIR_DAY1=${ANALYSISDIR}/${DAY1}/anat

fslmaths ${ANATDIR_PRE}/mT1 -mas ${ANATDIR_PRE}/spm_mask ${ANATDIR_PRE}/mT1_brain
fslmaths ${ANATDIR_DAY1}/mT1 -mas ${ANATDIR_DAY1}/spm_mask ${ANATDIR_DAY1}/mT1_brain

#T1 pre to T1 day1
flirt -in ${ANATDIR_PRE}/mT1_brain -ref ${ANATDIR_DAY1}/mT1_brain -out ${RESULTSDIR}/mT1_brain_pre_2_day1_6dof -omat ${RESULTSDIR}/mT1_pre_2_day1_6dof.mat -dof 6

convert_xfm -omat ${RESULTSDIR}/mT1_day1_2_pre_6dof.mat -inverse ${RESULTSDIR}/mT1_pre_2_day1_6dof.mat

fsleyes ${ANATDIR_DAY1}/mT1_brain ${RESULTSDIR}/mT1_brain_pre_2_day1_6dof & # check results

#T1 pre to T2 pre
flirt -in ${MAINDIR}/${ANATDIR_PRE}/T1 -ref ${MAINDIR}/${ANATDIR_PRE}/T2 -out ${MAINDIR}/${ANATDIR_PRE}/T1_to_T2 -omat ${MAINDIR}/${ANATDIR_PRE}/T1_to_T2.mat -bins 256 -cost corratio -searchrx 0 0 -searchry 0 0 -searchrz 0 0 -dof 6  -interp trilinear

fsleyes ${MAINDIR}/${ANATDIR_PRE}/T1_to_T2 ${MAINDIR}/${ANATDIR_PRE}/T2 & # check results

fslmaths ${ANATDIR_DAY1}/spm_mask -sub ${ANATDIR_DAY1}/T1_lesion_mask_filled ${RESULTSDIR}/day1_mask

fnirt --iout=${RESULTSDIR}/day1_to_pre_warped --in=${ANATDIR_DAY1}/mT1 --inmask=${RESULTSDIR}/day1_mask --aff=${RESULTSDIR}/mT1_day1_2_pre_6dof.mat --cout=${RESULTSDIR}/day1_to_pre_warp --jout=${RESULTSDIR}/day1_to_pre_jac --config=T1_2_MNI152_2mm --ref=${ANATDIR_PRE}/mT1  --refmask=${ANATDIR_PRE}/spm_mask --warpres=10,10,10 

fsleyes ${ANATDIR_PRE}/mT1 ${RESULTSDIR}/day1_to_pre_warped & # check results
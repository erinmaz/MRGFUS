#!/bin/bash

#subject ID as input
MYSUB=$1

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
SPMDIR=/Users/erin/Documents/MATLAB/spm12
mkdir ${ANALYSISDIR}/${MYSUB}
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
mkdir ${ANATDIR}

rm ${DICOMDIR}/${MYSUB}/*-3D_FIESTA*/*.nii*
dcm2niix ${DICOMDIR}/${MYSUB}/*-3D_FIESTA*
mv ${DICOMDIR}/${MYSUB}/*-3D_FIESTA*/*.nii.gz ${ANATDIR}/3D_FIESTA.nii.gz
fsleyes ${ANATDIR}/3D_FIESTA.nii.gz


MYSUB_PRE=$1
MYSUB_PRE=9002_RA-11764
Erins-MacBook-Pro:~ erin$ flirt -in ${ANATDIR}/3D_FIESTA -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/InsightecData/ExablateMatrices/9002-ExablateMat-IntraOp-To-Pretreatment.csv -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/anat/T2.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/anat/3D_FIESTA_to_T2
Erins-MacBook-Pro:~ erin$ fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/anat/3D_FIESTA_to_T2 /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/anat/T2
Totally off
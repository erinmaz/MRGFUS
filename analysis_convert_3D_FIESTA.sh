#!/bin/bash
#INPUTS
#1 - subject ID (pretreatment)
#2 - subject ID (treatment)
#3 - flirt format mat as 2nd input (treatment 2 pretreatment)

MYSUB_PRE=$1
MYSUB=$2
MYXFM=$3


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

flirt -in ${ANATDIR}/3D_FIESTA -applyxfm -init ${MYXFM} -ref ${ANALYSISDIR}/${MYSUB_PRE}/anat/T2 -out ${ANALYSISDIR}/${MYSUB_PRE}/anat/3D_FIESTA_to_T2
fsleyes ${ANALYSISDIR}/${MYSUB_PRE}/anat/3D_FIESTA_to_T2 ${ANALYSISDIR}/${MYSUB_PRE}/anat/T2
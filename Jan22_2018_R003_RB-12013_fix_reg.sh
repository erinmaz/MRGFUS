#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
MYSUB=9003_RB-12013
ANATDIR=${MAINDIR}/analysis/${MYSUB}/anat
FMRIDIR=${MAINDIR}/analysis/${MYSUB}/fmri

cp -R $ANATDIR ${MAINDIR}/analysis/${MYSUB}/anat_badreg2standard
cp -R $FMRIDIR ${MAINDIR}/analysis/${MYSUB}/fmri_badreg2standard

fslmaths ${ANATDIR}/c3T1 -thr .99 ${ANATDIR}/c3T1_99
fslmaths ${ANATDIR}/c1T1 -add ${ANATDIR}/c2T1 -add ${ANATDIR}/c3T1_99 -fillh ${ANATDIR}/spm_mask
fsleyes ${ANATDIR}/T1 ${ANATDIR}/spm_mask
fslmaths  ${ANATDIR}/T1 -mas ${ANATDIR}/spm_mask  ${ANATDIR}/T1_brain
feat ${FMRIDIR}/reg.fsf

#almost no difference at lal, maybe a tiny bit worse.

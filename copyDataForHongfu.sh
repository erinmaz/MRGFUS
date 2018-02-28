#!/bin/bash
MYSUB=$1

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis/${MYSUB}

TARGETDIR=/Volumes/Pikelab/ELM/forHongfu/${MYSUB}

mkdir ${TARGETDIR}
mkdir ${TARGETDIR}/analysis
mkdir ${TARGETDIR}/analysis/anat
mkdir ${TARGETDIR}/analysis/fmri

cp ${ANALYSISDIR}/anat/*T1* ${TARGETDIR}/analysis/anat/.
cp ${ANALYSISDIR}/anat/spm_mask* ${TARGETDIR}/analysis/anat/.

#for T1 to standard space reg
cp -r ${ANALYSISDIR}/fmri/rs_reg.feat ${TARGETDIR}/analysis/fmri/.

#manually delete garbage
cp -r ${ANALYSISDIR}/diffusion ${TARGETDIR}/analysis/.
cp -r ${ANALYSISDIR}/diffusion.bedpostX ${TARGETDIR}/analysis/.

#manually delete confusing stuff
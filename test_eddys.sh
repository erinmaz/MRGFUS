#!/bin/bash

#subject ID as input
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
SPMDIR=/Users/erin/Documents/MATLAB/spm12
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
OUTDIR=${ANALYSISDIR}/${MYSUB}/diffusion/testeddy_cpu
mkdir $OUTDIR

time eddy_cpu --imain=${ANALYSISDIR}/${MYSUB}/diffusion/data_uncorrected --mask=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask.nii.gz --acqp=${SCRIPTSDIR}/acqp_eddy.txt --index=${SCRIPTSDIR}/index.txt --bvecs=${SCRIPTSDIR}/bvecs --bvals=${SCRIPTSDIR}/bvals --topup=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --out=${OUTDIR}/data


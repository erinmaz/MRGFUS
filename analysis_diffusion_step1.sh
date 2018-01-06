#!/bin/bash
#subject IDs as input
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
cp ${SCRIPTSDIR}/bvecs ${DIFFDIR}/.
cp ${SCRIPTSDIR}/bvals ${DIFFDIR}/.
bedpostx ${DIFFDIR} 

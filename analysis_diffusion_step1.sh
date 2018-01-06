#!/bin/bash
#subject IDs as input
MYSUB=$1
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
cp ${SCRIPTSDIR}/bvecs ${DIFFDIR}/.
cp ${SCRIPTSDIR}/bvals ${DIFFDIR}/.
bedpostx ${DIFFDIR} 

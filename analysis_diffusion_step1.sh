#!/bin/bash
#subject IDs as input
MYSUB_PRE=$1
MYSUB_POST=$2
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts
DIFFDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/diffusion
DIFFDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/diffusion
cp ${SCRIPTSDIR}/bvecs ${DIFFDIR_PRE}/.
cp ${SCRIPTSDIR}/bvecs ${DIFFDIR_POST}/.
cp ${SCRIPTSDIR}/bvals ${DIFFDIR_PRE}/.
cp ${SCRIPTSDIR}/bvals ${DIFFDIR_POST}/.
bedpostx ${DIFFDIR_PRE} &
bedpostx ${DIFFDIR_POST}


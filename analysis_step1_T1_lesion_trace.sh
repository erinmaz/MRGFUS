#!/bin/bash

#subject IDs as input
MYSUB_PRE=$1
MYSUB_POST=$2 #day 1 scan
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts
ANATDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/anat
ANATDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/anat
XFMSDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/xfms
mkdir ${XFMSDIR_PRE}
XFMSDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/xfms
mkdir ${XFMSDIR_POST}

#Trace lesion on post scan's T1
fsleyes ${ANATDIR_POST}/T1

#register post T1 to pre T1
flirt -in ${ANATDIR_POST}/T1_brain -ref ${ANATDIR_PRE}/T1_brain -dof 6 -o ${ANATDIR_PRE}/T1_brain_post2T1_brain_pre -omat ${XFMSDIR_PRE}/T1_post2pre.mat

fsleyes ${ANATDIR_PRE}/T1_brain ${ANATDIR_PRE}/T1_brain_post2T1_brain_pre
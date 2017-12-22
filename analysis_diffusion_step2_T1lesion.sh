#!/bin/bash
#subject IDs as input
MYSUB_PRE=$1
MYSUB_POST=$2
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts
DIFFDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/diffusion
DIFFDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/diffusion
XFMSDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/xfms
XFMSDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/xfms
ANATDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/anat
ANATDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/anat

cp ${DIFFDIR_PRE}/nodif_brain.nii.gz ${DIFFDIR_PRE}.bedpostX/.
cp ${DIFFDIR_POST}/nodif_brain.nii.gz ${DIFFDIR_POST}.bedpostX/.

flirt -in ${ANATDIR_POST}/T1_brain -ref ${ANATDIR_PRE}/T1_brain -omat ${XFMSDIR_PRE}/T1_post2T1_pre.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio -out ${ANATDIR_PRE}/T1_brain_post2T1_brain_pre

flirt -applyxfm -init ${XFMSDIR_PRE}/T1_post2T1_pre.mat -ref ${ANATDIR_PRE}/T1 -in ${ANATDIR_POST}/T1 -out ${ANATDIR_PRE}/T1_post2T1_pre

flirt -applyxfm -init ${XFMSDIR_PRE}/T1_post2T1_pre.mat -ref ${ANATDIR_PRE}/T1 -in ${ANATDIR_POST}/T1_lesion_mask_filled -out ${ANATDIR_PRE}/T1_lesion_mask_filled_post2T1_pre

fsleyes ${ANATDIR_PRE}/T1 ${ANATDIR_PRE}/T1_brain_post2T1_brain_pre ${ANATDIR_PRE}/T1_post2T1_pre

probtrackx2  -x ${ANATDIR_PRE}/T1_lesion_mask_filled_post2T1_pre  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm=${DIFFDIR_PRE}.bedpostX/xfms/str2diff.mat --forcedir --opd -s ${DIFFDIR_PRE}.bedpostX/merged -m ${DIFFDIR_PRE}.bedpostX/nodif_brain_mask  --dir=${DIFFDIR_PRE}.bedpostX/probtrackX_results/T1_lesion_mask_filled

fsleyes ${DIFFDIR_PRE}.bedpostX/nodif_brain ${DIFFDIR_PRE}.bedpostX/probtrackX_results/T1_lesion_mask_filled/fdt_paths

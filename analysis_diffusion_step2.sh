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

flirt -in ${DIFFDIR_PRE}.bedpostX/nodif_brain -ref ${ANATDIR_PRE}/T1_brain.nii.gz -omat ${DIFFDIR_PRE}.bedpostX/xfms/diff2str.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio

convert_xfm -omat ${DIFFDIR_PRE}.bedpostX/xfms/str2diff.mat -inverse ${DIFFDIR_PRE}.bedpostX/xfms/diff2str.mat

convert_xfm -omat ${XFMSDIR_PRE}/swan_mag_post2highres_pre.mat -concat ${XFMSDIR_PRE}/SWAN2highres.mat ${XFMSDIR_POST}/SWAN_mag_post2pre.mat 

flirt -applyxfm -init ${XFMSDIR_PRE}/swan_mag_post2highres_pre.mat -ref ${ANATDIR_PRE}/T1 -in ${ANATDIR_POST}/SWAN_mag -out ${ANATDIR_PRE}/SWAN_mag_post2highres 

fsleyes ${ANATDIR_PRE}/SWAN_mag_post2highres  ${ANATDIR_PRE}/T1

flirt -applyxfm -init ${XFMSDIR_PRE}/swan_mag_post2highres_pre.mat -ref ${ANATDIR_PRE}/T1 -in ${ANATDIR_POST}/SWAN_lesion_mask -out ${ANATDIR_PRE}/SWAN_lesion_mask2highres -interp nearestneighbour

mkdir ${DIFFDIR_PRE}.bedpostX/probtrackX_results

probtrackx2  -x ${ANATDIR_PRE}/SWAN_lesion_mask2highres.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm=${DIFFDIR_PRE}.bedpostX/xfms/str2diff.mat --forcedir --opd -s ${DIFFDIR_PRE}.bedpostX/merged -m ${DIFFDIR_PRE}.bedpostX/nodif_brain_mask  --dir=${DIFFDIR_PRE}.bedpostX/probtrackX_results/SWAN_lesion_mask

fsleyes ${DIFFDIR_PRE}.bedpostX/nodif_brain ${DIFFDIR_PRE}.bedpostX/probtrackX_results/SWAN_lesion_mask/fdt_paths

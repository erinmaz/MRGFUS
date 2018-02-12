#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#subject IDs as input
MYSUB=$1

#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
#cp $0 ${ANALYSISDIR}/${MYSUB}/.

MYSUB_PRE=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}

#full path of mask (in day1 T1 space)
MYMASK=`imglob $4`
MASKNAME=`basename $MYMASK`

convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_diff_pre.mat -concat ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/xfms/str2diff.mat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_pre.mat

mkdir ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois

flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_diff_pre.mat -in $MYMASK -ref ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/nodif_brain -interp nearestneighbour -out ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois/${MASKNAME}

mkdir ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion/rois

flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion/xfms/str2diff.mat -in $MYMASK -ref ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion/nodif_brain -interp nearestneighbour -out ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion/rois/${MASKNAME}

/usr/local/fsl/bin/probtrackx2  -x ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois/${MASKNAME} -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${MASKNAME} & 

/usr/local/fsl/bin/probtrackx2  -x ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion/rois/${MASKNAME} -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_DAY1}/diffusion.bedpostX/${MASKNAME} & 

wait

fsleyes ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${MASKNAME}/fdt_paths &

fsleyes ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB_DAY1}/diffusion.bedpostX/${MASKNAME}/fdt_paths &

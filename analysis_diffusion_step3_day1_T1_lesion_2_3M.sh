#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#subject IDs as input
MYSUB=$1

#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
#cp $0 ${ANALYSISDIR}/${MYSUB}/.

MYSUB_DAY1=${MYSUB}-${2}
MYSUB_3M=${MYSUB}-${3}


#full path of mask (in day1 T1 space)
MYMASK=`imglob $4`
MASKNAME=`basename $MYMASK`

convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_diff_3M.mat -concat ${ANALYSISDIR}/${MYSUB_3M}/diffusion/xfms/str2diff.mat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_3M.mat

mkdir ${ANALYSISDIR}/${MYSUB_3M}/diffusion/rois

flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_day1_2_diff_3M.mat -in $MYMASK -ref ${ANALYSISDIR}/${MYSUB_3M}/diffusion/nodif_brain -interp nearestneighbour -out ${ANALYSISDIR}/${MYSUB_3M}/diffusion/rois/${MASKNAME}


/usr/local/fsl/bin/probtrackx2  -x ${ANALYSISDIR}/${MYSUB_3M}/diffusion/rois/${MASKNAME} -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_3M}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_3M}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_3M}/diffusion.bedpostX/${MASKNAME} 

fsleyes ${ANALYSISDIR}/${MYSUB_3M}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB_3M}/diffusion.bedpostX/${MASKNAME}/fdt_paths &



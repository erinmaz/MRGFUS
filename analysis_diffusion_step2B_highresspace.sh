#!/bin/bash
#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
cp $0 ${ANALYSISDIR}/${MYSUB}/.

#subject IDs as input
MYSUB=$1

#full path of mask (in highres space)
MYMASK=`imglob $2`
MASKNAME=`basename $MYMASK`

#full path of highres2diff mat file
MYREG_diff=$3

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion

mkdir $DIFFDIR/rois

flirt -applyxfm -init ${MYREG_diff} -in $MYMASK -ref ${DIFFDIR}/nodif_brain -o DIFFDIR/rois/$MASKNAME -interp nearestneighbour

fsleyes ${DIFFDIR}/nodif_brain $DIFFDIR/rois/$MASKNAME

mkdir -p ${DIFFDIR}.bedpostX/${MASKNAME}

/usr/local/fsl/bin/probtrackx2  -x $DIFFDIR/rois/$MASKNAME -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${DIFFDIR}.bedpostX/merged -m ${DIFFDIR}.bedpostX/nodif_brain_mask  --dir=${DIFFDIR}.bedpostX/${MASKNAME}
#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
cp $0 ${ANALYSISDIR}/${MYSUB}/.

#subject IDs as input
MYSUB=$1

#full path of mask (in standard space)
MYMASK=`imglob $2`
MASKNAME=`basename $MYMASK`

#full path of standard2highres_warp 
MYREG_highres=$3

#full path of highres2diff
MYREG_diff=$4


DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
THALAMUS_MASK=${SCRIPTSDIR}/harvardoxford-subcortical/thalamus_L_final
THALAMUS_MASK_NAME=`basename ${THALAMUS_MASK}`

if [ ! -f ${MYREG_highres} ]
then
	regdir=`dirname ${MYREG_highres}`
	invwarp -w ${regdir}/highres2standard_warp -o ${MYREG_highres} -r ${regdir}/highres
fi


mkdir $DIFFDIR/rois
applywarp -i $MYMASK -r ${DIFFDIR}/nodif_brain -o $DIFFDIR/rois/$MASKNAME -w ${MYREG_highres} --postmat=${MYREG_diff} --interp=nn
applywarp -i ${THALAMUS_MASK} -r ${DIFFDIR}/nodif_brain -o $DIFFDIR/rois/${THALAMUS_MASK_NAME} -w ${MYREG_highres} --postmat=${MYREG_diff} --interp=nn 

fsleyes ${DIFFDIR}/nodif_brain $DIFFDIR/rois/$MASKNAME $DIFFDIR/rois/${THALAMUS_MASK_NAME} &

mkdir -p ${DIFFDIR}.bedpostX/${MASKNAME}_thalamus

/usr/local/fsl/bin/probtrackx2  -x $DIFFDIR/rois/$MASKNAME -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${DIFFDIR}.bedpostX/merged -m ${DIFFDIR}.bedpostX/nodif_brain_mask  --dir=${DIFFDIR}.bedpostX/${MASKNAME}_thalamus --waypoints=$DIFFDIR/rois/${THALAMUS_MASK_NAME}  --waycond=AND
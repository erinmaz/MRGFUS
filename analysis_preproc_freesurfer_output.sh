#!/bin/bash
#MUST BBE CONNECTED TO PIKELAB

MYSUB=$1
anatdir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat
FREESURFER_OUTPUT=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/freesurfer_output
FREESURFER_DATA=/Volumes/Pikelab/ELM/ForEthan_Freesurfer/${MYSUB}/masks
FREESURFER_ROIS=(lh.BA1.thresh.label lh.BA2.thresh.label lh.BA3a.thresh.label lh.BA3b.thresh.label lh.BA4a.thresh.label lh.BA4p.thresh.label lh.BA6.thresh.label rh.BA1.thresh.label rh.BA2.thresh.label rh.BA3a.thresh.label rh.BA3b.thresh.label rh.BA4a.thresh.label rh.BA4p.thresh.label rh.BA6.thresh.label)
mkdir ${FREESURFER_OUTPUT}
fslreorient2std /Volumes/Pikelab/ELM/ForEthan_Freesurfer/${MYSUB}/T1_anatomical_fs ${FREESURFER_OUTPUT}/T1_anatomical_fs
for roi in ${FREESURFER_ROIS[@]}
do
fslreorient2std ${FREESURFER_DATA}/${roi} ${FREESURFER_OUTPUT}/${roi}
done

flirt -in ${FREESURFER_OUTPUT}/T1_anatomical_fs.nii.gz -ref ${anatdir}/mT1 -dof 6 -out ${FREESURFER_OUTPUT}/T1_anatomical_fs2mT1 -omat ${FREESURFER_OUTPUT}/T1_anatomical_fs2mT1.mat

fsleyes ${FREESURFER_OUTPUT}/T1_anatomical_fs2mT1 ${anatdir}/mT1

#!/bin/bash


MYSUB=$1
ANALYSIS_DIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${MYSUB}
mkdir ${ANALYSIS_DIR}/xfms

flirt -in ${ANALYSIS_DIR}/anat/T1 -ref ${ANALYSIS_DIR}/anat/SWAN_mag.nii.gz -out ${ANALYSIS_DIR}/anat/T12SWAN_mag_direct -dof 6 -omat  ${ANALYSIS_DIR}/xfms/T12SWAN_mag_direct.mat 

flirt -in ${ANALYSIS_DIR}/anat/T1_lesion_mask_filled -ref ${ANALYSIS_DIR}/anat/SWAN_mag.nii.gz -out ${ANALYSIS_DIR}/anat/T1_lesion_mask_filled2SWAN_mag -applyxfm -init ${ANALYSIS_DIR}/xfms/T12SWAN_mag_direct.mat -interp nearestneighbour

fsleyes ${ANALYSIS_DIR}/anat/T12SWAN_mag_direct ${ANALYSIS_DIR}/anat/SWAN_mag ${ANALYSIS_DIR}/anat/T1_lesion_mask_filled2SWAN_mag

#!/bin/bash

#subject IDs as input
MYSUB_PRE=$1
MYSUB_POST=$2
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts
ANATDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/anat
ANATDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/anat
FUNCDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/fmri
FUNCDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/fmri
XFMSDIR_PRE=${ANALYSISDIR}/${MYSUB_PRE}/xfms
mkdir ${XFMSDIR_PRE}
XFMSDIR_POST=${ANALYSISDIR}/${MYSUB_POST}/xfms
mkdir ${XFMSDIR_POST}

#Trace lesion on post scans SWAN
fsleyes ${ANATDIR_POST}/SWAN_mag

#register SWAN to func, get lesion mask in func space (post timepoint)
flirt -in ${FUNCDIR_POST}/rs.feat/filtered_func_data.feat/reg/example_func2highres.nii.gz -o ${ANATDIR_POST}/example_func2highres2SWAN -ref ${ANATDIR_POST}/SWAN_mag -dof 6 -omat ${XFMSDIR_POST}/highres2SWAN.mat

fsleyes ${ANATDIR_POST}/example_func2highres2SWAN ${ANATDIR_POST}/SWAN_mag

convert_xfm -omat ${XFMSDIR_POST}/SWAN2highres.mat -inverse ${XFMSDIR_POST}/highres2SWAN.mat

convert_xfm -omat ${XFMSDIR_POST}/SWAN2example_func.mat -concat ${FUNCDIR_POST}/rs.feat/filtered_func_data.feat/reg/highres2example_func.mat ${XFMSDIR_POST}/SWAN2highres.mat

flirt -applyxfm -init ${XFMSDIR_POST}/SWAN2example_func.mat -in ${ANATDIR_POST}/SWAN_mag -out ${FUNCDIR_POST}/SWAN_mag2func -ref ${FUNCDIR_POST}/rs.feat/filtered_func_data.feat/reg/example_func

fsleyes ${FUNCDIR_POST}/SWAN_mag2func ${FUNCDIR_POST}/rs.feat/filtered_func_data.feat/reg/example_func

flirt -applyxfm -init ${XFMSDIR_POST}/SWAN2example_func.mat -in ${ANATDIR_POST}/SWAN_lesion_mask -out ${FUNCDIR_POST}/SWAN_lesion_mask2func -interp nearestneighbour -ref ${FUNCDIR_POST}/rs.feat/filtered_func_data.feat/reg/example_func

fsleyes  ${FUNCDIR_POST}/SWAN_lesion_mask2func ${FUNCDIR_POST}/rs.feat/filtered_func_data.feat/reg/example_func

#register pre SWAN to post SWAN, get mask in pre func space
flirt -in ${ANATDIR_POST}/SWAN_mag -ref ${ANATDIR_PRE}/SWAN_mag -dof 6 -o ${ANATDIR_PRE}/SWAN_mag_post2pre -omat ${XFMSDIR_POST}/SWAN_mag_post2pre.mat

fsleyes ${ANATDIR_PRE}/SWAN_mag ${ANATDIR_PRE}/SWAN_mag_post2pre

#register SWAN to func (pre timepoint)
flirt -in ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func2highres.nii.gz -o ${ANATDIR_PRE}/example_func2highres2SWAN -ref ${ANATDIR_PRE}/SWAN_mag -dof 6 -omat ${XFMSDIR_PRE}/highres2SWAN.mat

fsleyes ${ANATDIR_PRE}/example_func2highres2SWAN ${ANATDIR_PRE}/SWAN_mag

convert_xfm -omat ${XFMSDIR_PRE}/SWAN2highres.mat -inverse ${XFMSDIR_PRE}/highres2SWAN.mat

convert_xfm -omat ${XFMSDIR_PRE}/SWAN2example_func.mat -concat ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/highres2example_func.mat ${XFMSDIR_PRE}/SWAN2highres.mat

flirt -applyxfm -init ${XFMSDIR_PRE}/SWAN2example_func.mat -in ${ANATDIR_PRE}/SWAN_mag -out ${FUNCDIR_PRE}/SWAN_mag2func -ref ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func

fsleyes ${FUNCDIR_PRE}/SWAN_mag2func ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func

#SWAN POST TO FUNC PRE
convert_xfm -omat ${XFMSDIR_POST}/SWAN_post2func_pre.mat -concat ${XFMSDIR_PRE}/SWAN2example_func.mat ${XFMSDIR_POST}/SWAN_mag_post2pre.mat

flirt -applyxfm -init ${XFMSDIR_POST}/SWAN_post2func_pre.mat -in ${ANATDIR_POST}/SWAN_mag -ref ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func -o ${FUNCDIR_PRE}/SWAN_post2func_pre

fsleyes ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func ${FUNCDIR_PRE}/SWAN_post2func_pre

flirt -applyxfm -init ${XFMSDIR_POST}/SWAN_post2func_pre.mat -in ${ANATDIR_POST}/SWAN_lesion_mask -ref ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func -o ${FUNCDIR_PRE}/SWAN_lesion_mask_post2func_pre -interp nearestneighbour 

fsleyes ${FUNCDIR_PRE}/SWAN_lesion_mask_post2func_pre ${FUNCDIR_PRE}/rs.feat/filtered_func_data.feat/reg/example_func




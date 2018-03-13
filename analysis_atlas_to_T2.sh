#!/bin/bash
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANATDIR=${MAINDIR}/analysis/${MYSUB}/anat
XFMSDIR=${MAINDIR}/analysis/${MYSUB}/xfms
mkdir $XFMSDIR

bet ${ANATDIR}/T2 ${ANATDIR}/T2_brain -m -f .25 -S

bet ${ANATDIR}/T2_2 ${ANATDIR}/T2_2_brain -m -f .25 -S

flirt -in ${ANATDIR}/T2_2 -ref ${ANATDIR}/T2 -out ${ANATDIR}/T2_2_to_T2_ns -dof 6 -omat ${XFMSDIR}/T2_2_to_T2_ns.mat -nosearch

fsleyes ${ANATDIR}/T2_2_to_T2 ${ANATDIR}/T2

fslmaths ${ANATDIR}/T2_2_to_T2 -add ${ANATDIR}/T2 -div 2 ${ANATDIR}/T2_avg

fslmaths ${ANATDIR}/T2_avg ${XFMSDIR}/T2_avg

flirt -in ${ANATDIR}/T1 -ref ${XFMSDIR}/T2_avg -out ${XFMSDIR}/T1_to_T2_avg -dof 6 -omat ${XFMSDIR}/T1_to_T2_avg.mat

fsleyes ${XFMSDIR}/T2_avg ${XFMSDIR}/T1_to_T2_avg

/usr/local/fsl/bin/flirt -in ${ANATDIR}/T1_brain -ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain -out ${XFMSDIR}/T12MNI_1mm -omat ${XFMSDIR}/T12MNI_1mm.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 

/usr/local/fsl/bin/fnirt --in=${ANATDIR}/T1 --aff=${XFMSDIR}/T12MNI_1mm.mat --cout=${XFMSDIR}/T12MNI_1mm_warp --iout=${XFMSDIR}/T12MNI_1mm --jout=${XFMSDIR}/T12MNI_1mm_jac --config=T1_2_MNI152_2mm --ref=/usr/local/fsl/data/standard/MNI152_T1_1mm --refmask=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10

fsleyes ${XFMSDIR}/T12MNI_1mm /usr/local/fsl/data/standard/MNI152_T1_1mm 

invwarp -w ${XFMSDIR}/T12MNI_1mm_warp -o ${XFMSDIR}/MNI_1mm2T1_warp -r ${ANATDIR}/T1 

/usr/local/fsl/bin/applywarp -i ${MAINDIR}/atlases/HistThalAtlas_rois/Vim -r ${ANATDIR}/T2_avg -o ${ANATDIR}/Vim_to_T2_avg -w ${XFMSDIR}/MNI_1mm2T1_warp --postmat=${XFMSDIR}/T1_to_T2_avg.mat --interp=nn
 
fsleyes ${ANATDIR}/T2_avg ${ANATDIR}/Vim_to_T2_avg

fslmaths ${ANATDIR}/Vim_to_T2_avg -binv ${ANATDIR}/Vim_to_T2_avg_mask

fslmaths ${ANATDIR}/T2_avg -mas ${ANATDIR}/Vim_to_T2_avg_mask ${ANATDIR}/T2_avg_burned_low
range=`fslstats ${ANATDIR}/T2_avg -R`

rangerray=($range)

fslmaths ${ANATDIR}/Vim_to_T2_avg -mul 2 -mul ${rangearray[1]} ${ANATDIR}/Vim_to_T2_avg_mul

fslmaths ${ANATDIR}/T2_avg -add ${ANATDIR}/Vim_to_T2_avg_mul ${ANATDIR}/T2_avg_Vim_burned_high

fsleyes ${ANATDIR}/T2_avg_burned_low ${ANATDIR}/T2_avg_Vim_burned_high
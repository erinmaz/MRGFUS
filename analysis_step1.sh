#!/bin/bash

#subject ID as input
MYSUB=$1
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
FUNCDIR=${ANALYSISDIR}/${MYSUB}/fmri

#BET T1 - NOT WORKING WELL
#bet ${ANATDIR}/T1 ${ANATDIR}/T1_brain -m -B -f 0.15
#fsleyes ${ANATDIR}/T1 ${ANATDIR}/T1_brain_mask & 

#SPM Segment
fslchfiletype NIFTI ${ANATDIR}/T1
export MATLABPATH="~/matlab/spm12:/home/erinmazerolle/MRGFUS/scripts"
matlab -nosplash -nodesktop -r "segment_job({'${ANATDIR}/T1.nii,1'}) ; quit"
fslmaths ${ANATDIR}/c1T1 -add ${ANATDIR}/c2T1 -add ${ANATDIR}/c3T1 -bin -fillh ${ANATDIR}/spm_mask
fslmaths ${ANATDIR}/T1 -mas ${ANATDIR}/spm_mask ${ANATDIR}/T1_brain

#reg func 2 anat
sed 's:MYSUB:'${MYSUB}':g' ${SCRIPTSDIR}/regfunc2T1_noPURE.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/regfunc2T1_noPURE.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/regfunc2T1_noPURE.fsf




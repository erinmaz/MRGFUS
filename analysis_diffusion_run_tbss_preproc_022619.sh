#!/bin/bash

#ALL OF THIS PREPROCESSING CAN OCCUR BEFORE BEDPOST IS FINISHED

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
TBSSNAME=tbss_022619

LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks

SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM )

mkdir ${MAINDIR}/${TBSSNAME}

for MYSUB in "${SUBS[@]}"
do
PRE=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'`
DAY1=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'`
MONTH3=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'`
xcoord_lesion_standard=`fslstats ${LESIONDIR}/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -c | awk '{print $1}'`
if [ $(bc -l <<< "$xcoord_lesion_standard < 0") -eq 1 ]; then 
TREATED_SIDE=L
fslmaths ${ANALYSISDIR}/${MYSUB}-${PRE}/diffusion/dtifit_FA ${MAINDIR}/${TBSSNAME}/${MYSUB}-${PRE}_FA
fslmaths ${ANALYSISDIR}/${MYSUB}-${DAY1}/diffusion/dtifit_FA ${MAINDIR}/${TBSSNAME}/${MYSUB}-${DAY1}_FA
fslmaths ${ANALYSISDIR}/${MYSUB}-${MONTH3}/diffusion/dtifit_FA ${MAINDIR}/${TBSSNAME}/${MYSUB}-${MONTH3}_FA
else
TREATED_SIDE=R
fslswapdim ${ANALYSISDIR}/${MYSUB}-${PRE}/diffusion/dtifit_FA -x y z ${MAINDIR}/${TBSSNAME}/${MYSUB}-${PRE}_FA
fslswapdim ${ANALYSISDIR}/${MYSUB}-${DAY1}/diffusion/dtifit_FA -x y z ${MAINDIR}/${TBSSNAME}/${MYSUB}-${DAY1}_FA
fslswapdim ${ANALYSISDIR}/${MYSUB}-${MONTH3}/diffusion/dtifit_FA -x y z ${MAINDIR}/${TBSSNAME}/${MYSUB}-${MONTH3}_FA
fi
done

cd ${MAINDIR}/${TBSSNAME}
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2

flirt -applyxfm -init ${ANALYSISDIR}/9010_RR-13536/diffusion/xfms/diff_2_T1_bbr.mat -in ${ANALYSISDIR}/9010_RR-13536/diffusion/dtifit_FA -ref ${ANALYSISDIR}/9010_RR-13536/anat/mT1 -out ${ANALYSISDIR}/9010_RR-13536/anat/xfms/ants/dtifit_FA2T1_lin

antsApplyTransforms -d 3 -i ${ANALYSISDIR}/9010_RR-13536/anat/xfms/ants/dtifit_FA2T1_lin.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o dtifit_FA_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz
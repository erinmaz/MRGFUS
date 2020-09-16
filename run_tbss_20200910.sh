#!/bin/bash
ANALYSISDIR=~/Desktop/Projects/MRGFUS/analysis
TBSSDIR=~/Desktop/Projects/MRGFUS/analysis/tbss_20200909
MYFILE=~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh
while read line; do

SUB=`echo $line | awk '{print $1}'` 
PRE=`echo $line | awk '{print $2}'` 
MONTH3=`echo $line | awk '{print $4}'`  

fslmaths ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/dtifit_FA ${TBSSDIR}/${SUB}-01_FA
fslmaths ${ANALYSISDIR}/${SUB}-${MONTH3}/diffusion/dtifit_FA ${TBSSDIR}/${SUB}-03_FA

done <$MYFILE

cd $TBSSDIR
tbss_1_preproc *.nii*
tbss_2_reg -T
tbss_3_postreg -S
cd stats
fsleyes all_FA mean_FA_skeleton 
tbss_4_prestats 0.2
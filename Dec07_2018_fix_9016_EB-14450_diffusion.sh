#!/bin/bash

MYSUB=9016_EB-14450
MYCOIL=32ch
cp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion_auto

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion

mkdir ${DIFFDIR}/tmp
fslsplit ${DIFFDIR}/data_uncorrected ${DIFFDIR}/tmp/data_uncorrected -t

#rm vol 3 and 33
mystring=""
for i in 00 01 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56
do
mystring=`echo $mystring ${DIFFDIR}/tmp/data_uncorrected00${i}`
done
fslmerge -t ${DIFFDIR}/data_uncorrected $mystring

awk '!($33="")' ${SCRIPTSDIR}/bvecs > ${DIFFDIR}/bvecs_tmp
awk '!($3="")' ${DIFFDIR}/bvecs_tmp > ${DIFFDIR}/bvecs

awk '!($33="")' ${SCRIPTSDIR}/bvals > ${DIFFDIR}/bvals_tmp
awk '!($3="")' ${DIFFDIR}/bvals_tmp > ${DIFFDIR}/bvals

awk '!(NR==33)' ${SCRIPTSDIR}/index.txt > ${DIFFDIR}/index_tmp.txt
awk '!(NR==3)' ${DIFFDIR}/index_tmp.txt > ${DIFFDIR}/index.txt

awk '!(NR==3)' ${SCRIPTSDIR}/acqp.txt > ${DIFFDIR}/acqp.txt

fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_b0 0 2
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_b0 0 3
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/all_b0 ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_b0 ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_b0
topup --imain=${ANALYSISDIR}/${MYSUB}/diffusion/all_b0 --datain=${DIFFDIR}/acqp.txt --config=b02b0.cnf --out=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --fout=${ANALYSISDIR}/${MYSUB}/diffusion/topup_field --iout=${ANALYSISDIR}/${MYSUB}/diffusion/all_b0_unwarped
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/all_b0_unwarped -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped

if [ "$MYCOIL" = "32ch" ]
then
	bet ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -m -f 0.3
else
	bet ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -m
fi

time eddy_cpu --imain=${DIFFDIR}/data_uncorrected --mask=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask --acqp=${SCRIPTSDIR}/acqp_eddy.txt --index=${DIFFDIR}/index.txt --bvecs=${DIFFDIR}/bvecs --bvals=${DIFFDIR}/bvals --topup=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --cnr_maps --repol --out=${ANALYSISDIR}/${MYSUB}/diffusion/data
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/data &
dtifit -k ${ANALYSISDIR}/${MYSUB}/diffusion/data -o ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit -m ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -r ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_rotated_bvecs -b ${DIFFDIR}/bvals --sse
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_V1 ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_sse &
#diffusion tsnr calc
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow 2 43
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev 50 6
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/dw ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tstd ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean -div ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_cnr_maps &
difftsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`
diffcnr=`fslstats -t ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_cnr_maps -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`

echo $difftsnr $diffcnr
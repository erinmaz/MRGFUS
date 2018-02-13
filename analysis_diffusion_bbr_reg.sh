#!/bin/bash

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion

for f in ${DICOMDIR}/${MYSUB}/*PUSAG_FSPGR_BRAVO*; do
    if [ -e "$f" ]; then
	PURET1=YES
    else
	PURET1=NO
    fi
    break
done

for f in ${DICOMDIR}/${MYSUB}/*PUDWI_45*; do
	if [ -e "$f" ]; then
		PUREdiff=YES
	else
		PUREdiff=NO
	fi
	break
done

if [ "$PURET1" = "YES" ] && [ "$PUREdiff" = "YES" ] 
then
	T1fordiffreg=${ANATDIR}/T1
	fslroi ${DIFFDIR}/all_b0_unwarped ${DIFFDIR}/b0_unwarped 0 1
	diffforreg=${DIFFDIR}/b0_unwarped
elif [ "$PURET1" = "NO" ] && [ "$PUREdiff" = "NO" ] 
then
	T1fordiffreg=${ANATDIR}/T1
	fslroi ${DIFFDIR}/all_b0_unwarped ${DIFFDIR}/b0_unwarped 0 1
	diffforreg=${DIFFDIR}/b0_unwarped
elif [ "$PURET1" = "YES" ]
then
	T1fordiffreg=${ANATDIR}/T1_noPURE
	fslroi ${DIFFDIR}/all_b0_unwarped ${DIFFDIR}/b0_unwarped 0 1
	diffforreg=${DIFFDIR}/b0_unwarped
elif [ "$PUREdiff" = "YES" ]
then
	T1fordiffreg=${ANATDIR}/T1
	diffforreg=${DIFFDIR}/dti_noPURE_unwarped_nodif_brain
fi

#echo epi_reg --epi=${diffforreg} --t1=${T1fordiffreg} --t1brain=${T1fordiffreg}_brain --out=${DIFFDIR}/xfms/diff_2_T1_bbr > ${MAINDIR}/logs/analysis_diffusion_bbr_reg_${MYSUB}.log

epi_reg --epi=${diffforreg} --t1=${T1fordiffreg} --t1brain=${T1fordiffreg}_brain --out=${DIFFDIR}/xfms/diff_2_T1_bbr
convert_xfm -omat ${DIFFDIR}/xfms/T1_2_diff_bbr.mat -inverse ${DIFFDIR}/xfms/diff_2_T1_bbr
fsleyes ${DIFFDIR}/xfms/diff_2_T1_bbr ${T1fordiffreg}
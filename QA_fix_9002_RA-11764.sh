#!/bin/bash

#subject ID as input
MYSUB=$1
MYCOIL=$2
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
SPMDIR=/Users/erin/Documents/MATLAB/spm12
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat


#################### SAVE QA SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
cp $0 ${ANALYSISDIR}/${MYSUB}/.


#################### GET SESSION INFO ##################################
file1=`find ${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO* -type f -not -name ".DS_Store" | head -1;` 
STUDYINFO=`dicom_hdr $file1 | egrep "ID Study Description" | cut -f5- -d "/"`
DATE=`dicom_hinfo -tag 0008,0020 -no_name $file1`

#################### T1 QA #############################################
for f in ${DICOMDIR}/${MYSUB}/*PUSAG_FSPGR_BRAVO*; do
    if [ -e "$f" ]; then
	PURET1=YES
	T1dir=$f
    else
	PURET1=NO
	T1dir=${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO*
    fi
    break
done


#################### T2 QA #############################################
for f in ${DICOMDIR}/${MYSUB}/*PUSag_CUBE_T2*; do
    if [ -e "$f" ]; then
	PURET2=YES
	T2dir=$f
    else
	PURET2=NO
	T2dir=${DICOMDIR}/${MYSUB}/*Sag_CUBE_T2*
    fi
    break
done


#################### Diffusion QA #######################################
for f in ${DICOMDIR}/${MYSUB}/*PUDWI_45*; do
	if [ -e "$f" ]; then
		PUREdiff=YES
		diff_fow_dir=$f
		diff_rev_dir=${DICOMDIR}/${MYSUB}/*PUDWI_PE*
	else
		PUREdiff=NO
		diff_fow_dir=${DICOMDIR}/${MYSUB}/*DWI_45*
		diff_rev_dir=${DICOMDIR}/${MYSUB}/*DWI_PE*
	fi
	break
done

#diffusion tsnr calc

difftsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`
diffcnr=`fslstats -t ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_cnr_maps -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`
if [ "$PURET1" = "YES" ] && [ "$PUREdiff" = "YES" ] 
then
	T1fordiffreg=${ANATDIR}/T1_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain
elif [ "$PURET1" = "NO" ] && [ "$PUREdiff" = "NO" ] 
then
	T1fordiffreg=${ANATDIR}/T1_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain

elif [ "$PURET1" = "YES" ]
then
	#not very efficient, because I potentially run these lines twice (once for fMRI and once for diffusion)
	dcm2niix ${DICOMDIR}/${MYSUB}/*-SAG_FSPGR_BRAVO*
	mv ${DICOMDIR}/${MYSUB}/*-SAG_FSPGR_BRAVO*/*.nii.gz ${ANATDIR}/T1_noPURE.nii.gz
	fslmaths ${ANATDIR}/T1_noPURE -mas ${ANATDIR}/spm_mask ${ANATDIR}/T1_noPURE_brain
	T1fordiffreg=${ANATDIR}/T1_noPURE_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain

elif [ "$PUREdiff" = "YES" ]
then
	T1fordiffreg=${ANATDIR}/T1_brain
	dcm2niix ${DICOMDIR}/${MYSUB}/*-DWI_45*
	mv ${DICOMDIR}/${MYSUB}/*-DWI_45*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE.nii.gz
	fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE_nodif 0 3
	dcm2niix ${DICOMDIR}/${MYSUB}/*-DWI_PE*
	mv ${DICOMDIR}/${MYSUB}/*-DWI_PE*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE.nii.gz
	fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE_nodif 0 3
	applytopup --imain=${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE_nodif,${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE_nodif -t ${ANALYSISDIR}/${MYSUB}/diffusion/topup_results -o ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif -a ${SCRIPTSDIR}/acqp_eddy.txt --inindex=1,2
	fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif 0 1
	fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif -mas ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif_brain
fi
mkdir ${ANALYSISDIR}/${MYSUB}/diffusion/xfms
flirt -in $diffforreg -ref $T1fordiffreg -omat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio -out ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str 
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str $T1fordiffreg &
convert_xfm -omat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/str2diff.mat -inverse ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str.mat 

	
############## fMRI QA ################################################
for f in ${DICOMDIR}/${MYSUB}/*PUrsBOLD*; do
    if [ -e "$f" ]; then
		PUREBOLD=YES
		BOLDdir=$f
    else
		PUREBOLD=NO
		BOLDdir=${DICOMDIR}/${MYSUB}/*rsBOLD*
    fi
    break
done

rstsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func -k` 	

################# SUMMARY OUTPUT ########################################
echo $MYSUB,$DATE,$STUDYINFO,$PURET1,$PURET2,$PUREdiff,$PUREBOLD,$difftsnr,`echo $diffcnr | tr ' ' ,` ,`awk '{ sum += $2; n++ } END { print sum / n; } ' ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_restricted_movement_rms`,$rstsnr,$rstsnr_mc_only,`awk -v max=0 '{if($1>max){ max=$1}}END{print max} ' ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms`,`awk '{ total += $1 } END { print total/NR}' ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms`








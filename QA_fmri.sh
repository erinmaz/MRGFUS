#!/bin/bash

#subject ID as input
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
SPMDIR=/Users/erin/Documents/MATLAB/spm12
mkdir ${ANALYSISDIR}/${MYSUB}
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
mkdir ${ANATDIR}


#################### GET SESSION INFO ##################################
file1=`find ${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO* -type f -not -name ".DS_Store" | head -1;` 
STUDYINFO=`dicom_hdr $file1 | egrep "ID Study Description" | cut -f5- -d "/"`


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

difftsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`

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

if [ "$PURET1" = "YES" ] && [ "$PUREBOLD" = "YES" ]
then
	T1forreg=${ANATDIR}/T1_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs.nii.gz
elif [ "$PURET1" = "NO" ] && [ "$PUREBOLD" = "NO" ]
then
	T1forreg=${ANATDIR}/T1_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs.nii.gz
elif [ "$PURET1" = "YES" ]
then
#need to get non-PURE T1 to reg with BOLD
	#not very efficient, because I potentially convert nonPURE T1 twice (once for fMRI and once for diffusion)
	dcm2niix ${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO*
	mv ${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO*/*.nii.gz ${ANATDIR}/T1_noPURE.nii.gz
	fslmaths ${ANATDIR}/T1_noPURE -mas ${ANATDIR}/spm_mask ${ANATDIR}/T1_noPURE_brain
	T1forreg=${ANATDIR}/T1_noPURE_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs.nii.gz
elif [ "$PUREBOLD" = "YES" ]
then
#need to get non-PURE BOLD to reg with T1
	dcm2niix ${DICOMDIR}/${MYSUB}/*rsBOLD*
	mv ${DICOMDIR}/${MYSUB}/*rsBOLD*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/fmri/rs_noPURE.nii.gz
	T1forreg=${ANATDIR}/T1_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs_noPURE.nii.gz
fi
sed 's:MYINPUT:'${BOLDforreg}':g' ${SCRIPTSDIR}/reg.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/reg.fsf
sed -i "" 's:MYT1:'${T1forreg}':g' ${ANALYSISDIR}/${MYSUB}/fmri/reg.fsf
sed -i "" 's:MYOUTPUT:'${ANALYSISDIR}'/'${MYSUB}'/fmri/rs_reg.feat:g'  ${ANALYSISDIR}/${MYSUB}/fmri/reg.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/reg.fsf
	

################# SUMMARY OUTPUT ########################################
echo $MYSUB $STUDYINFO $PURET1 $PURET2 $PUREdiff $PUREBOLD $difftsnr $rstsnr $rstsnr_mc_only `awk -v max=0 '{if($1>max){ max=$1}}END{print max} ' ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms` `awk '{ total += $1 } END { print total/NR}' ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms`








#!/bin/bash

#subject ID as first input, coil (12ch or 32ch) as 2nd input
MYSUB=$1
MYCOIL=$2
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
SPMDIR=/Users/erin/Documents/MATLAB/spm12
mkdir ${ANALYSISDIR}/${MYSUB}
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat
mkdir ${ANATDIR}

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

dcm2niix ${T1dir}
mv ${T1dir}/*.nii.gz ${ANATDIR}/T1.nii.gz

#SPM Segment
fslchfiletype NIFTI ${ANATDIR}/T1
export MATLABPATH="${SPMDIR}:${SCRIPTSDIR}"
nice matlab -nosplash -nodesktop -r "segment_job({'${ANATDIR}/T1.nii,1'}) ; quit"
fslchfiletype NIFTI_GZ ${ANATDIR}/T1
fslmaths ${ANATDIR}/c1T1 -add ${ANATDIR}/c2T1 -add ${ANATDIR}/c3T1 -bin -fillh ${ANATDIR}/spm_mask
fslmaths ${ANATDIR}/T1 -mas ${ANATDIR}/spm_mask ${ANATDIR}/T1_brain
fsleyes ${ANATDIR}/T1 ${ANATDIR}/spm_mask &


	
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
mkdir ${ANALYSISDIR}/${MYSUB}/fmri
dcm2niix ${BOLDdir}
mv ${BOLDdir}/*.nii.gz ${ANALYSISDIR}/${MYSUB}/fmri/rs.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs &
sed 's:MYINPUT:'${ANALYSISDIR}'/'${MYSUB}'/fmri/rs:g' ${SCRIPTSDIR}/QA_${MYCOIL}.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/QA_${MYCOIL}.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/QA_${MYCOIL}.fsf
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data -Tstd ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/std_func
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/mean_func -div ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/std_func ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func
rstsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func -k ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/mask -M`
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func &
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.ica/melodic_IC &
fsl_motion_outliers -i ${ANALYSISDIR}/${MYSUB}/fmri/rs -s ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms -p ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.png -o ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion_confounds.txt
sed 's:MYINPUT:'${ANALYSISDIR}'/'${MYSUB}'/fmri/rs:g' ${SCRIPTSDIR}/QA_mc_only_${MYCOIL}.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/QA_mc_only_${MYCOIL}.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/QA_mc_only_${MYCOIL}.fsf
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/filtered_func_data -Tstd ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/std_func
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/mean_func -div ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/std_func ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/tsnr_func
rstsnr_mc_only=`fslstats ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/tsnr_func -k ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/mask -M`
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs+.feat/tsnr_func &
if [ "$PURET1" = "YES" ] && [ "$PUREBOLD" = "YES" ]
then
	T1forreg=${ANATDIR}/T1_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs
elif [ "$PURET1" = "NO" ] && [ "$PUREBOLD" = "NO" ]
then
	T1forreg=${ANATDIR}/T1_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs
elif [ "$PURET1" = "YES" ]
then
#need to get non-PURE T1 to reg with BOLD
	#not very efficient, because I potentially convert nonPURE T1 twice (once for fMRI and once for diffusion)
	dcm2niix ${DICOMDIR}/${MYSUB}/*-SAG_FSPGR_BRAVO*
	mv ${DICOMDIR}/${MYSUB}/*-SAG_FSPGR_BRAVO*/*.nii.gz ${ANATDIR}/T1_noPURE.nii.gz
	fslmaths ${ANATDIR}/T1_noPURE -mas ${ANATDIR}/spm_mask ${ANATDIR}/T1_noPURE_brain
	T1forreg=${ANATDIR}/T1_noPURE_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs
elif [ "$PUREBOLD" = "YES" ]
then
#need to get non-PURE BOLD to reg with T1
	dcm2niix ${DICOMDIR}/${MYSUB}/*-rsBOLD*
	mv ${DICOMDIR}/${MYSUB}/*-rsBOLD*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/fmri/rs_noPURE.nii.gz
	T1forreg=${ANATDIR}/T1_brain
	BOLDforreg=${ANALYSISDIR}/${MYSUB}/fmri/rs_noPURE
fi
sed 's:MYINPUT:'${BOLDforreg}':g' ${SCRIPTSDIR}/reg_${MYCOIL}.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/reg_${MYCOIL}.fsf
sed -i "" 's:MYT1:'${T1forreg}':g' ${ANALYSISDIR}/${MYSUB}/fmri/reg_${MYCOIL}.fsf
sed -i "" 's:MYOUTPUT:'${ANALYSISDIR}'/'${MYSUB}'/fmri/rs_reg.feat:g'  ${ANALYSISDIR}/${MYSUB}/fmri/reg_${MYCOIL}.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/reg_${MYCOIL}.fsf
	

################# SUMMARY OUTPUT ########################################
echo $MYSUB,$DATE,$STUDYINFO,$PURET1,na,na,$PUREBOLD,na,na,na,na,$rstsnr,$rstsnr_mc_only,`awk -v max=0 '{if($1>max){ max=$1}}END{print max} ' ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms`,`awk '{ total += $1 } END { print total/NR}' ${ANALYSISDIR}/${MYSUB}/fmri/rs_motion.rms`








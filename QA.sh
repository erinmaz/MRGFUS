#!/bin/bash

#subject ID as input
MYSUB=$1
DICOMDIR=/home/erinmazerolle/MRGFUS/dicoms
ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
SCRIPTSDIR=/home/erinmazerolle/MRGFUS/scripts

mkdir ${ANALYSISDIR}/${MYSUB}
mkdir ${ANALYSISDIR}/${MYSUB}/anat

#################### GET SESSION INFO ##################################
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

dcm2nii ${T1dir}
mv ${T1dir}/o*.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/T1.nii.gz
rm ${T1dir}/*.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/anat/T1.nii.gz &


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

dcm2nii ${T2dir}
mv ${T2dir}/o*.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/T2.nii.gz
rm ${T2dir}/*.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/anat/T2.nii.gz &


#################### SWAN QA ###########################################

#Need to see what these files look like with PURE. MIN IP may not change etc.

dcm2nii ${DICOMDIR}/${MYSUB}/*SWAN*
dcm2nii ${DICOMDIR}/${MYSUB}/*MIN_IP*
mv ${DICOMDIR}/${MYSUB}/*-Ax_SWAN*/o*.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/SWAN_mag.nii.gz
rm ${DICOMDIR}/${MYSUB}/*-Ax_SWAN*/*.nii.gz
mv ${DICOMDIR}/${MYSUB}/*-FILT_PHA_Ax_SWAN*/o*.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/SWAN_phase.nii.gz
rm ${DICOMDIR}/${MYSUB}/*-FILT_PHA_Ax_SWAN*/*.nii.gz
mv ${DICOMDIR}/${MYSUB}/*MIN_IP*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/SWAN_MIN_IP.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/anat/SWAN_mag.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/SWAN_phase.nii.gz &
fsleyes ${ANALYSISDIR}/${MYSUB}/anat/SWAN_MIN_IP.nii.gz &


#################### FLAIR QA ###########################################
dcm2nii ${DICOMDIR}/${MYSUB}/*FLAIR*
mv ${DICOMDIR}/${MYSUB}/*FLAIR*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/anat/flair.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/anat/flair.nii.gz &


#################### Diffusion QA #######################################
mkdir ${ANALYSISDIR}/${MYSUB}/diffusion
dcm2nii ${DICOMDIR}/${MYSUB}/*PUDWI_45*/*
mv ${DICOMDIR}/${MYSUB}/*PUDWI_45*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow.nii.gz
dcm2nii ${DICOMDIR}/${MYSUB}/*PUDWI_PE*/*
mv ${DICOMDIR}/${MYSUB}/*PUDWI_PE*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow.nii.gz &
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev.nii.gz &
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_b0 0 3
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_b0 0 3
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/all_b0 ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_b0 ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_b0
topup --imain=${ANALYSISDIR}/${MYSUB}/diffusion/all_b0 --datain=${SCRIPTSDIR}/acqp.txt --config=b02b0.cnf --out=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --fout=${ANALYSISDIR}/${MYSUB}/diffusion/topup_field --iout=${ANALYSISDIR}/${MYSUB}/diffusion/all_b0_unwarped
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/all_b0_unwarped.nii.gz -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped
bet ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -m
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/data_uncorrected ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev
time eddy_openmp --imain=${ANALYSISDIR}/${MYSUB}/diffusion/data_uncorrected --mask=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask.nii.gz --acqp=${SCRIPTSDIR}/acqp_eddy.txt --index=${SCRIPTSDIR}/index.txt --bvecs=${SCRIPTSDIR}/bvecs --bvals=${SCRIPTSDIR}/bvals --topup=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --out=${ANALYSISDIR}/${MYSUB}/diffusion/data
dtifit -k ${ANALYSISDIR}/${MYSUB}/diffusion/data.nii.gz -o ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit -m ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask.nii.gz -r ${SCRIPTSDIR}/bvecs -b ${SCRIPTSDIR}/bvals
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_V1 &

#diffusion tsnr calc
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow 3 45
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev 51 6
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/dw ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tstd ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean -div ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr
PUdwtsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`


############## fMRI QA ################################################
mkdir ${ANALYSISDIR}/${MYSUB}/fmri
dcm2nii ${DICOMDIR}/${MYSUB}/*PUrsBOLD-/*
mv ${DICOMDIR}/${MYSUB}/*PUrsBOLD-/*.nii.gz ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.nii.gz &
sed 's:MYINPUT:'${ANALYSISDIR}'/'${MYSUB}'/fmri/PUrs.nii.gz:g' ${SCRIPTSDIR}/QA.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/QA.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/QA.fsf
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/filtered_func_data -Tstd ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/std_func
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/filtered_func_data -Tmean ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/mean_func
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/mean_func -div ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/std_func ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/tsnr_func
bet ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/mean_func ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/mean_func_brain -m
PUrstsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/tsnr_func -k ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/mean_func_brain_mask -M`
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/tsnr_func &
fsl_motion_outliers -i ${ANALYSISDIR}/${MYSUB}/fmri/PUrs -s ${ANALYSISDIR}/${MYSUB}/fmri/PUrs_FD.rms -p ${ANALYSISDIR}/${MYSUB}/fmri/PUrs_FD.png --thresh=2 -o ${ANALYSISDIR}/${MYSUB}/fmri/PUrs_FD_confounds.txt
dcm2nii ${DICOMDIR}/${MYSUB}/*-rsBOLD-/*
mv ${DICOMDIR}/${MYSUB}/*rsBOLD-/*.nii.gz ${ANALYSISDIR}/${MYSUB}/fmri/rs.nii.gz
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs.nii.gz &
sed 's:MYINPUT:'${ANALYSISDIR}'/'${MYSUB}'/fmri/rs.nii.gz:g' ${SCRIPTSDIR}/QA_noICA.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/QA_noICA.fsf
feat ${ANALYSISDIR}/${MYSUB}/fmri/QA_noICA.fsf
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data -Tstd ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/std_func
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data -Tmean ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/mean_func
fslmaths ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/mean_func -div ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/std_func ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func
rstsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func -k ${ANALYSISDIR}/${MYSUB}/fmri/PUrs.feat/mean_func_brain_mask -M`
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/tsnr_func &


################# SUMMARY OUTPUT ########################################
echo $MYSUB $STUDYINFO $PURET1 $PURET2 $PUdwtsnr $PUrstsnr $rstsnr `awk -v max=0 '{if($1>max){ max=$1}}END{print max} ' ${ANALYSISDIR}/${MYSUB}/fmri/PUrs_FD.rms` `awk '{ total += $1 } END { print total/NR}' ${ANALYSISDIR}/${MYSUB}/fmri/PUrs_FD.rms`








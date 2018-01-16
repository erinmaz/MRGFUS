#!/bin/bash

#subject ID as input
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
DICOMDIR=${MAINDIR}/dicoms
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts
ANATDIR=${ANALYSISDIR}/${MYSUB}/anat


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
mkdir ${ANALYSISDIR}/${MYSUB}/diffusion_no_repol

mv ${ANALYSISDIR}/${MYSUB}/diffusion/data.* ${ANALYSISDIR}/${MYSUB}/diffusion_no_repol/.
mv ${ANALYSISDIR}/${MYSUB}/diffusion/xfms ${ANALYSISDIR}/${MYSUB}/diffusion_no_repol/.
mv ${ANALYSISDIR}/${MYSUB}/diffusion/dti* ${ANALYSISDIR}/${MYSUB}/diffusion_no_repol/.
mv ${ANALYSISDIR}/${MYSUB}/diffusion/dw* ${ANALYSISDIR}/${MYSUB}/diffusion_no_repol/.
mv ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX ${ANALYSISDIR}/${MYSUB}/diffusion_no_repol.bedpostX
eddy_cpu --imain=${ANALYSISDIR}/${MYSUB}/diffusion/data_uncorrected --mask=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask.nii.gz --acqp=${SCRIPTSDIR}/acqp_eddy.txt --index=${SCRIPTSDIR}/index.txt --bvecs=${SCRIPTSDIR}/bvecs --bvals=${SCRIPTSDIR}/bvals --topup=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --cnr_maps --repol --out=${ANALYSISDIR}/${MYSUB}/diffusion/data

#HERE 

fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/data &
dtifit -k ${ANALYSISDIR}/${MYSUB}/diffusion/data.nii.gz -o ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit -m ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask.nii.gz -r ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_rotated_bvecs -b ${SCRIPTSDIR}/bvals
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_V1 &
#diffusion tsnr calc
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow 3 45
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev 51 6
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/dw ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tstd ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean -div ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr &
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
	T1fordiffreg=${ANATDIR}/T1_noPURE_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain

elif [ "$PUREdiff" = "YES" ]
then
	T1fordiffreg=${ANATDIR}/T1_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif_brain
fi
mkdir ${ANALYSISDIR}/${MYSUB}/diffusion/xfms
flirt -in $diffforreg -ref $T1fordiffreg -omat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio -out ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str 
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str $T1fordiffreg &
convert_xfm -omat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/str2diff.mat -inverse ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str.mat 


################# SUMMARY OUTPUT ########################################
echo $MYSUB,$DATE,$STUDYINFO,UPDATE_DIFFUSION,$difftsnr,$diffcnr


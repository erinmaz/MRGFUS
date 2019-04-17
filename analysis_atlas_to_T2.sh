#!/bin/bash
MYSUB=$1 #pre-treatment
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANATDIR=${MAINDIR}/analysis/${MYSUB}/anat
XFMSDIR=${MAINDIR}/analysis/${MYSUB}/xfms
REGDIR=${MAINDIR}/analysis/${MYSUB}/fmri/rs_reg.feat/reg
mkdir $XFMSDIR

# If 2 T2s were acquired, register and average them.
if [ -e ${MAINDIR}/analysis/${MYSUB}/anat/T2_2.nii.gz ]; then
	bet ${ANATDIR}/T2 ${ANATDIR}/T2_brain -m -f .25 -S
	bet ${ANATDIR}/T2_2 ${ANATDIR}/T2_2_brain -m -f .25 -S
	flirt -in ${ANATDIR}/T2_2 -ref ${ANATDIR}/T2 -out ${ANATDIR}/T2_2_to_T2 -dof 6 -omat ${XFMSDIR}/T2_2_to_T2.mat -nosearch
	fsleyes ${ANATDIR}/T2_2_to_T2 ${ANATDIR}/T2
	fslmaths ${ANATDIR}/T2_2_to_T2 -add ${ANATDIR}/T2 -div 2 ${ANATDIR}/T2_avg
	bet ${ANATDIR}/T2_avg ${ANATDIR}/T2_avg_brain -m -f 0.25 -S

else
	fslmaths ${ANATDIR}/T2 ${ANATDIR}/T2_avg

fi

fslmaths ${ANATDIR}/T2_avg ${XFMSDIR}/T2_avg
bet ${ANATDIR}/T2_avg ${ANATDIR}/T2_avg_brain -m -f 0.25 -S

flirt -in ${ANATDIR}/T1_brain -ref ${ANATDIR}/T2_avg_brain -out ${XFMSDIR}/T1_brain_to_T2_avg_brain -dof 6 -omat ${XFMSDIR}/T1_brain_to_T2_avg_brain.mat

fsleyes ${ANATDIR}/T2_avg_brain ${XFMSDIR}/T1_brain_to_T2_avg_brain

/usr/local/fsl/bin/flirt -in ${ANATDIR}/T1_brain -ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain -out ${XFMSDIR}/T12MNI_1mm -omat ${XFMSDIR}/T12MNI_1mm.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 

/usr/local/fsl/bin/fnirt --in=${ANATDIR}/T1 --aff=${XFMSDIR}/T12MNI_1mm.mat --cout=${XFMSDIR}/T12MNI_1mm_warp --iout=${XFMSDIR}/T12MNI_1mm --jout=${XFMSDIR}/T12MNI_1mm_jac --config=T1_2_MNI152_2mm --ref=/usr/local/fsl/data/standard/MNI152_T1_1mm --refmask=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10

fsleyes ${XFMSDIR}/T12MNI_1mm /usr/local/fsl/data/standard/MNI152_T1_1mm 

invwarp -w ${XFMSDIR}/T12MNI_1mm_warp -o ${XFMSDIR}/MNI_1mm2T1_warp -r ${ANATDIR}/T1 

/usr/local/fsl/bin/applywarp -i ${MAINDIR}/atlases/HistThalAtlas_rois/Vim -r ${ANATDIR}/T2_avg -o ${ANATDIR}/Vim_to_T2_avg -w ${REGDIR}/standard2highres_warp --postmat=${XFMSDIR}/T1_brain_to_T2_avg_brain.mat --interp=nn
 
fsleyes ${ANATDIR}/T2_avg ${ANATDIR}/Vim_to_T2_avg

fslmaths ${ANATDIR}/Vim_to_T2_avg -binv ${ANATDIR}/Vim_to_T2_avg_mask

rangearray=(`fslstats ${ANATDIR}/T2_avg -R`)

fslmaths ${ANATDIR}/Vim_to_T2_avg -mul 2 -mul ${rangearray[1]} ${ANATDIR}/Vim_to_T2_avg_mul

fslmaths ${ANATDIR}/T2_avg -add ${ANATDIR}/Vim_to_T2_avg_mul ${ANATDIR}/T2_avg_Vim_burned_high

fsleyes ${ANATDIR}/T2_avg_Vim_burned_high

fslchfiletype NIFTI ${ANATDIR}/T2_avg_Vim_burned_high

#did this swapdim although I still end up flipping things in matlab. Final output dicom does not appear to be l-r flipped
fslswapdim  ${ANATDIR}/T2_avg_Vim_burned_high.nii z y -x  ${ANATDIR}/T2_avg_Vim_burned_high_swap
fslchfiletype NIFTI ${ANATDIR}/T2_avg_Vim_burned_high_swap
#then ModDCM.m
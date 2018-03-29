#!/bin/bash
MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANATDIR=${MAINDIR}/analysis/${MYSUB}/anat
XFMSDIR=${MAINDIR}/analysis/${MYSUB}/xfms
mkdir $XFMSDIR

bet ${ANATDIR}/T2 ${ANATDIR}/T2_brain -m -f .25 -S

bet ${ANATDIR}/T2_2 ${ANATDIR}/T2_2_brain -m -f .25 -S

flirt -in ${ANATDIR}/T2_2 -ref ${ANATDIR}/T2 -out ${ANATDIR}/T2_2_to_T2_ns -dof 6 -omat ${XFMSDIR}/T2_2_to_T2_ns.mat -nosearch

#flirt -in ${ANATDIR}/T2_2_brain -ref ${ANATDIR}/T2_brain -out ${ANATDIR}/T2_2_brain_to_T2_brain_ns -dof 6 -omat ${XFMSDIR}/T2_2_brain_to_T2_brain_ns.mat -nosearch

fsleyes ${ANATDIR}/T2_2_to_T2_ns  ${ANATDIR}/T2

#the results of this command were basically the same as the non brain extracted versoin
#fsleyes ${ANATDIR}/T2_2_brain_to_T2_brain_ns  ${ANATDIR}/T2_brain

fslmaths ${ANATDIR}/T2_2_to_T2 -add ${ANATDIR}/T2 -div 2 ${ANATDIR}/T2_avg

bet ${ANATDIR}/T2_avg ${ANATDIR}/T2_avg_brain -m -f 0.25 -S

fslmaths ${ANATDIR}/T2_avg ${XFMSDIR}/T2_avg

bet ${ANATDIR}/T2_avg ${ANATDIR}/T2_avg_brain -m -f 0.25 -S

#flirt -in ${ANATDIR}/T1 -ref ${XFMSDIR}/T2_avg -out ${XFMSDIR}/T1_to_T2_avg -dof 6 -omat ${XFMSDIR}/T1_to_T2_avg.mat

flirt -in ${ANATDIR}/T1_brain -ref ${ANATDIR}/T2_avg_brain -out ${XFMSDIR}/T1_brain_to_T2_avg_brain -dof 6 -omat ${XFMSDIR}/T1_brain_to_T2_avg_brain.mat

fsleyes ${XFMSDIR}/T2_avg_brain ${XFMSDIR}/T1_brain_to_T2_avg_brain

/usr/local/fsl/bin/flirt -in ${ANATDIR}/T1_brain -ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain -out ${XFMSDIR}/T12MNI_1mm -omat ${XFMSDIR}/T12MNI_1mm.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 

/usr/local/fsl/bin/fnirt --in=${ANATDIR}/T1 --aff=${XFMSDIR}/T12MNI_1mm.mat --cout=${XFMSDIR}/T12MNI_1mm_warp --iout=${XFMSDIR}/T12MNI_1mm --jout=${XFMSDIR}/T12MNI_1mm_jac --config=T1_2_MNI152_2mm --ref=/usr/local/fsl/data/standard/MNI152_T1_1mm --refmask=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10

fsleyes ${XFMSDIR}/T12MNI_1mm /usr/local/fsl/data/standard/MNI152_T1_1mm 

invwarp -w ${XFMSDIR}/T12MNI_1mm_warp -o ${XFMSDIR}/MNI_1mm2T1_warp -r ${ANATDIR}/T1 

/usr/local/fsl/bin/applywarp -i ${MAINDIR}/atlases/HistThalAtlas_rois/Vim -r ${ANATDIR}/T2_avg -o ${ANATDIR}/Vim_to_T2_avg -w ${XFMSDIR}/MNI_1mm2T1_warp --postmat=${XFMSDIR}/T1_brain_to_T2_avg_brain.mat --interp=nn
 
fsleyes ${ANATDIR}/T2_avg ${ANATDIR}/Vim_to_T2_avg

fslmaths ${ANATDIR}/Vim_to_T2_avg -binv ${ANATDIR}/Vim_to_T2_avg_mask

fslmaths ${ANATDIR}/T2_avg -mas ${ANATDIR}/Vim_to_T2_avg_mask ${ANATDIR}/T2_avg_Vim_burned_low

rangearray=(`fslstats ${ANATDIR}/T2_avg -R`)

#NOT WORKING


fslmaths ${ANATDIR}/Vim_to_T2_avg -mul 2 -mul ${rangearray[1]} ${ANATDIR}/Vim_to_T2_avg_mul

fslmaths ${ANATDIR}/T2_avg -add ${ANATDIR}/Vim_to_T2_avg_mul ${ANATDIR}/T2_avg_Vim_burned_high

fsleyes ${ANATDIR}/T2_avg_Vim_burned_low ${ANATDIR}/T2_avg_Vim_burned_high

fslchfiletype NIFTI ${ANATDIR}/T2_avg_Vim_burned_high
fslchfiletype NIFTI ${ANATDIR}/T2_avg_Vim_burned_low 

#did this swapdim although I still end up flipping things in matlab. Final output dicom does not appear to be l-r flipped
fslswapdim T2_avg_Vim_burned_high.nii z y -x T2_avg_Vim_burned_high_swap

#then todicom.m

#other ideas for nii2dcm:
#Then use plugin in Horos to convert from nii 2 dcm
https://www.researchgate.net/post/How_can_one_convert_Nifti_to_DICOM_for_DTI_images
A plugin in Osirix does the trick: plugin>DataBase>Nifti to Dicom
If you don't have it, you can download the plugin from there: 
http://deqiang.webege.com/software/OsirixPlugins/NiftiToDICOM.html
3 years ago

IF I HAVE PROBLEMS, could also try this:
Rajat M. Thomas
Netherlands Institute for Neuroscience
http://xmedcon.sourceforge.net/Main/Download
Worked quite easily for NIFTI to DICOM conversion
1 Recommendation



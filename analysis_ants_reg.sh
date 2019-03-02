#!/bin/bash
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
INDEX_FILE=${MAINDIR}/scripts/IDs_and_ExamNums.sh
ANALYSISDIR=${MAINDIR}/analysis

#registration target (generously brain extracted MNI152_T1_1mm)
fslmaths ${FSLDIR}/data/standard/MNI152_T1_1mm -mas ${FSLDIR}/data/standard/MNI152_T1_1mm_brain_mask_dil ${ANALYSISDIR}/MNI152_T1_1mm_target

# SETUP
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
pre_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $2}'` 
day1_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $4}'` 

#For all post-treatment exams, get lesion mask into mT1 space and binv
for EXAM in $day1_exam $month3_exam
do
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet
flirt -applyxfm -init ${FSLDIR}/etc/flirtsch/ident.mat -in ${ANALYSISDIR}_lesion_masks/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled -out ${ANALYSISDIR}_lesion_masks/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled2mT1 -ref ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1 -interp nearestneighbour
fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled2mT1 -binv ${ANALYSISDIR}_lesion_masks/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled2mT1_binv
fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled2mT1_binv ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask
done

EXAM=$pre_exam
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet

#brain extract 
for EXAM in $pre_exam $day1_exam $month3_exam
do
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/spm_mask -dilM -eroF ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/spm_mask_smooth
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1 -mas ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/spm_mask_smooth ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain

done
done

# SPECIAL CASES
# setup 9010
#add lesion mask from LST to HIFU lesion mask
for MYSUB in 9010_RR-13536 9010_RR-14700
do

fslmaths ${ANALYSISDIR}/${MYSUB}/anat/ples_lpa_mrflair -add ${ANALYSISDIR}_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled -thr 0.1 -binv ${ANALYSISDIR}/${MYSUB}/anat/xfms/ants/inmask_tmp

flirt -applyxfm -init ${FSLDIR}/etc/flirtsch/ident.mat -in ${ANALYSISDIR}/${MYSUB}/anat/xfms/ants/inmask_tmp -out ${ANALYSISDIR}/${MYSUB}/anat/xfms/ants/inmask -ref ${ANALYSISDIR}/${MYSUB}/anat/mT1 -interp nearestneighbour

fsleyes ${ANALYSISDIR}/${MYSUB}/anat/mT1 ${ANALYSISDIR}/${MYSUB}/anat/xfms/ants/inmask 
done

fslmaths ${ANALYSISDIR}/9010_RR-13130/anat/ples_lpa_mrflair -thr 0.1 -binv ${ANALYSISDIR}/9010_RR-13130/anat/xfms/ants/inmask

#setup 9016
#process manually traced skullprob mask, and get it into pre and month3 space

fslmaths ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man -dilM -dilM -eroF ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man_clean

fslmaths ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man_clean -binv ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man_clean_binv

flirt -in ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man_clean -out ${ANALYSISDIR}/9016_EB-13634/anat/skullprob_man_clean_day1_to_pre -ref ${ANALYSISDIR}/9016_EB-13634/anat/mT1 -applyxfm -init ${ANALYSISDIR}/9016_EB_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat -interp nearestneighbour

fslmaths ${ANALYSISDIR}/9016_EB-13634/anat/skullprob_man_clean_day1_to_pre -binv ${ANALYSISDIR}/9016_EB-13634/anat/skullprob_man_clean_day1_to_pre_binv

convert_xfm -omat ${ANALYSISDIR}/9016_EB_longitudinal_xfms_T1/mT1_brain_day1_2_month3_6dof.mat -concat ${ANALYSISDIR}/9016_EB_longitudinal_xfms_T1/mT1_brain_pre_2_month3_6dof.mat ${ANALYSISDIR}/9016_EB_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat

flirt -in ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man_clean -out ${ANALYSISDIR}/9016_EB-15241/anat/skullprob_man_clean_day1_to_month3 -ref ${ANALYSISDIR}/9016_EB-15241/anat/mT1 -applyxfm -init ${ANALYSISDIR}/9016_EB_longitudinal_xfms_T1/mT1_brain_day1_2_month3_6dof.mat -interp nearestneighbour

fslmaths ${ANALYSISDIR}/9016_EB-15241/anat/skullprob_man_clean_day1_to_month3 -binv ${ANALYSISDIR}/9016_EB-15241/anat/skullprob_man_clean_day1_to_month3_binv

fslmaths ${ANALYSISDIR}/9016_EB-14450/anat/skullprob_man_clean_binv -mas ${ANALYSISDIR}_lesion_masks/9016_EB-14450/anat/T1_lesion_mask_filled2mT1_binv ${ANALYSISDIR}/9016_EB-14450/anat/xfms/ants/inmask

fslmaths ${ANALYSISDIR}/9016_EB-15241/anat/skullprob_man_clean_day1_to_month3_binv -mas ${ANALYSISDIR}_lesion_masks/9016_EB-15241/anat/T1_lesion_mask_filled2mT1_binv ${ANALYSISDIR}/9016_EB-15241/anat/xfms/ants/inmask

fslmaths ${ANALYSISDIR}/9016_EB-13634/anat/skullprob_man_clean_day1_to_pre ${ANALYSISDIR}/9016_EB-13634/anat/xfms/ants/inmask

#setup 9004_EP-12955, who needed a manually edited brain mask
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain_orig
fslmaths ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_brain_man ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain 


# RUN ANTS
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
pre_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $2}'` 
day1_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $4}'`
for EXAM in $pre_exam $day1_exam $month3_exam
do

cd ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet

#setup inmask
if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask.nii.gz ] ; then
INMASK=`echo -x ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask.nii.gz`
else
INMASK=""
fi

antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${ANALYSISDIR}/MNI152_T1_1mm_target.nii.gz,1] --transform Rigid[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${ANALYSISDIR}/MNI152_T1_1mm_target.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${ANALYSISDIR}/MNI152_T1_1mm_target.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz,${ANALYSISDIR}/MNI152_T1_1mm_target.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox ${INMASK}

antsApplyTransforms -d 3 -i ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

fsleyes mT1_2_MNI152_T1_1mm ${FSLDIR}/data/standard/MNI152_T1_1mm &
done
done


#I don't think this worked any better than the un-betted call i made above
MYSUB=9001_SH
EXAM=11692
mkdir ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/quick
/Users/erin/ants/ANTsX-ANTs-2703896/Scripts/antsRegistrationSyNQuick.sh -d 3 -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/mT1_brain.nii.gz -m ${ANALYSISDIR}/MNI152_T1_1mm_target.nii.gz -o ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/quick -x ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask.nii.gz


antsApplyTransforms -d 3 -i ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/quick_mT1_2_MNI152_T1_1mm.nii.gz -t [${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/quick0GenericAffine.mat,1] -t ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet/quick1InverseWarp.nii.gz
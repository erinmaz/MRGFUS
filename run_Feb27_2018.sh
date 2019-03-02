#for new manuscript

#!/bin/bash

analysis_ants_reg.sh

#rerun thalterm tractography using ants to get thalamus into diffusion space
#rerun tbss with inmasks
#rerun lesion heatmaps and CoM calculations

mkdir /Users/erin/Desktop/Projects/MRGFUS/tbss_022719
cp -r /Users/erin/Desktop/Projects/MRGFUS/tbss_022619/origdata/*  /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/.
cd Users/erin/Desktop/Projects/MRGFUS/tbss_022719
tbss_1_preproc *.nii.gz

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
do
pre_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
day1_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 
for exam in $pre_exam $day1_exam $month3_exam
do
#grab everyone's ants inmask if it exists
if [ -f /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/anat/xfms/ants/inmask.nii.gz ] ; then
flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/anat/xfms/ants/inmask -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/diffusion/mean_b0_unwarped -o /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/FA/${MYSUB}-${exam}_FA_FA_inmask -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${exam}/diffusion/xfms/T1_2_diff_bbr.mat -interp nearestneighbour
fi

done
done

tbss_2_reg_inmask.sh -T
tbss_3_postreg -S
tbss_4_prestats 0.2

cd stats 
randomise -i all_FA_skeletonised.nii.gz -o tbss_day1 -m mean_FA_skeleton_mask -d ../models/preday1.mat -t ../models/preday1.con -n 10000 --T2 -e ../models/preday1.grp --uncorrp

mkdir /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/diff_month3_minus_baseline
fslsplit all_FA_skeletonised.nii.gz /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/diff_month3_minus_baseline/FA_skeletonised -t
cd  /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/diff_month3_minus_baseline
fslmaths FA_skeletonised0002 -sub FA_skeletonised0000 9001_SH
fslmaths FA_skeletonised0005 -sub FA_skeletonised0003 9002_RA
fslmaths FA_skeletonised0008 -sub FA_skeletonised0006 9004_EP
fslmaths FA_skeletonised0011 -sub FA_skeletonised0009 9005_BG
fslmaths FA_skeletonised0014 -sub FA_skeletonised0012 9006_EO
fslmaths FA_skeletonised0017 -sub FA_skeletonised0015 9007_RB
fslmaths FA_skeletonised0020 -sub FA_skeletonised0018 9009_CRB
fslmaths FA_skeletonised0023 -sub FA_skeletonised0021 9010_RR
fslmaths FA_skeletonised0026 -sub FA_skeletonised0024 9011_BB
fslmaths FA_skeletonised0029 -sub FA_skeletonised0027 9013_JD
fslmaths FA_skeletonised0032 -sub FA_skeletonised0030 9016_EB
fslmaths FA_skeletonised0035 -sub FA_skeletonised0033 9021_WM
rm *skeletonised* 
fslmerge -t all_skeletonised `ls`

randomise -i all_skeletonised -o tbss_month3_crst -m /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/stats/mean_FA_skeleton_mask -d /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/models/CRST_diff.mat -t /Users/erin/Desktop/Projects/MRGFUS/tbss_022719/models/CRST_diff.con -n 10000 --T2 --uncorrp



flirt -applyxfm -init ${ANALYSISDIR}/9010_RR-13536/diffusion/xfms/diff_2_T1_bbr.mat -in ${ANALYSISDIR}/9010_RR-13536/diffusion/dtifit_FA -ref ${ANALYSISDIR}/9010_RR-13536/anat/mT1 -out ${ANALYSISDIR}/9010_RR-13536/anat/xfms/ants/dtifit_FA2T1_lin

antsApplyTransforms -d 3 -i ${ANALYSISDIR}/9010_RR-13536/anat/xfms/ants/dtifit_FA2T1_lin.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o dtifit_FA_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

#Get a very different FA map - these are different templates. Probably not worth it to redo TBSS with the ANTS results 


#Having a problem where my FNIRTs have been run inconsistently.
# Pretty sure the ones in analysis_lesion_masks have not had any masking
# For the ones in analysis/${MYSUB}/anat/xfms, some are masked and some aren't
# need to check if the mask is a brain mask or also includes lesions etc.
# also need to check that mT1 was used. 
# Go through manually and clean up, delete any that don't see to use the right mask 
# I have only done them correctly for 
#9001_SH-11644/anat/xfms/fnirt_inmask2mT1.nii.gz
#9001_SH-11692/anat/xfms/fnirt_inmask2mT1.nii.gz
#9004_EP-12126/anat/xfms/fnirt_inmask2mT1.nii.gz
#9006_EO-12487/anat/xfms/fnirt_inmask2mT1.nii.gz
#9021_WM-14127/anat/xfms/fnirt_inmask2mT1.nii.gz
#9021_WM-14455/anat/xfms/fnirt_inmask2mT1.nii.gz
#HIFU_ET_C01-14458/anat/xfms/fnirt_inmask2mT1.nii.gz
#HIFU_ET_C02-14709/anat/xfms/fnirt_inmask2mT1.nii.gz
#hifu_et_C03-14983/anat/xfms/fnirt_inmask2mT1.nii.gz
#HIFU_ET_C04-15436/anat/xfms/fnirt_inmask2mT1.nii.gz

MYSUB=9001_SH-12271
analysis_T12MNI_1mm_lesionmask.sh $MYSUB
MYSUB=9004_EP-12203
analysis_T12MNI_1mm_lesionmask.sh $MYSUB
MYSUB=9004_EP-12955
analysis_T12MNI_1mm_lesionmask.sh $MYSUB

MYSUB=9006_EO-12389
analysis_T12MNI_1mm_lesionmask.sh $MYSUB
MYSUB=9006_EO-13017
analysis_T12MNI_1mm_lesionmask.sh $MYSUB
MYSUB=9021_WM-15089
analysis_T12MNI_1mm_lesionmask.sh $MYSUB

for MYSUB in 9002_RA 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB
do
pre_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
day1_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 

analysis_T12MNI_1mm_lesionmask.sh $MYSUB-${pre_exam}
analysis_T12MNI_1mm_lesionmask.sh $MYSUB-${day1_exam}
analysis_T12MNI_1mm_lesionmask.sh $MYSUB-${month3_exam}
done

#trying to fix ants reg

mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/xfms/ants/gm_wm
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat

fslmaths c1T1 -add c2T1 -bin -dilM gm_wm_dilM
fslmaths mT1 -mas gm_wm_dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/xfms/ants/gm_wm/mT1_gm_wm_dilM
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/xfms/ants/gm_wm
ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYSUB=9001_SH
EXAM=11644

antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [mT1_gm_wm_dilM.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1] --transform Rigid[0.1] --metric MI[mT1_gm_wm_dilM.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[mT1_gm_wm_dilM.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[mT1_gm_wm_dilM.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox ${INMASK}

antsApplyTransforms -d 3 -i ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz


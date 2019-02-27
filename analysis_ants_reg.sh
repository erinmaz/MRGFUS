#!/bin/bash
#for day1 and month3 scans for the purpose of STN lesion analysis. Need to add pre scans later (including skull mask for 9016 and lesion mask for 9010)
#Have already run LST on 9010_RR-13536 and 9010_RR-14700
#have already traced extra skull on 9016_EB-14450

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS

#For all subjects, get lesion mask into mT1 space and binv
for MYSUB in 9001_SH-11692 9002_RA-11833 9003_RB-12064 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9010_RR-13536 9011_BB-14148 9013_JD-13722 9016_EB-14450 9021_WM-14455 9001_SH-12271 9002_RA-12388 9003_RB-12669 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-12910 9009_CRB-13623 9010_RR-14700 9011_BB-14878 9013_JD-14227 9016_EB-15241 9021_WM-15089 
do
mkdir ${MAINDIR}/analysis/${MYSUB}/anat/xfms
mkdir ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants
flirt -applyxfm -init ${FSLDIR}/etc/flirtsch/ident.mat -in ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled -out ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1 -ref ${MAINDIR}/analysis/${MYSUB}/anat/mT1 -interp nearestneighbour
fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1 -binv ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1_binv
fslmaths ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1_binv ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/inmask
done

# do 9010
for MYSUB in 9010_RR-13536 9010_RR-14700
do

fslmaths ${MAINDIR}/analysis/${MYSUB}/anat/ples_lpa_mrflair -add ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled -thr 0.1 -binv ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/inmask_tmp

flirt -applyxfm -init ${FSLDIR}/etc/flirtsch/ident.mat -in ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/inmask_tmp -out ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/inmask -ref ${MAINDIR}/analysis/${MYSUB}/anat/mT1 -interp nearestneighbour

fsleyes ${MAINDIR}/analysis/${MYSUB}/anat/mT1 ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants/inmask 
done


#do 9016
mkdir ${MAINDIR}/analysis/9016_EB_longitudinal_xfms_T1/ants
cd ${MAINDIR}/analysis/9016_EB_longitudinal_xfms_T1/ants
fslmaths ${MAINDIR}/analysis_lesion_masks/9016_EB-14450/anat/T1_lesion_mask_filled2mT1 ${MAINDIR}/analysis/9016_EB_longitudinal_xfms_T1/ants/day1_inmask

antsRegistration --dimensionality 3 --float 0 --output [day12pre,day12pre_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${MAINDIR}/analysis/9016_EB-13634/anat/mT1.nii.gz,${MAINDIR}/analysis/9016_EB-14450/anat/mT1.nii.gz,1] --transform Rigid[0.1] --metric MI[${MAINDIR}/analysis/9016_EB-13634/anat/mT1.nii.gz,${MAINDIR}/analysis/9016_EB-14450/anat/mT1.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${MAINDIR}/analysis/9016_EB-13634/anat/mT1.nii.gz,${MAINDIR}/analysis/9016_EB-14450/anat/mT1.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${MAINDIR}/analysis/9016_EB-13634/anat/mT1.nii.gz,${MAINDIR}/analysis/9016_EB-14450/anat/mT1.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox -x day1_inmask.nii.gz 

antsApplyTransforms -d 3 -i ${MAINDIR}/analysis/9016_EB-14450/anat/mT1.nii.gz -r ${MAINDIR}/analysis/9016_EB-13634/anat/mT1.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [day12pre0GenericAffine.mat,1] -t day12pre1InverseWarp.nii.gz


fslmaths ${MAINDIR}/analysis/9016_EB-14450/anat/skullprob_man -fillh ${MAINDIR}/analysis/9016_EB-14450/anat/skullprob_man_fillh

fslmaths ${MAINDIR}/analysis/9016_EB-14450/anat/skullprob_man_fillh -add ${MAINDIR}/analysis_lesion_masks/9016_EB-14450/anat/T1_lesion_mask_filled -binv ${MAINDIR}/analysis/9016_EB-14450/anat/xfms/ants/inmask_tmp

flirt -applyxfm -init ${FSLDIR}/etc/flirtsch/ident.mat -in ${MAINDIR}/analysis/9016_EB-14450/anat/xfms/ants/inmask_tmp -out ${MAINDIR}/analysis/9016_EB-14450/anat/xfms/ants/inmask -ref ${MAINDIR}/analysis/9016_EB-14450/anat/mT1 -interp nearestneighbour

fsleyes ${MAINDIR}/analysis/9016_EB-14450/anat/mT1 ${MAINDIR}/analysis/9016_EB-14450/anat/xfms/ants/inmask  

################ IS THIS RIGHT? I HAVEN"T USE D A WARP!!!!!!
#probably makes sense to use ANTS to create intra-subject warp anyway

#applywarp -i ${MAINDIR}/analysis/9016_EB-14450/anat/skullprob_man_fillh -r ${MAINDIR}/analysis/9016_EB-15241/anat/mT1 -o ${MAINDIR}/analysis/9016_EB-15241/anat/skullprob_man_fillh_day1_to_month3 --interp=trilinear 





antsApplyTransforms -d 3 -i ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz




fslmaths ${MAINDIR}/analysis/9016_EB-15241/anat/skullprob_man_fillh_day1_to_month3 -add ${MAINDIR}/analysis_lesion_masks/9016_EB-15241/anat/T1_lesion_mask_filled -thr 0.5 -binv ${MAINDIR}/analysis/9016_EB-15241/anat/xfms/ants/inmask 

fsleyes ${MAINDIR}/analysis/9016_EB-15241/anat/mT1 ${MAINDIR}/analysis/9016_EB-15241/anat/xfms/ants/inmask  

applywarp -i ${MAINDIR}/analysis/9016_EB-14450/anat/skullprob_man_fillh -r ${MAINDIR}/analysis/9016_EB-13634/anat/mT1 -o ${MAINDIR}/analysis/9016_EB-13634/anat/skullprob_man_fillh_day1_to_pre --interp=trilinear 
mkdir ${MAINDIR}/analysis/9016_EB-13634/anat/xfms/ants
fslmaths ${MAINDIR}/analysis/9016_EB-13634/anat/skullprob_man_fillh_day1_to_pre -thr 0.5 -binv ${MAINDIR}/analysis/9016_EB-13634/anat/xfms/ants/inmask 

#now run ants for everyone
for MYSUB in 9003_RB-12064 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9010_RR-13536 9011_BB-14148   

do

cd ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants

antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1] --transform Rigid[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox -x inmask.nii.gz 

antsApplyTransforms -d 3 -i ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

antsApplyTransforms -d 3 -i ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_mask_filled2mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm mT1_2_MNI152_T1_1mm T1_lesion_mask_filled2mT1_2_MNI152_T1_1mm &
done

#these ones finished I think
#9006_EO-13017 9007_RB-12910 9009_CRB-13623

for MYSUB in 9010_RR-14700 9011_BB-14878 9013_JD-14227 9016_EB-15241 9021_WM-15089  9013_JD-13722 9016_EB-14450 9021_WM-14455 9001_SH-12271 9002_RA-12388 9003_RB-12669 9004_EP-12955 9005_BG-13837
do

cd ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants
if [ ! -f ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz ]; then
fslchfiletype NIFTI_GZ ${MAINDIR}/analysis/${MYSUB}/anat/mT1
fi
antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1] --transform Rigid[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox -x inmask.nii.gz 

antsApplyTransforms -d 3 -i ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

#going to need to rerun this with nn interp, or check what the defa
antsApplyTransforms -d 3 -i ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_mask_filled2mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm mT1_2_MNI152_T1_1mm T1_lesion_mask_filled2mT1_2_MNI152_T1_1mm &
done

#fix - too much shoulder in image?
MYSUB=9004_EP-12955
cd ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants
fslmaths ${MAINDIR}/analysis/${MYSUB}/anat/mT1 ${MAINDIR}/analysis/${MYSUB}/anat/mT1_orig
fslmaths ${MAINDIR}/analysis/${MYSUB}/anat/mT1 -roi 0 -1 0 -1 55 -1 0 1 ${MAINDIR}/analysis/${MYSUB}/anat/mT1 

antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1] --transform Rigid[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox -x inmask.nii.gz 

antsApplyTransforms -d 3 -i ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

#going to need to rerun this with nn interp, or check what the defa
antsApplyTransforms -d 3 -i ${MAINDIR}/analysis_lesion_masks/${MYSUB}/anat/T1_lesion_mask_filled2mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_mask_filled2mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz

fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm mT1_2_MNI152_T1_1mm T1_lesion_mask_filled2mT1_2_MNI152_T1_1mm &
#Better but still off, try with brain masks

#do for pre-treatment scans
#no lesions, only need to mask 9016 and 9010
#run LST for 9010, reg skullprob to pre for 9016 NOT DONE YT
9010_RR-13130
9016_EB-13634 


for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609  9011_BB-13042 9013_JD-13455 9021_WM-14127 
do
mkdir ${MAINDIR}/analysis/${MYSUB}/anat/xfms
mkdir ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants

cd ${MAINDIR}/analysis/${MYSUB}/anat/xfms/ants
if [ ! -f ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz ]; then
fslchfiletype NIFTI_GZ ${MAINDIR}/analysis/${MYSUB}/anat/mT1
fi
antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1,MNI_1mm_2_mT1_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995]  --use-histogram-matching 0 --initial-moving-transform [${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1] --transform Rigid[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1  --smoothing-sigmas 3x2x1x0vox -x inmask.nii.gz 

antsApplyTransforms -d 3 -i ${MAINDIR}/analysis/${MYSUB}/anat/mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o mT1_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz



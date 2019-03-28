MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
LESIONDIR=${MAINDIR}/analysis_lesion_masks
ANALYSISDIR=${MAINDIR}/analysis
INDEX_FILE=${MAINDIR}/scripts/IDs_and_ExamNums.sh

#for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 
#do
#EXAM=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` #day1
#fslswapdim ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled -x y z #${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled_swap
#fslswapdim ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1 -x y z ${MAINDIR}/analysis/${MYSUB}-${EXAM}/anat/mT1_swap

#if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask.nii.gz ] ; then
#fslswapdim ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask -x y z ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask_swap
#fi

#done

#do 9010 and 9016 separately
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9011_BB 9013_JD 9021_WM 
do
EXAM=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` #day1
PREEXAM=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $2}'` #pre
cd ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/bet
#mkdir swap
cd swap

#SETUP INMASK
#if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask_swap.nii.gz ] ; then
#INMASK=`echo -x ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask_swap.nii.gz`
#else
#INMASK=""
#fi

#antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1_swap,MNI_1mm_2_mT1_swap_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995] --use-histogram-matching 0 --initial-moving-transform [${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1] --transform Rigid[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox ${INMASK} 

#fsleyes MNI_1mm_2_mT1_swap_Warped ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap &

#antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled_swap.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_swap_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT1_swap0GenericAffine.mat,1] -t MNI_1mm_2_mT1_swap1InverseWarp.nii.gz -n Linear
#fslmaths T1_lesion_filled_mask_swap_2_MNI152_T1_1mm -thr 0.5 -bin T1_lesion_filled_mask_swap_2_MNI152_T1_1mm

#fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm T1_lesion_filled_mask_swap_2_MNI152_T1_1mm ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled2MNI_1mm &

antsApplyTransforms -d 3 -i T1_lesion_filled_mask_swap_2_MNI152_T1_1mm.nii.gz -r ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/mT1.nii.gz -o ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/day1_lesion_swap_MNI_2_pre.nii.gz -t  ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/xfms/ants/bet/MNI_1mm_2_mT10GenericAffine.mat -t ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/xfms/ants/bet/MNI_1mm_2_mT11Warp.nii.gz -n Linear

fsleyes ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/mT1.nii.gz ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/day1_lesion_swap_MNI_2_pre 

done


 

for MYSUB in 9010_RR 9016_EB
do
EXAM=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` #day1
PREEXAM=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $2}'` #pre
cd ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants
#mkdir swap
cd swap

#SETUP INMASK
#if [ -f ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask_swap.nii.gz ] ; then
#INMASK=`echo -x ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/xfms/ants/inmask_swap.nii.gz`
#else
#INMASK=""
#fi

#antsRegistration --dimensionality 3 --float 0 --output [MNI_1mm_2_mT1_swap,MNI_1mm_2_mT1_swap_Warped.nii.gz] --interpolation Linear  --winsorize-image-intensities [0.005,0.995] --use-histogram-matching 0 --initial-moving-transform [${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1] --transform Rigid[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform Affine[0.1] --metric MI[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,32,Regular,0.25] --convergence [1000x500x250x100,1e-6,10]  --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox --transform SyN[0.1,3,0] --metric CC[${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap.nii.gz,${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz,1,4] --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox ${INMASK} 

#fsleyes MNI_1mm_2_mT1_swap_Warped ${ANALYSISDIR}/${MYSUB}-${EXAM}/anat/mT1_swap &

#antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled_swap.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_swap_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT1_swap0GenericAffine.mat,1] -t MNI_1mm_2_mT1_swap1InverseWarp.nii.gz -n Linear
#fslmaths T1_lesion_filled_mask_swap_2_MNI152_T1_1mm -thr 0.5 -bin T1_lesion_filled_mask_swap_2_MNI152_T1_1mm

#fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm T1_lesion_filled_mask_swap_2_MNI152_T1_1mm ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled2MNI_1mm &

antsApplyTransforms -d 3 -i T1_lesion_filled_mask_swap_2_MNI152_T1_1mm.nii.gz -r ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/mT1.nii.gz -o ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/day1_lesion_swap_MNI_2_pre.nii.gz -t  ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/xfms/ants/MNI_1mm_2_mT10GenericAffine.mat -t ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/xfms/ants/MNI_1mm_2_mT11Warp.nii.gz -n Linear

fsleyes ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/mT1.nii.gz ${ANALYSISDIR}/${MYSUB}-${PREEXAM}/anat/day1_lesion_swap_MNI_2_pre 

done



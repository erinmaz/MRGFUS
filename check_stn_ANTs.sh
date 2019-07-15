MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/STN
#LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
INDEX_FILE=${MAINDIR}/scripts/IDs_and_ExamNums.sh
#fslmaths ${ROIDIR}/stn_prob_L -thr 25 -bin ${ROIDIR}/stn_prob_L_thr25_bin
#fslmaths ${ROIDIR}/stn_prob_R -thr 25 -bin ${ROIDIR}/stn_prob_R_thr25_bin
#fslmaths ${ROIDIR}/stn_prob_L_thr25_bin -add ${ROIDIR}/stn_prob_R_thr25_bin ${ROIDIR}/stn_prob_thr25_bilat
#flirt -applyxfm -init  ${FSLDIR}/etc/flirtsch/ident.mat -in ${ROIDIR}/stn_prob_thr25_bilat -out ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -ref ${FSLDIR}/data/standard/MNI152_T1_1mm -interp nearestneighbour
#fslmaths ${ROIDIR}/stn_prob_L -thr 10 -bin ${ROIDIR}/stn_prob_L_thr10_bin
#fslmaths ${ROIDIR}/stn_prob_R -thr 10 -bin ${ROIDIR}/stn_prob_R_thr10_bin
#fslmaths ${ROIDIR}/stn_prob_L_thr10_bin -add ${ROIDIR}/stn_prob_R_thr10_bin ${ROIDIR}/stn_prob_thr10_bilat
#flirt -applyxfm -init  ${FSLDIR}/etc/flirtsch/ident.mat -in ${ROIDIR}/stn_prob_thr10_bilat -out ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -ref ${FSLDIR}/data/standard/MNI152_T1_1mm -interp nearestneighbour

#do 9010 and 9016 separately
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9009_CRB 9011_BB 9013_JD 9019_TB 9021_WM 9023_WS

do

day1_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $4}'`
for EXAM in $day1_exam $month3_exam

do

cd ${MAINDIR}/analysis/${MYSUB}-${EXAM}/anat/xfms/ants/bet
if [ -f ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2mT1.nii.gz ]; then
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2mT1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz -n Linear
else
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz -n Linear
fi
fslmaths T1_lesion_filled_mask_2_MNI152_T1_1mm -thr 0.5 -bin T1_lesion_filled_mask_2_MNI152_T1_1mm

hist=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/histthal_label_subthalamicnucleus.nii.gz -V | awk '{print $2}'`
stnprob25=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -V | awk '{print $2}'`
stnprob10=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -V | awk '{print $2}'`
echo ${MYSUB}-${EXAM} hist $hist stnprob25 $stnprob25 stnprob10 $stnprob10

done

done

MYSUB=9007_RB #has only 1 voxel at month 3, use a lower threshold to binarize
day1_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $4}'`

cd ${MAINDIR}/analysis/${MYSUB}-${day1_exam}/anat/xfms/ants/bet
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${day1_exam}/anat/T1_lesion_zonesIandII.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz -n Linear
fslmaths T1_lesion_filled_mask_2_MNI152_T1_1mm -thr 0.5 -bin T1_lesion_filled_mask_2_MNI152_T1_1mm

hist=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/histthal_label_subthalamicnucleus.nii.gz -V | awk '{print $2}'`
stnprob25=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -V | awk '{print $2}'`
stnprob10=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -V | awk '{print $2}'`
echo ${MYSUB}-${day1_exam} hist $hist stnprob25 $stnprob25 stnprob10 $stnprob10

cd ${MAINDIR}/analysis/${MYSUB}-${month3_exam}/anat/xfms/ants/bet
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${month3_exam}/anat/T1_lesion_mask_filled.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz -n Linear
fslmaths T1_lesion_filled_mask_2_MNI152_T1_1mm -thr 0.3 -bin T1_lesion_filled_mask_2_MNI152_T1_1mm
hist=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/histthal_label_subthalamicnucleus.nii.gz -V | awk '{print $2}'`
stnprob25=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -V | awk '{print $2}'`
stnprob10=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -V | awk '{print $2}'`
echo ${MYSUB}-${month3_exam} hist $hist stnprob25 $stnprob25 stnprob10 $stnprob10

for MYSUB in 9010_RR 9016_EB
do
day1_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $3}'` 
month3_exam=`sed -n '/'${MYSUB}'/p' ${INDEX_FILE} | awk '{print $4}'`
for EXAM in $day1_exam $month3_exam

do

cd ${MAINDIR}/analysis/${MYSUB}-${EXAM}/anat/xfms/ants
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_mask_filled.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_mT10GenericAffine.mat,1] -t MNI_1mm_2_mT11InverseWarp.nii.gz -n Linear
fslmaths T1_lesion_filled_mask_2_MNI152_T1_1mm -thr 0.5 -bin T1_lesion_filled_mask_2_MNI152_T1_1mm
hist=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/histthal_label_subthalamicnucleus.nii.gz -V | awk '{print $2}'`
stnprob25=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -V | awk '{print $2}'`
stnprob10=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -V | awk '{print $2}'`
echo ${MYSUB}-${EXAM} hist $hist stnprob25 $stnprob25 stnprob10 $stnprob10

done

done



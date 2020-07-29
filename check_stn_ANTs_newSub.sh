MYSUB=$1
day1_exam=$2
month3_exam=$3

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/STN
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis

#fslmaths ${ROIDIR}/stn_prob_L -thr 25 -bin ${ROIDIR}/stn_prob_L_thr25_bin
#fslmaths ${ROIDIR}/stn_prob_R -thr 25 -bin ${ROIDIR}/stn_prob_R_thr25_bin
#fslmaths ${ROIDIR}/stn_prob_L_thr25_bin -add ${ROIDIR}/stn_prob_R_thr25_bin ${ROIDIR}/stn_prob_thr25_bilat
#flirt -applyxfm -init  ${FSLDIR}/etc/flirtsch/ident.mat -in ${ROIDIR}/stn_prob_thr25_bilat -out ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -ref ${FSLDIR}/data/standard/MNI152_T1_1mm -interp nearestneighbour
#fslmaths ${ROIDIR}/stn_prob_L -thr 10 -bin ${ROIDIR}/stn_prob_L_thr10_bin
#fslmaths ${ROIDIR}/stn_prob_R -thr 10 -bin ${ROIDIR}/stn_prob_R_thr10_bin
#fslmaths ${ROIDIR}/stn_prob_L_thr10_bin -add ${ROIDIR}/stn_prob_R_thr10_bin ${ROIDIR}/stn_prob_thr10_bilat
#flirt -applyxfm -init  ${FSLDIR}/etc/flirtsch/ident.mat -in ${ROIDIR}/stn_prob_thr10_bilat -out ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -ref ${FSLDIR}/data/standard/MNI152_T1_1mm -interp nearestneighbour


for EXAM in $day1_exam $month3_exam

do

cd ${MAINDIR}/analysis/${MYSUB}-${EXAM}/anat/xfms/ants/bet
if [ -f ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2T1.nii.gz ]; then
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII2T1.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_T10GenericAffine.mat,1] -t MNI_1mm_2_T11InverseWarp.nii.gz -n Linear
else
antsApplyTransforms -d 3 -i ${LESIONDIR}/${MYSUB}-${EXAM}/anat/T1_lesion_zonesIandII.nii.gz -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -o T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz -t [MNI_1mm_2_T10GenericAffine.mat,1] -t MNI_1mm_2_T11InverseWarp.nii.gz -n Linear
fi
fslmaths T1_lesion_filled_mask_2_MNI152_T1_1mm -thr 0.5 -bin T1_lesion_filled_mask_2_MNI152_T1_1mm

hist=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/histthal_label_subthalamicnucleus.nii.gz -V | awk '{print $2}'`
stnprob25=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr25_bilat_2_1mm -V | awk '{print $2}'`
stnprob10=`fslstats T1_lesion_filled_mask_2_MNI152_T1_1mm -k ${ROIDIR}/stn_prob_thr10_bilat_2_1mm -V | awk '{print $2}'`
echo ${MYSUB}-${EXAM} hist $hist stnprob25 $stnprob25 stnprob10 $stnprob10

done




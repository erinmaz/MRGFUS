MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ROIDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/STN

fslmaths ${ROIDIR}/stn_prob_L -thr 25 -bin ${ROIDIR}/stn_prob_L_thr25_bin
fslmaths ${ROIDIR}/stn_prob_R -thr 25 -bin ${ROIDIR}/stn_prob_R_thr25_bin
fslmaths ${ROIDIR}/stn_prob_L_thr25_bin -add ${ROIDIR}/stn_prob_R_thr25_bin ${ROIDIR}/stn_prob_thr25_bilat

fslmaths ${ROIDIR}/stn_prob_L -thr 10 -bin ${ROIDIR}/stn_prob_L_thr10_bin
fslmaths ${ROIDIR}/stn_prob_R -thr 10 -bin ${ROIDIR}/stn_prob_R_thr10_bin
fslmaths ${ROIDIR}/stn_prob_L_thr10_bin -add ${ROIDIR}/stn_prob_R_thr10_bin ${ROIDIR}/stn_prob_thr10_bilat

#do 9010 and 9016 separately
DAY1_SCANS=( 9001_SH-11692 9002_RA-11833 9003_RB-12064 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9011_BB-14148 9013_JD-13722 9021_WM-14455 )

MONTH3_SCANS=( 9001_SH-12271 9002_RA-12388 9003_RB-12669 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-12910 9009_CRB-13623 9011_BB-14878 9013_JD-14227 9021_WM-15089 )

#analysis_step2_T12MNI_1mm_inmask.sh 9016_EB-14450 /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9016_EB-14450/xfms_inmask/inmask

#convertwarp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-15241/anat/T1.nii.gz --warp1=/Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB_longitudinal_xfms_T1/day1_to_pre_warp.nii.gz --warp2=/Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB_longitudinal_xfms_T1/pre_to_month3_warp.nii.gz -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB_longitudinal_xfms_T1/day_to_month3_warp

#applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-14450/anat/skullprob_man_filled_binv.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-15241/anat/T1.nii.gz -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-15241/anat/skullprob_man_filled_binv_day1_to_month3 --interp=trilinear 
#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-15241/anat/skullprob_man_filled_binv_day1_to_month3 -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-15241/anat/skullprob_man_filled_binv_day1_to_month3

#mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9016_EB-15241/xfms_inmask
#fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9016_EB-15241/anat/skullprob_man_filled_binv_day1_to_month3 -sub /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9016_EB-15241/anat/T1_lesion_mask_filled /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9016_EB-15241/xfms_inmask/inmask

#analysis_step2_T12MNI_1mm_inmask.sh 9016_EB-15241 /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9016_EB-15241/xfms_inmask/inmask




for f in ${DAY1_SCANS[@]} ${MONTH3_SCANS[@]}
do
mkdir ${MAINDIR}/analysis_lesion_masks/${f}/xfms_inmask
fslmaths ${MAINDIR}/analysis_lesion_masks/${f}/T1_lesion_mask_filled -binv ${MAINDIR}/analysis_lesion_masks/${f}/T1_lesion_mask_filled_binv
analysis_step2_T12MNI_1mm_inmask.sh $f ${MAINDIR}/analysis_lesion_masks/${f}/T1_lesion_mask_filled_binv &

done
wait

#MAKE SURE THE CORRECT LESION GETS COMPARED
for f in ${DAY1_SCANS[@]}
do 
echo -n $f " "
hist=`awk '{print $2}' fslstats ${MAINDIR}/analysis_lesion_masks/$f/anat/T1_lesion_mask_filled2MNI_1mm -k ${ROIDIR}/histthal_label_subthalamicnucleus.nii.gz -V`
stnprob=`awk '{print $2}' fslstats ${MAINDIR}/analysis_lesion_masks/$f/anat/T1_lesion_mask_filled2MNI_1mm -k ${ROIDIR}/stn_prob_bilat -V`
echo $hist $stnprob
done



for f in ${MONTH3_SCANS[@]}
do 
echo -n $f " "
fslstats ${MAINDIR}/analysis_lesion_masks/$f/anat/T1_lesion_mask_filled2MNI_1mm -k ${MAINDIR}/histthal_label_subthalamicnucleus.nii.gz -V
done
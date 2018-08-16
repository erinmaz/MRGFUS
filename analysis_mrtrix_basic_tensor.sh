#!/bin/bash

MYSUB=$1
TREATMENTSIDE=$2
OTHERSIDE=$3
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix

mv ${WORKDIR} ${WORKDIR}_160818
mkdir ${WORKDIR}

applywarp -w ${ANALYSISDIR}/${MYSUB}/fmri/rs_reg.feat/reg/standard2highres_warp --postmat=${DIFFDIR}/xfms/T1_2_diff_bbr.mat -i ${SCRIPTSDIR}/rois_standardspace/cerebrum_${OTHERSIDE}_MNI2mm -o ${WORKDIR}/cerebrum_${OTHERSIDE}_MNI2mm --interp=nn -r ${DIFFDIR}/nodif_brain_mask

applywarp -w ${ANALYSISDIR}/${MYSUB}/fmri/rs_reg.feat/reg/standard2highres_warp --postmat=${DIFFDIR}/xfms/T1_2_diff_bbr.mat -i ${SCRIPTSDIR}/rois_standardspace/harvardoxford-subcortical_prob_Brain-Stem_clean_binv -o ${WORKDIR}/harvardoxford-subcortical_prob_Brain-Stem_clean_binv --interp=nn -r ${DIFFDIR}/nodif_brain_mask

fslmaths ${DIFFDIR}/rois_tracking_atlasROIs_300718/csf -add ${WORKDIR}/cerebrum_${OTHERSIDE}_MNI2mm -bin -mas ${WORKDIR}/harvardoxford-subcortical_prob_Brain-Stem_clean_binv ${WORKDIR}/exclude

tckgen -algorithm TENSOR_DET -seed_image ${DIFFDIR}/rois_tracking_atlasROIs_300718/harvardoxford-cortical_prob_Precentral+Juxtapositional_${TREATMENTSIDE}.nii.gz -include ${DIFFDIR}/rois_tracking_atlasROIs_300718/RN_standard_1mm_${TREATMENTSIDE}_dilM.nii.gz -exclude ${WORKDIR}/exclude.nii.gz -fslgrad ${DIFFDIR}/data.eddy_rotated_bvecs ${DIFFDIR}/bvals ${DIFFDIR}/data.nii.gz ${WORKDIR}/rtt_from_cortex.tck

tckedit -exclude ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck
tckedit -include ${DIFFDIR}/rois_tracking_day1_lesion_150518/tracking_day1_lesion_150518.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_include_lesion.tck

tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.tck ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz
tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz 

if [ -e ${DIFFDIR}/mrtrix_old_version/mrtrix_basic_tensor_det_exclude/manual_exclude.nii.gz ]; then
  fsleyes ${DIFFDIR}/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz  ${DIFFDIR}/mrtrix_old_version/mrtrix_basic_tensor_det_exclude/manual_exclude
  
else
  fsleyes ${DIFFDIR}/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz 
fi

#check again if manual exclude exists, I may have just made it if the tracking is different
if [ -e ${WORKDIR}/manual_exclude.nii.gz ]; then
  tckedit -exclude ${WORKDIR}/manual_exclude.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.tck ${WORKDIR}/rtt_from_cortex_include_lesion_clean.tck -force
  tckedit -exclude ${WORKDIR}/manual_exclude.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.tck -force

  tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion_clean.tck ${WORKDIR}/rtt_from_cortex_include_lesion_clean.nii.gz -force
  tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.nii.gz -force

  fsleyes ${DIFFDIR}/mean_b0_unwarped ${WORKDIR}/rtt_from_cortex_include_lesion_clean.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.nii.gz

else
  cp ${WORKDIR}/rtt_from_cortex_include_lesion.tck ${WORKDIR}/rtt_from_cortex_include_lesion_clean.tck 
  cp ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.tck 
  cp ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion_clean.nii.gz 
  cp ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.nii.gz 
fi

INC_FILE=${WORKDIR}/rtt_from_cortex_include_lesion_clean.nii.gz
EXC_FILE=${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.nii.gz
fslmaths ${EXC_FILE} -mas ${INC_FILE} ${WORKDIR}/rtt_from_cortex_overlap.nii.gz

inc_les=`fslstats ${INC_FILE} -V`
exc_les=`fslstats ${EXC_FILE} -V`
overlap=`fslstats  ${WORKDIR}/rtt_from_cortex_overlap.nii.gz -V`

fslmaths ${WORKDIR}/rtt_from_cortex_overlap -binv ${WORKDIR}/rtt_from_cortex_overlap_binv
fslmaths ${INC_FILE} -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap
fslmaths ${EXC_FILE} -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap

echo $MYSUB $inc_les $exc_les $overlap >> ${ANALYSISDIR}/mrtrix_inc_exc_overlap.txt


#!/bin/bash

TBSSDIR=/Users/erin/Desktop/Projects/MRGFUS/tbss_160718
MYSUB=$1
MYSUB_DAY1=$2
TREATMENTSIDE=$3
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion
WORKDIR=${DIFFDIR}/mrtrix
THALAMUS_WAYPOINT=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical/thalamus_${TREATMENTSIDE}_final
CEREBELLUM_MASK=${SCRIPTSDIR}/rois_standardspace/mni_prob_Cerebellum_thr10_binv_1mm
#also want to add combined tract in 
if [ -e ${WORKDIR}_160818/manual_exclude.nii.gz ]; then
 tckedit -exclude ${WORKDIR}/manual_exclude.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_clean.tck -force
else
 cp ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_clean.tck
fi
tckmap -template ${DIFFDIR}/nodif_brain_mask.nii.gz ${WORKDIR}/rtt_from_cortex_clean.tck ${WORKDIR}/rtt_from_cortex_clean.nii.gz -force
 
for tract in ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_clean
 do
 #zero out bottom 5 slices in case we tracked very inferiorly - FA maps do not all extend to the bottom most slice 
 fslmaths ${tract} -bin -roi 0 -1 0 -1 5 -1 0 1 ${tract}_bin
 
 #transform to standard space for use with TBSS images

 applywarp -i ${tract}_bin -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm -w ${TBSSDIR}/FA/${MYSUB}_FA_FA_to_target_warp -o ${tract}_bin2standard --interp=nn

 #fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm ${tract}_bin2standard ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm

 fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -binv ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_binv

 fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -dilM ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours

 fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours -sub ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_neighbours

 fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours -binv ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_dilM_and_neighbours_binv

 fslmaths ${tract}_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_binv ${tract}_bin2standard_nolesion

 fslmaths ${tract}_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_neighbours ${tract}_bin2standard_nolesion_neighbours

 fslmaths ${tract}_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_dilM_and_neighbours_binv ${tract}_bin2standard_nolesion_orneighbours

 LESION_COG=`fslstats ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -C`
coords=( $LESION_COG )

 fslmaths ${tract}_bin2standard_nolesion_orneighbours -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${tract}_bin2standard_nolesion_orneighbours_superior

 fslmaths ${tract}_bin2standard_nolesion_orneighbours -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${tract}_bin2standard_nolesion_orneighbours_inferior

 applywarp -i ${THALAMUS_WAYPOINT} -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm --premat=/Users/erin/Desktop/Projects/MRGFUS/scripts/ident.mat -o ${THALAMUS_WAYPOINT}_1mm --interp=nn

 fslmaths ${THALAMUS_WAYPOINT}_1mm -binv ${THALAMUS_WAYPOINT}_1mm_binv

 fslmaths ${tract}_bin2standard_nolesion_orneighbours_superior -mas ${THALAMUS_WAYPOINT}_1mm ${tract}_bin2standard_nolesion_orneighbours_superior_thalamus_only

 fslmaths ${tract}_bin2standard_nolesion_orneighbours_inferior -mas ${THALAMUS_WAYPOINT}_1mm ${tract}_bin2standard_nolesion_orneighbours_inferior_thalamus_only

 fslmaths ${tract}_bin2standard_nolesion_orneighbours_superior -mas ${THALAMUS_WAYPOINT}_1mm_binv ${tract}_bin2standard_nolesion_orneighbours_superior_nothalamus

 fslmaths ${tract}_bin2standard_nolesion_orneighbours_inferior -mas ${THALAMUS_WAYPOINT}_1mm_binv ${tract}_bin2standard_nolesion_orneighbours_inferior_nothalamus
 
 fslmaths ${tract}_bin2standard_nolesion_orneighbours_inferior -mas ${CEREBELLUM_MASK} ${tract}_bin2standard_nolesion_orneighbours_inferior_nocerebellum

# fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm ${tract}_bin2standard ${tract}_bin2standard_nolesion ${tract}_bin2standard_nolesion_orneighbours  ${tract}_bin2standard_nolesion_orneighbours_superior ${tract}_bin2standard_nolesion_orneighbours_inferior ${tract}_bin2standard_nolesion_orneighbours_superior_nothalamus ${tract}_bin2standard_nolesion_orneighbours_inferior_nothalamus ${tract}_bin2standard_nolesion_orneighbours_superior_thalamus_only ${tract}_bin2standard_nolesion_orneighbours_inferior_thalamus_only ${tract}_bin2standard_nolesion_orneighbours_inferior_nocerebellum
done


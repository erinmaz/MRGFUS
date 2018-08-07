#!/bin/bash

# Run this once we have the day1 T1 lesion traced. This does the tractography from the day1 seed in pre space, which we transform to standard space and use as an ROI for all timepoints

# PREVIOUSLY NEED TO HAVE RUN:
# analysis_diffusion_step1A_bedpostX.sh for pre timepoint
# analysis_step1_T1_lesion_trace.sh for day 1 (because it will be input as seed)
# analysis_longitudinal_step1.sh 

# Input 1: subject ID (e.g., 9001_SH)
# Input 2: exam # of pre scan (tracking done on this scan)
# Input 3: exam # of day 1 scan
# Input 4: Tract output prefix (e.g., day1_T1_lesion_analysisdate)
# Input 5: Treatment side (R or L)
# Input 6: TBSS directory for registration
# Input 7: Day1 T1 lesion in pre diff space 

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

MYSUB=$1
MYSUB_TOTRACK=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}
TRACT_OUTPUT=$4
TREATMENTSIDE=$5
TBSSDIR=${MAINDIR}/${6} #for reg
LESION=$7

if [ ! $TREATMENTSIDE = "R" ]; then 
	OTHERSIDE=R
else OTHERSIDE=L
fi
	
mkdir ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}

MYSEED=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/SUIT/dentate_${OTHERSIDE}_1mm
MYSEED_NAME=`basename $MYSEED` 

RED_WAYPOINT=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/Keuken/RN_standard_1mm_${TREATMENTSIDE}
RED_WAYPOINT_NAME=`basename ${RED_WAYPOINT}`
 
CORTEX_WAYPOINT=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Precentral+Juxtapositional_${TREATMENTSIDE}
CORTEX_WAYPOINT_NAME=`basename ${CORTEX_WAYPOINT}` 

CEREBELLUM_EXCLUDE=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_${TREATMENTSIDE}
CEREBELLUM_EXCLUDE_NAME=`basename ${CEREBELLUM_EXCLUDE}`

THALAMUS=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical/thalamus_${TREATMENTSIDE}_final
THALAMUS_NAME=`basename ${THALAMUS}`  

#check that this warp exists and if not generate it
if [ ! -f ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv.nii.gz ]; then
  invwarp -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp -o ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain
fi

applywarp -i ${MYSEED} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} --interp=nn

applywarp -i ${RED_WAYPOINT} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${RED_WAYPOINT_NAME} --interp=nn

applywarp -i ${CORTEX_WAYPOINT} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CORTEX_WAYPOINT_NAME} --interp=nn

applywarp -i ${THALAMUS} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${THALAMUS_NAME} --interp=nn


# threshold CSF mask 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1 -thr .99 ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1.99

#without nn interp, the CSF mask is too big
applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1.99 --interp=nn --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/csf

applywarp -i ${SCRIPTSDIR}/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/midsag_plane_CC_MNI152_T1_2mm2diff -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain


applywarp -i ${CEREBELLUM_EXCLUDE} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CEREBELLUM_EXCLUDE_NAME} --interp=nn

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/midsag_plane_CC_MNI152_T1_2mm2diff -dilM -add ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/csf -add ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CEREBELLUM_EXCLUDE_NAME} -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude -add ${LESION} -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude_plus_lesion

################# run PROBTRACK

#first with lesion as a waypoint
rm -rf ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint
mkdir -p ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint

echo ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${RED_WAYPOINT_NAME} > ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint/waypoints.txt

echo ${LESION} > ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint/waypoints.txt

echo ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CORTEX_WAYPOINT_NAME} >> ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint/waypoints.txt

/usr/local/fsl/bin/probtrackx2 -x ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} -l --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 20000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint --waypoints=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_waypoint/waypoints.txt  --waycond=AND

#second with lesion in exclusion mask
rm -rf ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_exclude
mkdir -p ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_exclude

echo ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${RED_WAYPOINT_NAME} > ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_exclude/waypoints.txt

echo ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CORTEX_WAYPOINT_NAME} >> ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_exclude/waypoints.txt

/usr/local/fsl/bin/probtrackx2 -x ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} -l --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 20000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude_plus_lesion --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_exclude --waypoints=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}_lesion_exclude/waypoints.txt  --waycond=AND

#################

for TRACT in ${TRACT_OUTPUT}_lesion_waypoint ${TRACT_OUTPUT}_lesion_exclude
do

waytotal=`more ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm

#zero out bottom 5 slices in case we tracked very inferiorly - FA maps do not all extend to the bottom most slice 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm -thr 0.01 -bin -roi 0 -1 0 -1 5 -1 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin

#transform to standard space for use with TBSS images

applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp -o  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard --interp=nn

fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -binv ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_binv

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -dilM ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours -sub ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_neighbours

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours -binv ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_dilM_and_neighbours_binv

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_neighbours ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_neighbours

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_dilM_and_neighbours_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours

LESION_COG=`fslstats ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -C`
coords=( $LESION_COG )

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior

applywarp -i ${THALAMUS} -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm --premat=/Users/erin/Desktop/Projects/MRGFUS/scripts/ident.mat -o ${THALAMUS}_1mm --interp=nn

fslmaths ${THALAMUS}_1mm -binv ${THALAMUS}_1mm_binv

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior -mas ${THALAMUS}_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_thalamus_only

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior -mas ${THALAMUS}_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_thalamus_only

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior -mas ${THALAMUS}_1mm_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_nothalamus

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior  -mas ${THALAMUS}_1mm_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_nothalamus

fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_thalamus_only ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_thalamus_only
done

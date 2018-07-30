#!/bin/bash

# Run this once we have the day1 T1 lesion traced. This does the tractography from the day1 seed in pre space, which we transform to standard space and use as an ROI for all timepoints

# PREVIOUSLY NEED TO HAVE RUN:
# analysis_diffusion_step1A_bedpostX.sh for pre timepoint
# analysis_step1_T1_lesion_trace.sh for day 1 (because it will be input as seed)
# analysis_longitudinal_step1.sh 

# Input 1: subject ID (e.g., 9001_SH)
# Input 2: exam # of scan to track in (i.e., pre)
# Input 3: exam # of seed (i.e., day 1)
# Input 4: Tract output prefix (e.g., day1_T1_lesion_analysisdate)
# Input 5: Treatment side (R or L)

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

MYSUB=$1
MYSUB_TOTRACK=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}
TRACT_OUTPUT=$4
TREATMENTSIDE=$5
TBSSDIR=${MAINDIR}/${6} #for reg

if [ ! $TREATMENTSIDE = "R" ]; then 
	OTHERSIDE=R
else OTHERSIDE=L
fi
	
mkdir ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}

MYSEED=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Precentral+Juxtapositional_${TREATMENTSIDE}

THALAMUS_WAYPOINT=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-subcortical/thalamus_${TREATMENTSIDE}_final
 
CEREBELLUM_WAYPOINT=/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_Cerebellum_thr10_${OTHERSIDE}
 
MYSEED_NAME=`basename $MYSEED` 

#check that this warp exists and if not generate it
if [ ! -f ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv.nii.gz ]; then
invwarp -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp -o ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain
fi

applywarp -i ${MYSEED} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} --interp=spline
 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} -thr 0.25 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} 

THALAMUS_WAYPOINT_NAME=`basename ${THALAMUS_WAYPOINT}`  

applywarp -i ${THALAMUS_WAYPOINT} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${THALAMUS_WAYPOINT_NAME} --interp=spline
 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${THALAMUS_WAYPOINT_NAME} -thr 0.25 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${THALAMUS_WAYPOINT_NAME} 

CEREBELLUM_WAYPOINT_NAME=`basename ${CEREBELLUM_WAYPOINT}`  

applywarp -i ${CEREBELLUM_WAYPOINT} -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain.nii.gz -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CEREBELLUM_WAYPOINT_NAME} --interp=spline
 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CEREBELLUM_WAYPOINT_NAME} -thr 0.25 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CEREBELLUM_WAYPOINT_NAME} 

# threshold CSF mask 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1 -thr .99 ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1.99

#without nn interp, the CSF mask is too big
applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1.99 --interp=nn --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/csf

applywarp -i ${SCRIPTSDIR}/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp_inv -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/midsag_plane_CC_MNI152_T1_2mm2diff -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/midsag_plane_CC_MNI152_T1_2mm2diff -dilM -add ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/csf -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude

################# run PROBTRACK

rm -rf ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}
mkdir -p ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}

echo ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${THALAMUS_WAYPOINT_NAME} > ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/waypoints.txt

echo ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${CEREBELLUM_WAYPOINT_NAME} >> ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/waypoints.txt

/usr/local/fsl/bin/probtrackx2 -x ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${MYSEED_NAME} -l --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=10.0 --sampvox=0.0 --avoid=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT} --waypoints=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/waypoints.txt  --waycond=AND


#################

waytotal=`more ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm

#zero out bottom 5 slices in case we tracked very inferiorly - FA maps do not all extend to the bottom most slice 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm -thr 0.01 -bin -roi 0 -1 0 -1 5 -1 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin

#transform to standard space for use with TBSS images

applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp -o  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard --interp=nn

fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -binv ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_binv

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -dilM ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours -sub ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_neighbours

fslmaths ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_and_neighbours -binv ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_dilM_and_neighbours_binv

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_neighbours ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_neighbours

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard -mas ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_dilM_and_neighbours_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours

LESION_COG=`fslstats ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -C`
coords=( $LESION_COG )

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior

applywarp -i ${THALAMUS_WAYPOINT} -r /usr/local/fsl/data/standard/FMRIB58_FA_1mm --premat=/Users/erin/Desktop/Projects/MRGFUS/scripts/ident.mat -o ${THALAMUS_WAYPOINT}_1mm --interp=nn

fslmaths ${THALAMUS_WAYPOINT}_1mm -binv ${THALAMUS_WAYPOINT}_1mm_binv

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior -mas ${THALAMUS_WAYPOINT}_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_thalamus_only

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior -mas ${THALAMUS_WAYPOINT}_1mm ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_thalamus_only

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior -mas ${THALAMUS_WAYPOINT}_1mm_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_nothalamus

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior  -mas ${THALAMUS_WAYPOINT}_1mm_binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_nothalamus

fsleyes /usr/local/fsl/data/standard/MNI152_T1_1mm  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_superior_thalamus_only ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard_nolesion_orneighbours_inferior_thalamus_only
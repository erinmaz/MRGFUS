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

if [ ! $TREATMENTSIDE = "R" ]; then 
	OTHERSIDE=R
else OTHERSIDE=L
fi
	
mkdir ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}

MYSEED=${MAINDIR}/analysis_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled
MYXFM=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr.mat 

applywarp -i $MYSEED -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain --postmat=${MYXFM} --interp=nn -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}

# get contralateral equivalent of lesion for tracking in untreated hemisphere
 
applywarp -i $MYSEED -r ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/standard -w ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/highres2standard_warp -o ${MYSEED}2standard --interp=nn

fslswapdim ${MYSEED}2standard -x y z ${MYSEED}2standard_contralateral

applywarp -i ${MYSEED}2standard_contralateral -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain -w ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/standard2highres_warp -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}_contralateral --postmat=${MYXFM} --interp=nn

# threshold CSF mask 
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1 -thr .99 ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1.99

#without nn interp, the CSF mask is too big
applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/anat/c3T1.99 --interp=nn --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/csf

#check that this warp exists and if not generate it
if [ ! -f ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz ]; then
invwarp -w ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/highres2standard_warp -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/highres
fi

applywarp -i ${SCRIPTSDIR}/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -w ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/midsag_plane_CC_MNI152_T1_2mm2diff -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/midsag_plane_CC_MNI152_T1_2mm2diff -dilM -add ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/csf -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude

applywarp -i ${SCRIPTSDIR}/rois_standardspace/harvardoxford-subcortical/thalamus_${TREATMENTSIDE}_final -w ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${TREATMENTSIDE}_final --interp=nn  -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${TREATMENTSIDE}_final -binv  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${TREATMENTSIDE}_final_inv

applywarp -i ${SCRIPTSDIR}/rois_standardspace/harvardoxford-subcortical/thalamus_${OTHERSIDE}_final -w ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${OTHERSIDE}_final --interp=nn  -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${OTHERSIDE}_final -binv  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${OTHERSIDE}_final_inv


sides=( $TREATMENTSIDE $OTHERSIDE )
sidei=0

for theseed in ${TRACT_OUTPUT} ${TRACT_OUTPUT}_contralateral
do

################# run PROBTRACK
rm -rf ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}
mkdir -p ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}

/usr/local/fsl/bin/probtrackx2  -x ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed} -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=10.0 --sampvox=0.0 --avoid=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/exclude --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB_TOTRACK}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB_TOTRACK}/diffusion.bedpostX/nodif_brain_mask --dir=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}

#################

waytotal=`more ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm -thr 0.01 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin -sub ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed} -thr 0.5 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${sides[$sidei]}_final  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_thalamus

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${sides[$sidei]}_final_inv  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_nothalamus

#get centre of gravity of lesion, so that I can determine portion of tract inferior and superior to it.
LESION_COG=`fslstats ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT} -C`
coords=( $LESION_COG )

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${sides[$sidei]}_final  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_thalamus

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${sides[$sidei]}_final  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_thalamus

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${sides[$sidei]}_final_inv  ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_nothalamus

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/thalamus_${sides[$sidei]}_final_inv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_nothalamus

#ring around lesion, to check if all the effects in the thalamus are due to neighbouring voxels, which might be explained by reg error/PVEs
fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed} -dilM -sub ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed} ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels 

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels -binv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels_inv

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_thalamus -mas ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels_inv ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_orneighbours_thalamus

fsleyes ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_thalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_thalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_thalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_orneighbours_thalamus &

let sidei=${sidei}+1
done





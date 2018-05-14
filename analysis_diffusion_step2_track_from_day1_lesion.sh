#!/bin/bash

# Run this once we have the day1 T1 lesion traced. This does the tractography from the day1 seed in pre space, which we transform to standard space and use as an ROI for all timepoints

# PREVIOUSLY NEED TO HAVE RUN:
# analysis_diffusion_step1A_bedpostX.sh for input
# analysis_diffusion_step1B_run_tbss_preproc
# analysis_step1_T1_lesion_trace.sh for day 1 (because it will be input as seed)
# analysis_longitudinal_step1.sh for pre tracking
# analysis_longitudinal_step2.sh for 3M tracking (probably not doing this though)

# Input 1: subject ID (e.g., 9001_SH)
# Input 2: exam # of scan to track in
# Input 3: exam # of seed (i.e., day 1)
# Input 4: full path of seed
# Input 5: output prefix (i.e., day1_T1_lesion)
# Input 6: seed2diff linear transform, likely generated in analysis_longitudinal_step1.sh at least for tracking the day1 seed in pre space
# Input 8: standard2diff?
# Input 7: tbss directory

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

MYSUB=$1
MYSUB_TOTRACK=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}
MYSEED=`imglob $4`
TRACT_OUTPUT=$5
MYXFM=$6
#TBSSDIR=$7

mkdir ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois

applywarp -i $MYSEED -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain --postmat=${MYXFM} --interp=nn -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois/${TRACT_OUTPUT}


################# USE THIS INSTEAD OF COMMAND BELOW
rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=10.0 --sampvox=0.0 --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC_bin.nii.gz --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC

###################

/usr/local/fsl/bin/probtrackx2  -x ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois/${TRACT_OUTPUT} -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=10.0 --sampvox=0.0 --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT} 

waytotal=`more ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm -thr 0.01 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin -sub ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois/${TRACT_OUTPUT} -thr 0.5 ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin_nolesion

fsleyes ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin_nolesion

# we will probably wait to run the TBSS until after the 3M data have been collected, so leave this out of this script.

#mkdir ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/${TRACT_OUTPUT}

#applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin -o ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin_to_target -r ${FSLDIR}/data/standard/FMRIB58_FA_1mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp --interp=nn

#applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois/${TRACT_OUTPUT} -o ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/${TRACT_OUTPUT}/seed_to_target -r ${FSLDIR}/data/standard/FMRIB58_FA_1mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp --interp=nn

#fsleyes ${FSLDIR}/data/standard/FMRIB58_FA_1mm ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_pre_to_target ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/${TRACT_OUTPUT}/seed_to_target
#!/bin/bash

# get T1 Day1 lesion in pre diff space and track
# Input 1: subject ID (e.g., 9001_SH)
# Input 2: exam # of pre scan
# Input 3: exam # of day1 scan
# Input 4: full path of mask in day1 T1 space

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#subject IDs as input
MYSUB=$1

#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
#cp $0 ${ANALYSISDIR}/${MYSUB}/.

MYSUB_PRE=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}

#full path of mask (in day1 T1 space)
MYMASK=`imglob $4`

TRACT_OUTPUT=day1_T1_lesion
T1_DAY1_2_DIFF_PRE_MAT=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr_6dof.mat
T1_2_DIFF_PRE_MAT=${ANALYSISDIR}/${MYSUB_PRE}/diffusion/xfms/T1_2_diff_bbr.mat
T1_DAY1_2_PRE_MAT=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_pre_6dof.mat 

convert_xfm -omat ${T1_DAY1_2_DIFF_PRE_MAT} -concat ${T1_2_DIFF_PRE_MAT} ${T1_DAY1_2_PRE_MAT} 

mkdir ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois

flirt -applyxfm -init ${T1_DAY1_2_DIFF_PRE_MAT} -in $MYMASK -ref ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/nodif_brain -interp nearestneighbour -out ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois/${TRACT_OUTPUT}

#defaults from GUI
/usr/local/fsl/bin/probtrackx2  -x ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois/${TRACT_OUTPUT} -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/merged -m ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/nodif_brain_mask  --dir=${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT} 

waytotal=`more ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm

fslmaths ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm -thr 0.01 -bin ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin

fslmaths ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin -sub ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois/${TRACT_OUTPUT} -thr 0.5 ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin_nolesion

fsleyes ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin_nolesion

mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion

applywarp -i  ${ANALYSISDIR}/${MYSUB_PRE}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin_nolesion -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/${MYSUB_PRE}_FA_FA_to_target_warp --interp=nn

fsleyes $FSLDIR/data/standard/FMRIB58_FA_1mm /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target

#tbss images generated in Feb8_2018_run_tbss_preproc.sh
for f in `ls -d ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/tbss_images/*`
do
echo -n $f " "
fslstats $f -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target -M
done


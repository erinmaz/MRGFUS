#!/bin/bash
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

MYSUB=$1
MYSUB_TOTRACK=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}
TRACT_OUTPUT=$4

overlap=`fslstats ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/fdt_paths_norm_thr0.01_bin2standard -k ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -V`
lesion=`fslstats ${ANALYSISDIR}_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -V`

echo $MYSUB $overlap $lesion
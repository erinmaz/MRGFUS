#!/bin/bash

#I think this is essentially working for 9001_SH. Need to carefully check for pts with lesion on other side.  need to think about making the ROIs less scanty (I think I am losing some voxels to rounding, although perhaps that's good because it prevents overlap?)

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
MYDIR=${MAINDIR}/${1}-${2} #pre
DAY1=${MAINDIR}/${1}-${3}
DAY1_LESION=${LESIONDIR}/${1}-${3}
#mark SCP decus on all patients
#save as ${MYDIR}/diffusion/Kwon_ROIs/SCP_decus

fsleyes ${MYDIR}/diffusion/dtifit_FA ${MYDIR}/diffusion/dtifit_V1 ${MYDIR}/diffusion/Kwon_ROIs/dentate_L_dil_thalterm/fdt_paths

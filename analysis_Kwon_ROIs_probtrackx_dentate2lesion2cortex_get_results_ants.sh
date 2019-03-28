#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
MYDIR=${MAINDIR}/${1}-${2} #pre
DAY1=${MAINDIR}/${1}-${3}
DAY1_LESION=${LESIONDIR}/${1}-${3}
OUTFILE=${4}

xcoord_lesion_standard=`fslstats ${DAY1_LESION}/anat/T1_lesion_mask_filled2MNI_1mm -c | awk '{print $1}'`

vol_d2s=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_dentate2SCP_decusT1_bin -V | awk '{print $2}'`

vol_s2l=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_SCP_decus2lesion2T1_bin -V | awk '{print $2}'`

vol_thal=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_thalamus_nolesion_sup2T1_bin -V | awk '{print $2}'`

vol_sup2thal=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_sup_to_thal_nolesion2T1_bin -V | awk '{print $2}'`
echo $1 >> ${OUTFILE}_d2s
echo $1 >> ${OUTFILE}_s2l
echo $1 >> ${OUTFILE}_thal
echo $1 >> ${OUTFILE}_sup2thal

echo $vol_d2s >> ${OUTFILE}_d2s
echo $vol_s2l >> ${OUTFILE}_s2l
echo $vol_thal >> ${OUTFILE}_thal
echo $vol_sup2thal >> ${OUTFILE}_sup2thal

for measure in FA L1 MD RD
do
for TP in TP1 TP2 TP3 
do
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_dentate2SCP_decusT1_bin -M >> ${OUTFILE}_d2s
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_SCP_decus2lesion2T1_bin -M >> ${OUTFILE}_s2l
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_thalamus_nolesion_sup2T1_bin -M >> ${OUTFILE}_thal
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate2lesion2cortex/fdt_paths_sup_to_thal_nolesion2T1_bin -M >> ${OUTFILE}_sup2thal

done
done



#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYDIR=${MAINDIR}/${1}-${2} #pre
DAY1=${MAINDIR}/${1}-${3}
DAY1_LESION=${LESIONDIR}/${1}-${3}
OUTFILE=${4}

if [ -f ${DAY1_LESION}/anat/xfms/ants/bet/T1_lesion_filled_mask2T1_2_MNI152_T1_1mm.nii.gz ]; then
MYLESION=${DAY1_LESION}/anat/xfms/ants/bet/T1_lesion_filled_mask2T1_2_MNI152_T1_1mm
elif [ -f ${DAY1_LESION}/anat/xfms/ants/bet/T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz ]; then
MYLESION=${DAY1_LESION}/anat/xfms/ants/bet/T1_lesion_filled_mask_2_MNI152_T1_1mm
elif [ -f ${DAY1_LESION}/anat/xfms/ants/T1_lesion_filled_mask2T1_2_MNI152_T1_1mm.nii.gz ]; then
MYLESION=${DAY1_LESION}/anat/xfms/ants/T1_lesion_filled_mask2T1_2_MNI152_T1_1mm
else
MYLESION=${DAY1_LESION}/anat/xfms/ants/T1_lesion_filled_mask_2_MNI152_T1_1mm
fi

xcoord_lesion_standard=`fslstats $MYLESION -c | awk '{print $1}'`
echo $xcoord_lesion_standard
if [ $(bc -l <<< "$xcoord_lesion_standard < 0") -eq 1 ]; then 
TREATED_DENTATE=R
UNTREATED_DENTATE=L
else
TREATED_DENTATE=L
UNTREATED_DENTATE=R
fi
side=$TREATED_DENTATE

echo $1 >> ${OUTFILE}_${side}_d2s
echo $1 >> ${OUTFILE}_${side}_s2l

vol_d2s=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${side}_dil_thalterm/fdt_paths_dentate2SCP_decusT1_bin -V | awk '{print $2}'`

vol_s2l=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${side}_dil_thalterm/fdt_paths_SCP_decus2lesion2T1_bin -V | awk '{print $2}'`

echo $vol_d2s >> ${OUTFILE}_${side}_d2s
echo $vol_s2l >> ${OUTFILE}_${side}_s2l

for measure in FA L1 MD RD
do
for TP in TP1 TP2 TP3 
do
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${side}_dil_thalterm/fdt_paths_dentate2SCP_decusT1_bin -M >> ${OUTFILE}_${side}_d2s
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${side}_dil_thalterm/fdt_paths_SCP_decus2lesion2T1_bin -M >> ${OUTFILE}_${side}_s2l
done
done



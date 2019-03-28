#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
MYDIR=${MAINDIR}/${1}-${2} #pre
DAY1=${MAINDIR}/${1}-${3}
DAY1_LESION=${LESIONDIR}/${1}-${3}
OUTFILE=${4}

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/harvardoxford-subcortical_thalamus_L_final_1mm2diff -add ${MYDIR}/diffusion/Kwon_ROIs_ants/harvardoxford-subcortical_thalamus_R_final_1mm2diff ${MYDIR}/diffusion/Kwon_ROIs_ants/harvardoxford-subcortical_thalamus_bilat_diff

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/harvardoxford-subcortical_thalamus_bilat_diff -binv ${MYDIR}/diffusion/Kwon_ROIs_ants/outside_thalamus

echo $1 >> ${OUTFILE}_withinthal
echo $1 >> ${OUTFILE}_outsidethal

waytotal=`more ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/waytotal`
thr=`bc -l <<< "$waytotal / 20"`
fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths -thr $thr -bin -mas ${MYDIR}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin_and_neighbours_binv ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin -mas ${MYDIR}/diffusion/Kwon_ROIs_ants/harvardoxford-subcortical_thalamus_bilat_diff ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin_withinthal

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin -mas ${MYDIR}/diffusion/Kwon_ROIs_ants/outside_thalamus ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin_outsidethal

for roi in fdt_paths_thr_bin_outsidethal fdt_paths_thr_bin_withinthal
do
flirt -applyxfm -init ${MYDIR}/diffusion/xfms/diff_2_T1_bbr.mat -in ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/${roi} -out ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/${roi}2T1 -ref ${MYDIR}/anat/mT1 
fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/${roi}2T1 -thr 0.5 -bin ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/${roi}2T1_bin
done

vol_withinthal=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin_withinthal2T1_bin -V | awk '{print $2}'`
vol_outsidethal=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin_outsidethal2T1_bin -V | awk '{print $2}'`

echo $vol_withinthal >> ${OUTFILE}_withinthal
echo $vol_outsidethal >> ${OUTFILE}_outsidethal

for measure in FA L1 MD RD
do
for TP in TP1 TP2 TP3 
do
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin_withinthal2T1_bin -M >> ${OUTFILE}_withinthal
fslstats ${MAINDIR}/${1}_diffusion_longitudinal/dti_in_pre_T1_space_220219/${measure}_${TP} -k ${MYDIR}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil/fdt_paths_thr_bin_outsidethal2T1_bin -M >> ${OUTFILE}_outsidethal
done
done



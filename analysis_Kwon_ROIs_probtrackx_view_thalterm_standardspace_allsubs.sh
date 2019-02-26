#!/bin/bash

string_L=""
string_R=""
for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 

#HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436

do
outdir_dentate_R=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_thalterm
outdir_dentate_L=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_thalterm

for tract in ${outdir_dentate_R}/fdt_paths ${outdir_dentate_L}/fdt_paths
do
applywarp -i ${tract} -r ${FSLDIR}/data/standard/MNI152_T1_1mm -o ${tract}2standard -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp --premat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/diff_2_T1_bbr.mat --interp=nn
done

string_L=`echo $string_L ${outdir_dentate_L}/fdt_paths2standard -add`
string_R=`echo $string_R ${outdir_dentate_R}/fdt_paths2standard -add`
done

string_L_final=${string_L%????}
string_R_final=${string_R%????}

fslmaths $string_L_final /Users/erin/Desktop/Projects/MRGFUS/analysis/Kwon_ROIs_dentate_L_dil_thalterm_fdt_paths_sum_all_patients
fslmaths $string_R_final /Users/erin/Desktop/Projects/MRGFUS/analysis/Kwon_ROIs_dentate_R_dil_thalterm_fdt_paths_sum_all_patients

fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm  /Users/erin/Desktop/Projects/MRGFUS/analysis/Kwon_ROIs_dentate_L_dil_thalterm_fdt_paths_sum_all_patients -cm "Red-Yellow" /Users/erin/Desktop/Projects/MRGFUS/analysis/Kwon_ROIs_dentate_R_dil_thalterm_fdt_paths_sum_all_patients -cm "Blue-Lightblue"
#!/bin/bash

for f in `ls -d /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/*ring*.nii.gz`
do
ringnum=`echo $f | rev | cut -c8-12 | rev`
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target -mas $f /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_${ringnum}
done
#tbss images generated in Feb8_2018_run_tbss_preproc.sh
for f in `ls -d ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/tbss_images/*`
do
for g in for f in `ls -d /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring*
do
echo -n $f $g " "
fslstats $f -k $g -M
done
done

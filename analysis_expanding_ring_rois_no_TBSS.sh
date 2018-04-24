#!/bin/bash
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#subject IDs as input
MYSUB=$1
MYSUB_PRE=${MYSUB}-${2}
SEED=day1_T1_lesion
OUTFILE=$3

applywarp -i  ${ANALYSISDIR}/${MYSUB_PRE}/diffusion/rois/${SEED} -o ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/${MYSUB_PRE}_FA_FA_to_target_warp --interp=nn

i=1
fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target -kernel sphere 10 -dilM ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_sphere${i}

fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_sphere${i} -sub ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_ring${i}
fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_ring${i} -mas  ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}

mystring=`echo ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}`

for i in `seq 2 9`
do
let "j = $i - 1"
fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_sphere${j} -kernel sphere 10 -dilM ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_sphere${i}

fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_sphere${i} -sub ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_sphere${j} ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_ring${i}


fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target_ring${i} -mas  ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}
mystring=`echo $mystring ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}`

done

fsleyes $mystring

#next: extract FA
#for i in `seq 1 10`
#do
#for f in `ls -d ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/tbss_images/*`
#do
#fslstats $f -k ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i} -M
#done
#done

#extract FA only for portion of ROI that is superior to z coordinate of COG of the lesion mask
myimages=""
LESION_COG=`fslstats ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/${SEED}_to_pre_to_target -C`
coords=( $LESION_COG )

for i in `seq 1 9`
do
#for lesions on the left
fslmaths ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i} -roi ${coords[0]} -1 0 -1 ${coords[2]} -1 0 1  ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}_superior_left
myimages=`echo $myimages ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}_superior_left`
for f in `ls -d ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/tbss_images/*`
do 
echo -n $f ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}_superior_left " " >> $OUTFILE
fslstats $f -k ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_thr0.01_bin_nolesion_pre_to_target_ring${i}_superior_left -M -V >> $OUTFILE
done
done
fsleyes $myimages 


#!/bin/bash

#I think this is essentially working for 9001_SH. Need to carefully check for pts with lesion on other TREATED_DENTATE.  need to think about making the ROIs less scanty (I think I am losing some voxels to rounding, although perhaps that's good because it prevents overlap?)

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
#LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
LESIONDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYDIR=${MAINDIR}/${1}-${2} #pre
DAY1=${MAINDIR}/${1}-${3}
DAY1_LESION=${LESIONDIR}/${1}-${3}

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

if [ $(bc -l <<< "$xcoord_lesion_standard < 0") -eq 1 ]; then 
TREATED_DENTATE=R
UNTREATED_DENTATE=L
else
TREATED_DENTATE=L
UNTREATED_DENTATE=R
fi

LESION_AND_NEIGHBOURS_BINV=${MYDIR}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin_and_neighbours_binv

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths -bin -mas ${LESION_AND_NEIGHBOURS_BINV} ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_lesionterm/fdt_paths -binv ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_lesionterm/fdt_paths_binv

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion -mas ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_lesionterm/fdt_paths_binv ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated

#fsleyes ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_lesionterm/fdt_paths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated

treated_dentate_coords=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil -C`
treated_dentate_x=`echo $treated_dentate_coords | awk '{print $1}'`
treated_dentate_y=`echo $treated_dentate_coords | awk '{print $2}'`
treated_dentate_z=`echo $treated_dentate_coords | awk '{print $3}'`

decus_coords=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/SCP_decus -C`
decus_x=`echo $decus_coords | awk '{print $1}'`
decus_y=`echo $decus_coords | awk '{print $2}'`
decus_z=`echo $decus_coords | awk '{print $3}'`

diffx=`echo $decus_x - $treated_dentate_x | bc`
diffx=`echo ${diffx#-}` #abs value
diffy=`echo $decus_y - $treated_dentate_y | bc`
diffz=`echo $decus_z - $treated_dentate_z | bc`

lesion_coords=`fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -C`

lesion_x=`echo $lesion_coords | awk '{print $1}'`
lesion_y=`echo $lesion_coords | awk '{print $2}'`
lesion_z=`echo $lesion_coords | awk '{print $3}'`

diff2x=`echo $lesion_x - $decus_x | bc`
diff2x=`echo ${diff2x#-}` #abs value
diff2y=`echo $lesion_y - $decus_y | bc`
diff2z=`echo $lesion_z - $decus_z | bc`

if [ $TREATED_DENTATE = "R" ]; then
fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated -roi ${treated_dentate_x} ${diffx} ${treated_dentate_y} ${diffy} ${treated_dentate_z} ${diffz} 0 1 ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated -roi ${decus_x} ${diff2x} ${decus_y} ${diff2y} ${decus_z} ${diff2z} 0 1 ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion
else
fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated -roi ${decus_x} ${diffx} ${treated_dentate_y} ${diffy} ${treated_dentate_z} ${diffz} 0 1 ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated -roi ${lesion_x} ${diff2x} ${decus_y} ${diff2y} ${decus_z} ${diff2z} 0 1 ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion
fi

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus -bin ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin

#fsleyes ${MYDIR}/diffusion/mean_b0_unwarped ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion  ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_lesionterm/fdt_paths &

#echo `basename $MYDIR` `fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin -V` `fslstats ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion -V`

flirt -applyxfm -init ${MYDIR}/diffusion/xfms/diff_2_T1_bbr.mat -in ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin  -out ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin2T1 -ref ${MYDIR}/anat/T1 

flirt -applyxfm -init ${MYDIR}/diffusion/xfms/diff_2_T1_bbr.mat -in ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion -out ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion2T1 -ref ${MYDIR}/anat/T1 

fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin2T1 -thr 0.5 -bin ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin2T1_bin
fslmaths ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion2T1 -thr 0.5 -bin ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion2T1_bin

fsleyes ${MYDIR}/anat/T1 ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_SCP_decus2lesion2T1_bin -cm "Red"  ${MYDIR}/diffusion/Kwon_ROIs_ants/dentate_${TREATED_DENTATE}_dil_thalterm/fdt_paths_bin_nolesion_untreated_dentate2SCP_decus_bin2T1_bin -cm "Blue" &

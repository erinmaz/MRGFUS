#need to run FNIRT with mT1 for 9001_SH-11692, 9006_EO-12487, and 9021_WM-14455
#No idea why these are missing, especially 9001 and 9006. Possible I just didn't get around to doing 9021

for MYSUB in 9001_SH-11692 9006_EO-12487 9021_WM-14455
do
analysis_T12MNI_1mm_lesionmask.sh ${MYSUB} &
done

for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127

do
PREFIX=${MYSUB%??????}
DAY1=`ls -d /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${PREFIX}* | head -1`
DAY1_ID=`basename ${DAY1}`
DAY1_ANALYSIS=/Users/erin/Desktop/Projects/MRGFUS/analysis/${DAY1_ID}
applywarp -i ${DAY1}/anat/T1_lesion_mask_filled -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff --interp=trilinear --premat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${PREFIX}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr.mat

#WORSE LESION OVERLAP WHEN I USE THIS WARP INSTEAD
#applywarp -i ${DAY1}/anat/T1_lesion_mask_filled -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${PREFIX}_longitudinal_xfms_T1/day1_to_pre_warp --interp=trilinear --premat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff_bin

invwarp -w ${DAY1_ANALYSIS}/anat/xfms/mT1_2_MNI_1mm_warp -r ${DAY1_ANALYSIS}/anat/mT1 -o ${DAY1_ANALYSIS}/anat/xfms/MNI_1mm_2_mT1_warp 

applywarp -i ${DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_xswap -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2MNI_1mm_xswap_2diff -w ${DAY1_ANALYSIS}/anat/xfms/MNI_1mm_2_mT1_warp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${PREFIX}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr.mat

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2MNI_1mm_xswap_2diff -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2MNI_1mm_xswap_2diff_bin

outdir_dentate_R=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_thalterm
outdir_dentate_L=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_thalterm

volR=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
volL=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
vollesion=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`

volRswap=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2MNI_1mm_xswap_2diff_bin -V | awk '{print $2}'`
volLswap=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2MNI_1mm_xswap_2diff_bin -V | awk '{print $2}'`
vollesionswap=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/T1_lesion_mask_filled2MNI_1mm_xswap_2diff_bin -V | awk '{print $2}'`

echo $MYSUB `basename ${DAY1}` $volR $volL $vollesion $volRswap $volLswap $vollesionswap
done
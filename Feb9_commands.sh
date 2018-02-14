analysis_diffusion_step3_day1_T1_lesion_2_pre.sh 9004_EP 12126 12203 /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9004_EP-12203/anat/T1_lesion_mask_filled.nii.gz

analysis_diffusion_step3_day1_T1_lesion_2_pre.sh 9008_JO 12613 12667 /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9008_JO-12667/anat/T1_lesion_mask_filled.nii.gz

analysis_diffusion_step3_day1_T1_lesion_2_pre.sh 9009_CRB 12609 13043 /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9009_CRB-13043/anat/T1_lesion_mask_filled.nii.gz

analysis_diffusion_day1_T1_lesion_longitudinal.sh 9004_EP 12126 12203 12955

analysis_diffusion_day1_T1_lesion_longitudinal.sh 9006_EO 12389 12487 13017
#this didn't run for 13017 but that's OK for today.



applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/9001_SH-11644_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -thr 0.01 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k fdt_paths_norm_pre_to_target_thr0.01_bin -M

Just look at first three - these are the 9001_SH data
0.585134 
0.583525 
0.587249



applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/9004_EP-12126_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -thr 0.01 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin -M

values corresponding to 9004_EP:
0.483450 
0.483512 
0.488515


applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-12389/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/9006_EO-12389_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -thr 0.01 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin -M

0.562607 
0.545573 
0.534797 

Maybe a drop here! suspicious that it occurs at day 1 too though. Should probably exclude the lesion


applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/rois/T1_lesion_mask_filled -o /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/9001_SH-11644_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fsleyes $FSLDIR/data/standard/FMRIB58_FA_1mm /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion -M
0.586740 
0.586912 
0.590418 


f=9004_EP
g=12126
applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}-${g}/diffusion/rois/T1_lesion_mask_filled -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/${f}-${g}_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fsleyes $FSLDIR/data/standard/FMRIB58_FA_1mm /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion -M

0.486965 
0.488129 
0.491849 

f=9006_EO
g=12389
applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}-${g}/diffusion/rois/T1_lesion_mask_filled -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/${f}-${g}_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fsleyes $FSLDIR/data/standard/FMRIB58_FA_1mm /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion -M

0.563166 
0.546847 
0.535916 *** difference could be problem with T1 to diff reg (?)



analysis_diffusion_day1_T1_lesion_longitudinal.sh 9002_RA 11764 11833 12388
f=9002_RA
g=11764

applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}-${g}/diffusion.bedpostX/T1_lesion_mask_filled/fdt_paths_norm -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/${f}-${g}_FA_FA_to_target_warp --interp=nn


applywarp -i  /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}-${g}/diffusion/rois/T1_lesion_mask_filled -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss/FA/${f}-${g}_FA_FA_to_target_warp --interp=nn

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target -thr 0.01 -bin -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/T1_lesion_mask_filled_to_target /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fsleyes $FSLDIR/data/standard/FMRIB58_FA_1mm /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion

fslstats -t /Users/erin/Desktop/Projects/MRGFUS/tbss/stats/all_FA_skeletonised.nii.gz -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${f}_diffusion_longitudinal/day1_T1_lesion/fdt_paths_norm_pre_to_target_thr0.01_bin_nolesion -M

0.560674 
0.549354 
0.553182 
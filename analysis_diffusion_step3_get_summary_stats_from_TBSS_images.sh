#Get ROIs based on pre-treatment tracts in standard space
#Analyze on FA skeleton and all_FA images
#Check especially how inferior tracts look relative to skeleton, on contralateral and ipsilateral side (relative to lesion)

#PROBTRACKX OUTPUT PREFIX FROM analysis_diffusion_step2_track_pre_From_day1_lesion.sh
ANALYSIS=150518
ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis 
i=0

#EDIT TO INCLUDE ANY NEW SUBJECTS
subs=(9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB)


#EDIT TO INCLUDE ANY NEW SUBJECTS
for MYSUB_TOTRACK in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 
do 
for theseed
for roi in ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_thalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_thalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_thalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_nothalamus ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_orneighbours_thalamus

diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior  diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus diffusion/rois_Apr24_2018/day1_T1_lesion diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus  diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior  diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral
do
applywarp -i ${f}/${roi} -o ${f}/${roi}2standard -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w /Users/erin/Desktop/Projects/MRGFUS/tbss_Apr24_2018/FA/${f}_FA_FA_to_target_warp --interp=nn
for time in pre day1 3M
do
for measure in FA MD RD L1
do
echo ${subs[$i]} $roi $time $measure `fslstats ${subs[$i]}_diffusion_longitudinal/tbss_Apr24_2018_images/${measure}_${time} -k ${f}/${roi}2standard -M -V` >> tractography_TBSS_skeleton_Apr24_2018_output_mean_vol.txt

echo ${subs[$i]} $roi $time $measure `fslstats ${subs[$i]}_diffusion_longitudinal/tbss_Apr24_2018_images/${measure}_image_${time} -k ${f}/${roi}2standard -M -V` >> tractography_TBSS_images_Apr24_2018_output_mean_vol.txt


done
done
done
let i=$i+1
done


# Get ROIs based on pre-treatment tracts in standard space
# Analyze on FA skeleton and all_FA images
# Check especially how inferior tracts look relative to skeleton, on contralateral and ipsilateral side (relative to lesion)

# PROBTRACKX OUTPUT PREFIX FROM analysis_diffusion_step2_track_pre_from_day1_lesion.sh
TRACT_OUTPUT=tracking_day1_lesion_150518

#OUTPUT FROM analysis_diffusion_step1B_run_tbss_preproc.sh
TBSSNAME=tbss_140518
TBSSDIR=/Users/erin/Desktop/Projects/MRGFUS/${TBSSNAME}
ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis 
i=0

#EDIT TO INCLUDE ANY NEW SUBJECTS
subs=(9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB)
for MYSUB_TOTRACK in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 
do 
	for theseed in ${TRACT_OUTPUT} ${TRACT_OUTPUT}_contralateral
	do
		for roi in diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_thalamus diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_orneighbours_thalamus diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_nothalamus diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_thalamus diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_thalamus diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_superior_nothalamus diffusion.bedpostX/${theseed}/fdt_paths_norm_thr0.01_bin_nolesion_inferior_nothalamus diffusion/rois_${TRACT_OUTPUT}/${theseed}_neighbouringvoxels diffusion/rois_${TRACT_OUTPUT}/${theseed}
		do
			applywarp -i ${ANALYSISDIR}/${MYSUB_TOTRACK}/${roi} -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/${roi}2standard_tbss_warp -r $FSLDIR/data/standard/FMRIB58_FA_1mm -w ${TBSSDIR}/FA/${MYSUB_TOTRACK}_FA_FA_to_target_warp --interp=spline
			fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/${roi}2standard_tbss_warp -thr 0.5 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/${roi}2standard_tbss_warp
			for scan in pre day1 3M
			do
				for measure in FA MD RD L1
				do
					for type in image skeleton
					do
						echo ${subs[$i]} $roi $scan $measure $type `fslstats ${ANALYSISDIR}/${subs[$i]}_diffusion_longitudinal/${TBSSNAME}_${type}/${measure}_${scan} -k ${ANALYSISDIR}/${MYSUB_TOTRACK}/${roi}2standard_tbss_warp -M -V` >> ${ANALYSISDIR}/tractography_${TBSSNAME}_${TRACT_OUTPUT}_${type}_output_mean_vol_regen.txt
					done
				done
			done
		done
	done
	let i=$i+1
done
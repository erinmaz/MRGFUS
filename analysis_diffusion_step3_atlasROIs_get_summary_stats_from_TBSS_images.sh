# Get ROIs based on pre-treatment tracts in standard space
# Analyze on FA skeleton and all_FA images
# Check especially how inferior tracts look relative to skeleton, on contralateral and ipsilateral side (relative to lesion)

# PROBTRACKX OUTPUT PREFIX FROM analysis_diffusion_step2_track_pre_from_day1_lesion.sh
TRACT_OUTPUT=tracking_atlasROIs_120618

#OUTPUT FROM analysis_diffusion_step1B_run_tbss_preproc.sh
TBSSNAME=tbss_140518
TBSSDIR=/Users/erin/Desktop/Projects/MRGFUS/${TBSSNAME}
ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis 
i=0

#EDIT TO INCLUDE ANY NEW SUBJECTS
subs=(9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB)
for MYSUB_TOTRACK in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 
do 
		for roi in `ls -d ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion.bedpostX/${TRACT_OUTPUT}/*2standard*`
		do
			for scan in pre day1 3M
			do
				for measure in FA MD RD L1
				do
					for type in image skeleton
					do
						echo ${subs[$i]} $roi $scan $measure $type `fslstats ${ANALYSISDIR}/${subs[$i]}_diffusion_longitudinal/${TBSSNAME}_${type}/${measure}_${scan} -k ${ANALYSISDIR}/${MYSUB_TOTRACK}/${roi}2standard_tbss_warp -M -V` >> ${ANALYSISDIR}/tractography_${TBSSNAME}_${TRACT_OUTPUT}_${type}_output_mean_vol.txt
					done
				done
			done
		done
	
	let i=$i+1
done
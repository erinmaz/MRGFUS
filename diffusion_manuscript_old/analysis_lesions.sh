# Aug 31, 2018

#NEED TO CHECK AND STEP THROUGH
#For Steven Allen
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
CURRENT_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_310818

SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD )

TREATMENT_SIDE=( L L L R L R L L )

PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455 )

###### GET SUMMARY STATS IN ROIS #########################################################

OUTPREFIX=${CURRENT_ANALYSIS}/summary_lesions
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do 
  for roi in ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff_2_pre_T1 ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff_2_pre_T1_neighbours
  do
	roi_name=`basename $roi`	
	for scan in TP1 TP2 TP3
	do
		for measure in dtifit_FA dtifit_MD dtifit_RD dtifit_L1 dtifit_MO
		do
			echo ${SUBS[${index}]} $roi $scan $measure `fslstats ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/${scan}_${measure} -k ${roi} -M -V` >> ${OUTPREFIX}_${roi_name}_output_mean_vol.txt
		done
	done
  done
  let index=$index+1
done


	
###### IMPORT TO EXCEL TO MAKE PIVOT TABLES ##############################################



# Aug 31, 2018

#NEED TO CHECK AND STEP THROUGH

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
CURRENT_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_310818
TCKINFO_OUTPUT=${CURRENT_ANALYSIS}/tckinfo_output.txt
T1_2_DIFF=T1_2_diff_bbr.mat 
OUTFOLDER=mrtrix_310818

SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD )

TREATMENT_SIDE=( L L L R L R L L )

PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455 )
DAY1_RUNS=( 9001_SH-11692 9002_RA-11833 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9013_JD-13722 )
MONTH3_RUNS=( 9001_SH-12271 9002_RA-12388 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-13055 9009_CRB-13623 9013_JD-14227 )

###### GET SUMMARY STATS IN ROIS #########################################################

OUTPREFIX=${CURRENT_ANALYSIS}/summary
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do 

  if [ "${TREATMENT_SIDE[${index}]}" == "L" ]; then
	OTHERSIDE=R
  else
	OTHERSIDE=L
  fi

	WORKDIR=${CURRENT_ANALYSIS}/${r}
    WARP_STDtoT1=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp_inv
    
	for tract in ${WORKDIR}/rtt_from_cortex ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap 
	do
		tract_name=`basename $tract`
		for roi in ${tract}_bin2T1_nolesion_noneighbours_inferior_nothalamus ${tract}_bin2T1_nolesion_noneighbours_inferior_thalamusonly ${tract}_bin2T1_nolesion_noneighbours_thalamusonly ${tract}_bin2T1_nolesion_noneighbours_superior_thalamusonly ${tract}_bin2T1_nolesion_noneighbours_superior_nothalamus
		do
			for scan in TP1 TP2 TP3
			do
				for measure in dtifit_FA dtifit_MD dtifit_RD dtifit_L1 dtifit_MO
				do
					echo ${SUBS[${index}]} $roi $scan $measure `fslstats ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/${scan}_${measure} -k ${roi} -M -V` >> ${OUTPREFIX}_${tract_name}_output_mean_vol.txt
				done
			done
		done
	done
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -o ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]}  --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -thr 0.05 -bin ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} 
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/superior_cerebellar_peduncle_${OTHERSIDE} -o ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE} --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE} -thr 0.05 -bin ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE}
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -o ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]}  --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -thr 0.05 -bin ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} 
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/middle_cerebellar_peduncle_${OTHERSIDE} -o ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE} --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE} -thr 0.05 -bin ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE}
	
	side=0
	for roi in ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE}  ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE}
	do
		for scan in TP1 TP2 TP3
		do
			for measure in dtifit_FA dtifit_MD dtifit_RD dtifit_L1 dtifit_MO
			do
				echo ${SUBS[${index}]} $roi $side $scan $measure `fslstats ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/${scan}_${measure} -k ${roi} -M -V` >> ${OUTPREFIX}_SCP_output_mean_vol.txt
			done
		done
		let side=$side+1
	done
	
	let index=$index+1
done

	
###### IMPORT TO EXCEL TO MAKE PIVOT TABLES ##############################################



#!/bin/bash


WORKDIR=${CURRENT_ANALYSIS}/${r}/${OUTFOLDER}

THALAMUS_MASK=${ROIDIR}/thalamus_${TREATMENT_SIDE[${index}]}
THALAMUS_MASK_BINV=${ROIDIR}/thalamus_${TREATMENT_SIDE[${index}]}_binv
CEREBELLUM_MASK_BINV=${ROIDIR}/cerebellum+brainstem_inf_of_scp_binv

if [ "${TREATMENT_SIDE[${index}]}" == "L" ]; then
	OTHERSIDE=R
else
	OTHERSIDE=L
fi

# CHECK NAMES OF FILES IN TBSSDIR

WARP2DIFF=${TBSSDIR}/FA/${r}_FA_to_target_warp_inv
WARP2STD=${TBSSDIR}/FA/${r}_FA_to_target_warp

applywarp -w ${WARP2DIFF} -i ${ROIDIR}/cerebellum+brainstem_inf_of_scp+scp+pons_binv -o ${WORKDIR}/cerebellum+brainstem_inf_of_scp+scp+pons_binv --interp=trilinear -r ${TBSSDIR}/origdata/${r}
fslmaths ${WORKDIR}/cerebellum+brainstem_inf_of_scp+scp+pons_binv -thr 0.5 -bin ${WORKDIR}/cerebellum+brainstem_inf_of_scp+scp+pons_binv

tckedit -mask ${WORKDIR}/cerebellum+brainstem_inf_of_scp+scp+pons_binv.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum.tck -force
tckmap -template ${TBSSDIR}/origdata/${r}.nii.gz ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum.tck  ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum.nii.gz -force

tckedit -exclude ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff .nii.gz ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum.tck ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion.tck -force
tckedit -include ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff .nii.gz ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum.tck ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion.tck -force

tckmap -template ${TBSSDIR}/origdata/${r}.nii.gz ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion.tck ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion.nii.gz -force
tckmap -template ${TBSSDIR}/origdata/${r}.nii.gz ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion.nii.gz  -force

fslmaths ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion -mas ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_overlap
fslmaths ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_overlap -binv ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_overlap_binv

fslmaths ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion -mas ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_overlap_binv ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion_nooverlap
fslmaths ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion -mas ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_overlap_binv ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion_nooverlap

inc_les_vol_all=`fslstats ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion_nooverlap -V`
exc_les_vol_all=`fslstats ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion_nooverlap -V`
overlap_vol_all=`fslstats ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_overlap -V`
inc_les_vol=`echo ${inc_les_vol_all} | awk '{print $2}'`
exc_les_vol=`echo ${exc_les_vol_all} | awk '{print $2}'`
overlap_vol=`echo ${overlap_vol_all} | awk '{print $2}'`
inc_les_count=`tckinfo ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion.tck | grep -w count: | awk '{print $2}'`
exc_les_count=`tckinfo ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion.tck | grep -w count: | awk '{print $2}'`
echo $MYSUB ${inc_les_vol} ${exc_les_vol} ${overlap_vol} ${inc_les_count} ${exc_les_count} >> ${TCKINFO_OUTPUT}

# CREATE ROIS BASED ON TRACTS

# lesion to standard space
applywarp -w ${WARP2STD} -i ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff  -o ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard --interp=trilinear -r ${TBSSDIR}/stats/mean_FA
fslmaths ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard -thr 0.5 -bin ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard

# Day 1 T1 from pre diff to standard space (for checking ROIs)
applywarp -w ${WARP2STD} -i ${CURRENT_ANALYSIS}/${r}/day1_T1_2_pre_diff  -o ${CURRENT_ANALYSIS}/${r}/day1_T1_2_pre_diff 2standard --interp=trilinear -r ${TBSSDIR}/stats/mean_FA
	
for tract in ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_exclude_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum
do
	# zero out bottom 5 slices in case we tracked very inferiorly - FA maps do not all extend to the bottom most slice 
	fslmaths ${tract} -bin -roi 0 -1 0 -1 5 -1 0 1 ${tract}_bin

	# transform to standard space for use with TBSS images
	applywarp -w ${WARP2STD} -i ${tract}_bin -o ${tract}_bin2standard --interp=trilinear -r ${TBSSDIR}/stats/mean_FA
	fslmaths ${tract}_bin2standard -thr 0.5 -bin ${tract}_bin2standard

	# dilate lesion to get neighbours mask
	fslmaths ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard -dilM ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard+neighbours
	fslmaths ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard+neighbours -sub ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard_neighbours
	 
	# binv lesion and lesion+neighbours
	fslmaths ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard -binv ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard_binv
 	fslmaths ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard+neighbours -binv ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard+neighbours_binv
 	
 	fslmaths ${tract}_bin2standard -mas ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard_binv ${tract}_bin2standard_nolesion
 	fslmaths ${tract}_bin2standard -mas ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard+neighbours_binv ${tract}_bin2standard_nolesion_noneighbours

	#divide tract into superior and inferior portions relative to lesion
	LESION_COG=`fslstats ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard -C`
	coords=( $LESION_COG )
	fslmaths ${tract}_bin2standard_nolesion_noneighbours -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${tract}_bin2standard_nolesion_noneighbours_superior
 	fslmaths ${tract}_bin2standard_nolesion_noneighbours -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${tract}_bin2standard_nolesion_noneighbours_inferior

	#superior portion: thalamus only or no thalamus
	fslmaths ${tract}_bin2standard_nolesion_noneighbours_superior -mas ${THALAMUS_MASK} ${tract}_bin2standard_nolesion_noneighbours_superior_thalamusonly
	fslmaths ${tract}_bin2standard_nolesion_noneighbours_superior -mas ${THALAMUS_MASK_BINV} ${tract}_bin2standard_nolesion_noneighbours_superior_nothalamus
 
 	#inferior portion: exclude cerebellum
 	fslmaths ${tract}_bin2standard_nolesion_noneighbours_inferior -mas ${CEREBELLUM_MASK_BINV} ${tract}_bin2standard_nolesion_noneighbours_inferior_nocerebellum

done

fsleyes ${CURRENT_ANALYSIS}/${r}/day1_T1_2_pre_diff 2standard ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard -cm "Red" ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff 2standard_neighbours -cm "Blue" ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_bin2standard_nolesion_noneighbours_inferior ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_bin2standard_nolesion_noneighbours_inferior_nocerebellum -cm "Green" ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_bin2standard_nolesion_noneighbours_superior_nothalamus -cm "Red-Yellow" ${WORKDIR}/rtt_from_cortex_noscp_nocerebellum_bin2standard_nolesion_noneighbours_superior_thalamusonly -cm "Blue-Lightblue" 

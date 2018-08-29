#!/bin/bash

MYSUB=$1
TREATMENTSIDE=$2
CURRENT_ANALYSIS=$3
TBSSDIR=$4
ROIDIR=$5
QADIR=$6
LESION_IN_DIFF_SPACE=$7
PRET1_IN_DIFF_SPACE=$8
OUTFOLDER=$9
TCKINFO_OUTPUT=$10

WORKDIR=${CURRENT_ANALYSIS}/${MYSUB}/${OUTFOLDER}

THALAMUS_MASK=${ROIDIR}/thalamus_${TREATMENTSIDE}
THALAMUS_MASK_BINV=${ROIDIR}/thalamus_${TREATMENTSIDE}_binv
CEREBELLUM_MASK_BINV=${ROIDIR}/cerebellum+brainstem_inf_of_scp_binv

if [ "${TREATMENTSIDE}" == "L" ]; then
	OTHERSIDE=R
else
	OTHERSIDE=L
fi

mkdir ${WORKDIR}

# CHECK NAMES OF FILES IN TBSSDIR

WARP2DIFF=${TBSSDIR}/FA/${MYSUB}_FA_to_target_warp_inv
WARP2STD=${TBSSDIR}/FA/${MYSUB}_FA_to_target_warp

if [ ! -e ${WARP2DIFF}.nii.gz ]; then
	invwarp -w ${WARP2STD} -o ${WARP2DIFF} -r ${TBSSDIR}/origdata/${MYSUB}
fi

# MAKE EXCLUSION MASK
applywarp --postmat=${QADIR}/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -i ${QADIR}/${MYSUB}/anat/c3T1.99 -o ${WORKDIR}/csf --interp=trilinear -r ${TBSSDIR}/origdata/${MYSUB}
fslmaths ${WORKDIR}/csf -thr 0.5 -bin ${WORKDIR}/csf
applywarp -w ${WARP2DIFF} -i ${ROIDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} -o ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} --interp=trilinear -r ${TBSSDIR}/origdata/${MYSUB}
fslmaths ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} -thr 0.5 -bin ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE}
fslmaths ${WORKDIR}/csf -add ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} -bin ${WORKDIR}/exclude

# MAKE SEED MASK (primary and supplementary motor)
applywarp -w ${WARP2DIFF} -i ${ROIDIR}/precentral+juxtapositional_${TREATMENTSIDE} -o ${WORKDIR}/precentral+juxtapositional_${TREATMENTSIDE} --interp=trilinear -r ${TBSSDIR}/origdata/${MYSUB}
fslmaths ${WORKDIR}/precentral+juxtapositional_${TREATMENTSIDE} -thr 0.5 -bin ${WORKDIR}/precentral+juxtapositional_${TREATMENTSIDE}

# MAKE WAYPOINT MASK (red nucleus)
applywarp -w ${WARP2DIFF} -i ${ROIDIR}/RN_${TREATMENTSIDE} -o ${WORKDIR}/RN_${TREATMENTSIDE} --interp=trilinear -r ${TBSSDIR}/origdata/${MYSUB}
fslmaths ${WORKDIR}/RN_${TREATMENTSIDE} -dilM ${WORKDIR}/RN_${TREATMENTSIDE}
fslmaths ${WORKDIR}/RN_${TREATMENTSIDE} -thr 0.5 -bin ${WORKDIR}/RN_${TREATMENTSIDE}

# GENERATE STREAMLINES
tckgen -algorithm TENSOR_DET -seed_image ${WORKDIR}/precentral+juxtapositional_${TREATMENTSIDE}.nii.gz -include ${WORKDIR}/RN_${TREATMENTSIDE}.nii.gz -exclude ${WORKDIR}/exclude.nii.gz -fslgrad ${QADIR}/${MYSUB}/diffusion/data.eddy_rotated_bvecs ${QADIR}/${MYSUB}/diffusion/bvals ${QADIR}/${MYSUB}/diffusion/data.nii.gz ${WORKDIR}/rtt_from_cortex.tck -force

# CONVERT STREAMLINES TO NII
tckmap -template ${TBSSDIR}/origdata/${MYSUB}.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex.nii.gz -force

# Check for previously generated manual exclusion mask
if [ -e ${QADIR}/${MYSUB}/diffusion/mrtrix/manual_exclude.nii.gz ]; then
	cp ${QADIR}/${MYSUB}/diffusion/mrtrix/manual_exclude.nii.gz ${WORKDIR}/manual_exclude.nii.gz
	fsleyes ${QADIR}/${MYSUB}/diffusion/mean_b0_unwarped ${WORKDIR}/rtt_from_cortex ${WORKDIR}/manual_exclude
else
	fsleyes ${QADIR}/${MYSUB}/diffusion/mean_b0_unwarped ${WORKDIR}/rtt_from_cortex
fi

# Check again if manual exclude exists, I may have just made it if the tracking is different
if [ -e ${WORKDIR}/manual_exclude.nii.gz ]; then
	mv ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_orig.tck
	mv ${WORKDIR}/rtt_from_cortex.nii.gz ${WORKDIR}/rtt_from_cortex_orig.nii.gz
	tckedit -exclude ${WORKDIR}/manual_exclude.nii.gz ${WORKDIR}/rtt_from_cortex_orig.tck ${WORKDIR}/rtt_from_cortex.tck -force
	tckmap -template ${TBSSDIR}/origdata/${MYSUB}.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex.nii.gz -force
fi
 
tckedit -exclude ${LESION_IN_DIFF_SPACE}.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck -force
tckedit -include ${LESION_IN_DIFF_SPACE}.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_include_lesion.tck -force

tckmap -template ${TBSSDIR}/origdata/${MYSUB}.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.tck ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz -force
tckmap -template ${TBSSDIR}/origdata/${MYSUB}.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz  -force

fslmaths ${WORKDIR}/rtt_from_cortex_include_lesion -mas ${WORKDIR}/rtt_from_cortex_exclude_lesion ${WORKDIR}/rtt_from_cortex_overlap
fslmaths ${WORKDIR}/rtt_from_cortex_overlap -binv ${WORKDIR}/rtt_from_cortex_overlap_binv

fslmaths ${WORKDIR}/rtt_from_cortex_include_lesion -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap
fslmaths ${WORKDIR}/rtt_from_cortex_exclude_lesion -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap

inc_les_vol=`fslstats ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap -V`
exc_les_vol=`fslstats ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap -V`
overlap_vol=`fslstats ${WORKDIR}/rtt_from_cortex_overlap -V`
inc_les_count=`tckinfo ${WORKDIR}/rtt_from_cortex_include_lesion.tck | grep -w count: | awk '{print $2}'`
exc_les_count=`tckinfo ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck | grep -w count: | awk '{print $2}'`
echo $MYSUB ${inc_les_vol} ${exc_les_vol} ${overlap_vol} ${inc_les_count} ${exc_lesion_count} >> ${TCKINFO_OUTPUT}


# CREATE ROIS BASED ON TRACTS

# lesion to standard space
applywarp -w ${WARP2STD} -i ${LESION_IN_DIFF_SPACE} -o ${LESION_IN_DIFF_SPACE}2standard --interp=trilinear -r ${TBSSDIR}/stats/mean_FA
fslmaths ${LESION_IN_DIFF_SPACE}2standard -thr 0.5 -bin ${LESION_IN_DIFF_SPACE}2standard

# Day 1 T1 from pre diff to standard space (for checking ROIs)
applywarp -w ${WARP2STD} -i ${PRET1_IN_DIFF_SPACE} -o ${PRET1_IN_DIFF_SPACE}2standard --interp=trilinear -r ${TBSSDIR}/stats/mean_FA
	
for tract in ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap ${WORKDIR}/rtt_from_cortex
do
	# zero out bottom 5 slices in case we tracked very inferiorly - FA maps do not all extend to the bottom most slice 
	fslmaths ${tract} -bin -roi 0 -1 0 -1 5 -1 0 1 ${tract}_bin

	# transform to standard space for use with TBSS images
	applywarp -w ${WARP2STD} -i ${tract}_bin -o ${tract}_bin2standard --interp=trilinear -r ${TBSSDIR}/stats/mean_FA
	fslmaths ${tract}_bin2standard -thr 0.5 -bin ${tract}_bin2standard

	# dilate lesion to get neighbours mask
	fslmaths ${LESION_IN_DIFF_SPACE}2standard -dilM ${LESION_IN_DIFF_SPACE}2standard+neighbours
	fslmaths ${LESION_IN_DIFF_SPACE}2standard+neighbours -sub ${LESION_IN_DIFF_SPACE}2standard ${LESION_IN_DIFF_SPACE}2standard_neighbours
	 
	# binv lesion and lesion+neighbours
	fslmaths ${LESION_IN_DIFF_SPACE}2standard -binv ${LESION_IN_DIFF_SPACE}2standard_binv
 	fslmaths ${LESION_IN_DIFF_SPACE}2standard+neighbours -binv ${LESION_IN_DIFF_SPACE}2standard+neighbours_binv
 	
 	fslmaths ${tract}_bin2standard -mas ${LESION_IN_DIFF_SPACE}2standard_binv ${tract}_bin2standard_nolesion
 	fslmaths ${tract}_bin2standard -mas ${LESION_IN_DIFF_SPACE}2standard+neighbours_binv ${tract}_bin2standard_nolesion_noneighbours

	#divide tract into superior and inferior portions relative to lesion
	LESION_COG=`fslstats ${LESION_IN_DIFF_SPACE}2standard -C`
	coords=( $LESION_COG )
	fslmaths ${tract}_bin2standard_nolesion_noneighbours -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${tract}_bin2standard_nolesion_noneighbours_superior
 	fslmaths ${tract}_bin2standard_nolesion_noneighbours -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${tract}_bin2standard_nolesion_noneighbours_inferior

	#superior portion: thalamus only or no thalamus
	fslmaths ${tract}_bin2standard_nolesion_noneighbours_superior -mas ${THALAMUS_MASK} ${tract}_bin2standard_nolesion_noneighbours_superior_thalamusonly
	fslmaths ${tract}_bin2standard_nolesion_noneighbours_superior -mas ${THALAMUS_MASK_BINV} ${tract}_bin2standard_nolesion_noneighbours_superior_nothalamus
 
 	#inferior portion: exclude cerebellum
 	fslmaths ${tract}_bin2standard_nolesion_noneighbours_inferior -mas ${CEREBELLUM_MASK_BINV} ${tract}_bin2standard_nolesion_noneighbours_inferior_nocerebellum

done

fsleyes ${PRET1_IN_DIFF_SPACE}2standard ${LESION_IN_DIFF_SPACE}2standard -cm "Red" ${LESION_IN_DIFF_SPACE}2standard_neighbours -cm "Blue" ${WORKDIR}/rtt_from_cortex_bin2standard_nolesion_noneighbours_inferior_nocerebellum -cm "Green" ${WORKDIR}/rtt_from_cortex_bin2standard_nolesion_noneighbours_superior_nothalamus  -cm "Red-Yellow" ${WORKDIR}/rtt_from_cortex_bin2standard_nolesion_noneighbours_superior_thalamusonly -cm "Blue-Lightblue"

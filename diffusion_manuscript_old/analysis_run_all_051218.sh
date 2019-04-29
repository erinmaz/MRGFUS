# Dec 5, 2018
# Add subjects after MDS rejection

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
CURRENT_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_051218
TCKINFO_OUTPUT=${CURRENT_ANALYSIS}/tckinfo_output.txt
T1_2_DIFF=T1_2_diff_bbr.mat 


SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM )

TREATMENT_SIDE=( L L L R L R L L L L R L )

PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 )

DAY1_RUNS=( 9001_SH-11692 9002_RA-11833 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9010_RR-13536 9011_BB-14148 9013_JD-13722 9016_EB-14450 9021_WM-14455 )

MONTH3_RUNS=( 9001_SH-12271 9002_RA-12388 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-13055 9009_CRB-13623 9010_RR-14700 9011_BB-14878 9013_JD-14227 9016_EB-15241 9021_WM-15089 )

mkdir ${CURRENT_ANALYSIS}


#### REGISTRATIONS #######################################################################


for s in "${SUBS[@]}"
do
	mkdir ${CURRENT_ANALYSIS}/${s}_longitudinal_xfms
done

index=0
for r in "${PRETREATMENT_RUNS[@]}"
do
	mkdir ${CURRENT_ANALYSIS}/${r}
	
	# Longitudinally within patient
	flirt -in ${QADIR}/${DAY1_RUNS[${index}]}/anat/T1_brain -ref ${QADIR}/${r}/anat/T1_brain -o ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_2_pre_T1_brain -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_T1_brain_2_pre_T1_brain.mat -dof 6
	convert_xfm -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_T1_brain_2_pre_diff.mat -concat ${QADIR}/${r}/diffusion/xfms/${T1_2_DIFF} ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_T1_brain_2_pre_T1_brain.mat  
	applywarp --postmat=${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_T1_brain_2_pre_diff.mat -i ${LESION_ANALYSIS}/${DAY1_RUNS[${index}]}/anat/T1_lesion_mask_filled -o ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
	fslmaths ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff -thr 0.5 -bin ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff
	applywarp --postmat=${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_T1_brain_2_pre_diff.mat -i ${LESION_ANALYSIS}/${DAY1_RUNS[${index}]}/anat/T1 -o ${CURRENT_ANALYSIS}/${r}/day1_T1_2_pre_diff --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
	
	flirt -in ${QADIR}/${MONTH3_RUNS[${index}]}/anat/T1_brain -ref ${QADIR}/${r}/anat/T1_brain -o ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/month3_2_pre_T1_brain -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/month3_T1_brain_2_pre_T1_brain.mat -dof 6

	convert_xfm -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_diff_2_pre_T1.mat -concat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_T1_brain_2_pre_T1_brain.mat ${QADIR}/${DAY1_RUNS[${index}]}/diffusion/xfms/diff_2_T1_bbr.mat
	
	convert_xfm -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/month3_diff_2_pre_T1.mat -concat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/month3_T1_brain_2_pre_T1_brain.mat ${QADIR}/${MONTH3_RUNS[${index}]}/diffusion/xfms/diff_2_T1_bbr.mat
	
	mkdir ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal
	for image in dtifit_FA dtifit_RD dtifit_L1 dtifit_MD dtifit_MO
	do
		applywarp --postmat=${QADIR}/${r}/diffusion/xfms/diff_2_T1_bbr.mat -i ${QADIR}/${r}/diffusion/${image} -r ${QADIR}/${r}/anat/T1 -o ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/TP1_${image}
		applywarp --postmat=${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/day1_diff_2_pre_T1.mat -i ${QADIR}/${DAY1_RUNS[${index}]}/diffusion/${image} -r ${QADIR}/${r}/anat/T1 -o ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/TP2_${image}
		applywarp --postmat=${CURRENT_ANALYSIS}/${SUBS[${index}]}_longitudinal_xfms/month3_diff_2_pre_T1.mat -i ${QADIR}/${MONTH3_RUNS[${index}]}/diffusion/${image} -r ${QADIR}/${r}/anat/T1 -o ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/TP3_${image}
	done
		
	# Pre-treatment T1 to standard space + inv
	mkdir ${CURRENT_ANALYSIS}/${r}/xfms
	/usr/local/fsl/bin/flirt -in ${QADIR}/${r}/anat/T1_brain -ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain -out ${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_flirt -omat ${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_flirt.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear 
	/usr/local/fsl/bin/fnirt --in=${QADIR}/${r}/anat/T1 --aff=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_flirt.mat --cout=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp --iout=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_fnirt --jout=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_jac --ref=/usr/local/fsl/data/standard/MNI152_T1_1mm  --refmask=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask_dil --warpres=10,10,10 --config=T1_2_MNI152_2mm 
	invwarp -w ${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp -r ${QADIR}/${r}/anat/T1 -o ${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp_inv
	let index=${index}+1
done


###### RUN MRTRIX ANALYSIS AND CREATE ROIS ###############################################

echo subject inc_les_vol_nooverlap exc_les_vol_nooverlap overlap_vol inc_les_count exc_lesion_count > ${TCKINFO_OUTPUT}
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do

WORKDIR=${CURRENT_ANALYSIS}/${r}

THALAMUS_MASK=${ROIDIR}/thalamus_${TREATMENT_SIDE[${index}]}
THALAMUS_MASK_NAME=`basename ${THALAMUS_MASK}`
THALAMUS_MASK_BINV_NAME=`basename ${THALAMUS_MASK_BINV}`
THALAMUS_MASK_BINV=${ROIDIR}/thalamus_${TREATMENT_SIDE[${index}]}_binv
CEREBELLUM_MASK_BINV=${ROIDIR}/cerebellum+brainstem_inf_of_scp+scp+pons_binv
CEREBELLUM_MASK_BINV_NAME=`basename ${CEREBELLUM_MASK_BINV}`

if [ "${TREATMENT_SIDE[${index}]}" == "L" ]; then
	OTHERSIDE=R
else
	OTHERSIDE=L
fi

WARP_STDtoT1=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp_inv
MAT_T1todiff=${QADIR}/${r}/diffusion/xfms/T1_2_diff_bbr.mat

applywarp -w ${WARP_STDtoT1} --postmat=${MAT_T1todiff} -i ${CEREBELLUM_MASK_BINV} -o ${WORKDIR}/${CEREBELLUM_MASK_BINV_NAME} --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
fslmaths ${WORKDIR}/${CEREBELLUM_MASK_BINV_NAME} -thr 0.5 -bin ${WORKDIR}/${CEREBELLUM_MASK_BINV_NAME} 


# MAKE EXCLUSION MASK
applywarp --postmat=${MAT_T1todiff} -i ${QADIR}/${r}/anat/c3T1.99 -o ${WORKDIR}/csf --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
fslmaths ${WORKDIR}/csf -thr 0.5 -bin ${WORKDIR}/csf
applywarp -w ${WARP_STDtoT1} --postmat=${MAT_T1todiff} -i ${ROIDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} -o ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
fslmaths ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} -thr 0.5 -bin ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE}
fslmaths ${WORKDIR}/csf -add ${WORKDIR}/cerebrum+thalamus+spinalcord_${OTHERSIDE} -bin ${WORKDIR}/exclude

fslmaths ${WORKDIR}/exclude -binv ${WORKDIR}/exclude_binv

# MAKE SEED MASK (primary and supplementary motor)
applywarp -w ${WARP_STDtoT1} --postmat=${MAT_T1todiff} -i ${ROIDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]} -o ${WORKDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]} --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
fslmaths ${WORKDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]} -thr 0.5 -bin ${WORKDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]}

fslmaths ${WORKDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]} -mas ${WORKDIR}/exclude_binv ${WORKDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]}

# MAKE WAYPOINT MASK (red nucleus)
applywarp -w ${WARP_STDtoT1} --postmat=${MAT_T1todiff} -i ${ROIDIR}/RN_${TREATMENT_SIDE[${index}]} -o ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]} --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
fslmaths ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]} -thr 0.5 -bin ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]}
fslmaths ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]} -dilM ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]}

fslmaths  ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]} -mas ${WORKDIR}/exclude_binv ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]}

# GENERATE STREAMLINES
tckgen -algorithm TENSOR_DET -seed_image ${WORKDIR}/precentral+juxtapositional_${TREATMENT_SIDE[${index}]}.nii.gz -include ${WORKDIR}/RN_${TREATMENT_SIDE[${index}]}.nii.gz -exclude ${WORKDIR}/exclude.nii.gz -fslgrad ${QADIR}/${r}/diffusion/data.eddy_rotated_bvecs ${QADIR}/${r}/diffusion/bvals ${QADIR}/${r}/diffusion/data.nii.gz ${WORKDIR}/rtt_from_cortex_orig.tck -force

tckedit -mask ${WORKDIR}/${CEREBELLUM_MASK_BINV_NAME}.nii.gz ${WORKDIR}/rtt_from_cortex_orig.tck ${WORKDIR}/rtt_from_cortex_orig_short.tck -force

# CONVERT STREAMLINES TO NII
tckmap -template ${QADIR}/${r}/diffusion/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_orig_short.tck ${WORKDIR}/rtt_from_cortex_orig_short.nii.gz -force

# Check for previously generated manual exclusion mask
if [ -e ${QADIR}/${r}/diffusion/mrtrix/manual_exclude.nii.gz ]; then
	cp ${QADIR}/${r}/diffusion/mrtrix/manual_exclude.nii.gz ${WORKDIR}/manual_exclude.nii.gz
	fsleyes ${QADIR}/${r}/diffusion/mean_b0_unwarped ${WORKDIR}/rtt_from_cortex_orig_short ${WORKDIR}/manual_exclude
else
	fsleyes ${QADIR}/${r}/diffusion/mean_b0_unwarped ${WORKDIR}/rtt_from_cortex_orig_short
fi

# Check again if manual exclude exists, I may have just made it if the tracking is different
if [ -e ${WORKDIR}/manual_exclude.nii.gz ]; then
	tckedit -exclude ${WORKDIR}/manual_exclude.nii.gz ${WORKDIR}/rtt_from_cortex_orig_short.tck ${WORKDIR}/rtt_from_cortex.tck -force
else
	cp ${WORKDIR}/rtt_from_cortex_orig_short.tck ${WORKDIR}/rtt_from_cortex.tck 
fi
 
tckmap -template ${QADIR}/${r}/diffusion/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex.nii.gz -force
 	
tckedit -exclude ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck -force
tckedit -include ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff.nii.gz ${WORKDIR}/rtt_from_cortex.tck ${WORKDIR}/rtt_from_cortex_include_lesion.tck -force

tckmap -template ${QADIR}/${r}/diffusion/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_include_lesion.tck ${WORKDIR}/rtt_from_cortex_include_lesion.nii.gz -force
tckmap -template ${QADIR}/${r}/diffusion/mean_b0_unwarped.nii.gz ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion.nii.gz  -force

fslmaths ${WORKDIR}/rtt_from_cortex_include_lesion -mas ${WORKDIR}/rtt_from_cortex_exclude_lesion ${WORKDIR}/rtt_from_cortex_overlap
fslmaths ${WORKDIR}/rtt_from_cortex_overlap -binv ${WORKDIR}/rtt_from_cortex_overlap_binv

fslmaths ${WORKDIR}/rtt_from_cortex_include_lesion -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap
fslmaths ${WORKDIR}/rtt_from_cortex_exclude_lesion -mas ${WORKDIR}/rtt_from_cortex_overlap_binv ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap

inc_les_vol_all=`fslstats ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap -V`
exc_les_vol_all=`fslstats ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap -V`
overlap_vol_all=`fslstats ${WORKDIR}/rtt_from_cortex_overlap -V`
inc_les_vol=`echo ${inc_les_vol_all} | awk '{print $2}'`
exc_les_vol=`echo ${exc_les_vol_all} | awk '{print $2}'`
overlap_vol=`echo ${overlap_vol_all} | awk '{print $2}'`
inc_les_count=`tckinfo ${WORKDIR}/rtt_from_cortex_include_lesion.tck | grep -w count: | awk '{print $2}'`
exc_les_count=`tckinfo ${WORKDIR}/rtt_from_cortex_exclude_lesion.tck | grep -w count: | awk '{print $2}'`
echo ${SUBS[${index}]} ${inc_les_vol} ${exc_les_vol} ${overlap_vol} ${inc_les_count} ${exc_les_count} >> ${TCKINFO_OUTPUT}

# CREATE ROIS BASED ON TRACTS

# day 1 lesion to pre T1 space
applywarp --postmat=${QADIR}/${r}/diffusion/xfms/diff_2_T1_bbr.mat -i ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff -o ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1 --interp=trilinear -r ${QADIR}/${r}/anat/T1

fslmaths ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1 -thr 0.5 -bin ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1

fslmaths ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1 -binv ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1_binv

fslmaths ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1 -dilM ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1+neighbours

fslmaths ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1+neighbours -sub ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1 ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1_neighbours

fslmaths ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1+neighbours -binv ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1+neighbours_binv
	
#thalamus masks in pre T1 space
applywarp -w ${WARP_STDtoT1} -i ${THALAMUS_MASK} -o ${WORKDIR}/${THALAMUS_MASK_NAME} -r ${QADIR}/${r}/anat/T1 --interp=trilinear
fslmaths ${WORKDIR}/${THALAMUS_MASK_NAME} -thr 0.5 -bin ${WORKDIR}/${THALAMUS_MASK_NAME}

applywarp -w ${WARP_STDtoT1} -i ${THALAMUS_MASK_BINV} -o ${WORKDIR}/${THALAMUS_MASK_BINV_NAME} -r ${QADIR}/${r}/anat/T1 --interp=trilinear
fslmaths ${WORKDIR}/${THALAMUS_MASK_BINV_NAME} -thr 0.5 -bin ${WORKDIR}/${THALAMUS_MASK_BINV_NAME}

for tract in ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap ${WORKDIR}/rtt_from_cortex
do
	# binarize
	fslmaths ${tract} -bin ${tract}_bin

	# transform to pre T1 space
	applywarp --postmat=${QADIR}/${r}/diffusion/xfms/diff_2_T1_bbr.mat -i ${tract}_bin -o ${tract}_bin2T1 --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${tract}_bin2T1 -thr 0.5 -bin ${tract}_bin2T1

 	fslmaths ${tract}_bin2T1 -mas ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1_binv ${tract}_bin2T1_nolesion
 	fslmaths ${tract}_bin2T1 -mas ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1+neighbours_binv ${tract}_bin2T1_nolesion_noneighbours

	#divide tract into superior and inferior portions relative to lesion
	LESION_COG=`fslstats ${WORKDIR}/day1_lesion_2_pre_diff_2_pre_T1 -C`
	coords=( $LESION_COG )
	fslmaths ${tract}_bin2T1_nolesion_noneighbours -roi 0 -1 0 -1 ${coords[2]} -1 0 1 ${tract}_bin2T1_nolesion_noneighbours_superior
 	fslmaths ${tract}_bin2T1_nolesion_noneighbours -roi 0 -1 0 -1 0 ${coords[2]} 0 1 ${tract}_bin2T1_nolesion_noneighbours_inferior

	#superior portion: thalamus only or no thalamus
	
	fslmaths ${tract}_bin2T1_nolesion_noneighbours_superior -mas ${WORKDIR}/${THALAMUS_MASK_NAME} ${tract}_bin2T1_nolesion_noneighbours_superior_thalamusonly
	fslmaths ${tract}_bin2T1_nolesion_noneighbours_superior -mas ${WORKDIR}/${THALAMUS_MASK_BINV_NAME} ${tract}_bin2T1_nolesion_noneighbours_superior_nothalamus
 
 	fslmaths ${tract}_bin2T1_nolesion_noneighbours_inferior -mas ${WORKDIR}/${THALAMUS_MASK_NAME} ${tract}_bin2T1_nolesion_noneighbours_inferior_thalamusonly
	fslmaths ${tract}_bin2T1_nolesion_noneighbours_inferior -mas ${WORKDIR}/${THALAMUS_MASK_BINV_NAME} ${tract}_bin2T1_nolesion_noneighbours_inferior_nothalamus
	
	fslmaths ${tract}_bin2T1_nolesion_noneighbours -mas ${WORKDIR}/${THALAMUS_MASK_NAME} ${tract}_bin2T1_nolesion_noneighbours_thalamusonly

done

fsleyes ${QADIR}/${r}/anat/T1 ${WORKDIR}/rtt_from_cortex_bin2T1_nolesion_noneighbours_inferior_nothalamus -cm "Green" ${WORKDIR}/rtt_from_cortex_bin2T1_nolesion_noneighbours_superior_nothalamus -cm "Red-Yellow" ${WORKDIR}/rtt_from_cortex_bin2T1_nolesion_noneighbours_thalamusonly -cm "Blue-Lightblue" 

let index=$index+1
done


###### GET SUMMARY STATS IN ROIS #########################################################

OUTPREFIX=${CURRENT_ANALYSIS}/summary
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do 
	WORKDIR=${CURRENT_ANALYSIS}/${r}

	for tract in ${WORKDIR}/rtt_from_cortex ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap 
	do
		tract_name=`basename $tract`
		for roi in ${tract}_bin2T1_nolesion_noneighbours_inferior_nocerebellum ${tract}_bin2T1_nolesion_noneighbours_superior_thalamusonly ${tract}_bin2T1_nolesion_noneighbours_superior_nothalamus
		do
			for scan in TP1 TP2 TP3
			do
				for measure in FA MD RD L1 MO
				do
					echo ${SUBS[${index}]} $roi $scan $measure $type `fslstats ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/${scan}_${measure} -k ${roi} -M -V` >> ${OUTPREFIX}_${tract_name}_output_mean_vol.txt
				done
			done
		done
	done
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -o ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]}  --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -thr 0.05 -bin ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} 
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/superior_cerebellar_peduncle_${OTHERSIDE} -o ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE} --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE -thr 0.05 -bin ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE}
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -o ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]}  --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} -thr 0.05 -bin ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} 
	
	applywarp -w ${WARP_STDtoT1} -i ${ROIDIR}/middle_cerebellar_peduncle_${OTHERSIDE} -o ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE} --interp=trilinear -r ${QADIR}/${r}/anat/T1
	fslmaths ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE -thr 0.05 -bin ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE}
	
	side=0
	for roi in ${WORKDIR}/superior_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} ${WORKDIR}/superior_cerebellar_peduncle_${OTHERSIDE}  ${WORKDIR}/middle_cerebellar_peduncle_${TREATMENT_SIDE[${index}]} ${WORKDIR}/middle_cerebellar_peduncle_${OTHERSIDE}
	do
		for scan in TP1 TP2 TP3
		do
			for measure in FA MD RD L1
			do
				echo ${SUBS[${index}]} $roi $side $scan $measure $type `fslstats ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/${scan}_${measure} -k ${roi} -M -V` >> ${OUTPREFIX}_SCP_output_mean_vol.txt
			done
		done
		let side=$side+1
	done
	
	let index=$index+1
done

	
###### IMPORT TO EXCEL TO MAKE PIVOT TABLES ##############################################



# Aug 23, 2018
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
CURRENT_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_230818
TBSSDIR=${CURRENT_ANALYSIS}/tbss
TCKINFO_OUTPUT=${CURRENT_ANALYSIS}/tckinfo_output.txt
T1_2_DIFF=T1_2_diff_bbr.mat 

SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD )

TREATMENT_SIDE=( L L L R L R L L )

RUNS=( 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12126 9004_EP-12203 9004_EP-12955 9005_BG-13004 9005_BG-13126 9005_BG-13837 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 9013_JD-13455 9013_JD-13722 9013_JD-14227 )

PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455 )
DAY1_RUNS=( 9001_SH-11692 9002_RA-11833 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9013_JD-13722 )

mkdir ${CURRENT_ANALYSIS}

for s in "${SUBS[@]}"
do
	mkdir ${CURRENT_ANALYSIS}/${s}_diffusion_longitudinal
	mkdir ${CURRENT_ANALYSIS}/${s}_longitudinal_xfms
done

for r in "${RUNS[@]}"
do
	mkdir ${CURRENT_ANALYSIS}/${r}
	cp ${QADIR}/${r}/diffusion/dtifit_FA.nii.gz ${CURRENT_ANALYSIS}/tbss/${r}.nii.gz
done

index=0
for r in "${PRETREATMENT_RUNS[@]}"
do
	cp ${QAdir}/${r}/anat/mT1_brain.nii.gz ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/.
	cp ${QAdir}/${DAY1_RUNS[${index}]}/anat/mT1_brain.nii.gz ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/.
	flirt -i ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/mT1_brain.nii.gz -r ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/mT1_brain -o ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/day1_2_pre_mT1_brain -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/day1_mT1_brain_2_pre_mT1_brain.mat -dof 6
	convert_xfm -omat ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/day1_mT1_brain_2_pre_diff.mat -concat ${QADIR}/${r}/diffusion/xfms/${T1_2_DIFF} ${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/day1_mT1_brain_2_pre_mT1_brain.mat  
	applywarp --postmat=${CURRENT_ANALYSIS}/${SUBS[${index}]}_longituindal_xfms/day1_mT1_brain_2_pre_diff.mat -i ${LESION_ANALYSIS}/${DAY1_RUNS[${index}]}/anat/T1_lesion_mask_filled -o ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff --interp=nn -r ${QADIR}/${r}/diffusion/mean_B0_unwarped

###### RUN TBSS ##########################################################################

CWD=`pwd`
mkdir ${TBSSDIR}
cd ${TBSSDIR}
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2

for measure in MD L1
do
	mkdir ${TBSSDIR}/${measure}
	for f in "${RUNS[@]}"
	do
		cp ${QADIR}/${r}/diffusion/dtifit_${measure}.nii.gz ${TBSSDIR}/${measure}/${r}.nii.gz
	done
	tbss_non_FA ${measure}
done

mkdir ${TBSSDIR}/RD
for f in "${RUNS[@]}"
do
	fslmaths ${QADIR}/${r}/diffusion/dtifit_L2 -add ${QADIR}/${r}/diffusion/dtifit_L3 -div 2 ${QADIR}/${r}/diffusion/RD
	cp ${QADIR}/${r}/diffusion/RD.nii.gz ${TBSSDIR}/${measure}/${r}.nii.gz
done
tbss_non_FA RD

# Set up directories for longitudinal analysis of skeleton and images created by TBSS
for s in "${SUBS[@]}"
do
	mkdir ${CURRENT_ANALYSIS}/${s}_diffusion_longitudinal/tbss_skeleton
	mkdir ${CURRENT_ANALYSIS}/${s}_diffusion_longitudinal/tbss_image
done

# Split TBSS images so that the correct ones are associated with the correct subjects/timepoints
for measure in FA MD L1 RD
do
	fslsplit stats/all_${measure}_skeletonised stats/${measure}_skeleton -t
	fslsplit stats/all_${measure} stats/${measure}_image -t
	index=0
	for s in "${SUBS[@]}"
	do  
		fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${CURRENT_ANALYSIS}/${s}_diffusion_longitudinal/tbss_skeleton/${measure}_TP1
		fslmaths stats/${measure}_image`printf '%04d\n' $index` ${CURRENT_ANALYSIS}/${s}_diffusion_longitudinal/tbss_image/${measure}_TP1
		let index=$index+1
		fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/tbss_skeleton/${measure}_TP2
		fslmaths stats/${measure}_image`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/tbss_image/${measure}_TP2
		let index=$index+1
		fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/tbss_skeleton/${measure}_TP3
		fslmaths stats/${measure}_image`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/tbss_image/${measure}_TP3
		let index=$index+1
	done
done
cd $CWD


###### RUN MRTRIX ANALYSIS AND CREATE ROIS ###############################################

echo subject inc_les_vol_nooverlap exc_les_vol_nooverlap overlap_vol inc_les_count exc_lesion_count > ${TCKINFO_OUTPUT}
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do
	analysis_mrtrix.sh ${r} ${TREATMENT_SIDE[${index}]} ${CURRENT_ANALYSIS} ${TBSSDIR} ${ROIDIR} ${QADIR} ${CURRENT_ANALYSIS}/${r}/day1_lesion_2_pre_diff.nii.gz ${TCKINFO_OUTPUT}
	let index=$index+1
done


###### GET SUMMARY STATS IN ROIS #########################################################

OUTPREFIX=${CURRENT_ANALYSIS}/summary
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do 
	WORKDIR=${CURRENT_ANALYSIS}/${r}/mrtrix
	for tract in ${WORKDIR}/rtt_from_cortex ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap 
	do
		tract_name=`basename $tract`
		for roi in `ls -d ${tract}*2standard*`
		do
			for scan in TP1 TP2 TP3
			do
				for measure in FA MD RD L1
				do
					for type in image skeleton
					do
						echo ${SUBS[${index}]} $roi $scan $measure $type `fslstats ${CURRENT_ANALYSIS}/${SUBS[${index}]}_diffusion_longitudinal/tbss_${type}/${measure}_${scan} -k ${roi} -M -V` >> ${OUTPREFIX}_${tract_name}_${type}_output_mean_vol.txt
					done
				done
			done
		done
	done
	let i=$i+1
done


###### IMPORT TO EXCEL TO MAKE PIVOT TABLES ##############################################
# Get ROIs based on pre-treatment tracts in standard space
# Analyze on FA skeleton and all_FA images
# Check especially how inferior tracts look relative to skeleton, on contralateral and ipsilateral side (relative to lesion)

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis 

#OUTPUT FROM analysis_diffusion_step1B_run_tbss_preproc.sh
TBSSNAME=$1
TBSSDIR=/Users/erin/Desktop/Projects/MRGFUS/${TBSSNAME}
OUTNAME=mrtrix_170818
i=0

#EDIT TO INCLUDE ANY NEW SUBJECTS
subs=(9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD)
for MYSUB_TOTRACK in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455
do 
#echo $MYSUB_TOTRACK
	DIFFDIR=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion
	WORKDIR=${DIFFDIR}/mrtrix
	for tract in ${WORKDIR}/rtt_from_cortex_include_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_exclude_lesion_nooverlap ${WORKDIR}/rtt_from_cortex_clean
	do
#	echo $tract
		tract_name=`basename $tract`
		for roi in `ls -d ${tract}*2standard*`
		do
#		echo $roi
			for scan in TP1 TP2 TP3 TP4
			do
	#		echo $scan
				for measure in FA MD RD L1
				do
		#		echo $measure
					for type in image skeleton
					do
				#	echo $type
			#	echo ${ANALYSISDIR}/${subs[$i]}_diffusion_longitudinal/${TBSSNAME}_${type}/${measure}_${scan}.nii.gz 
						if [ -e ${ANALYSISDIR}/${subs[$i]}_diffusion_longitudinal/${TBSSNAME}_${type}/${measure}_${scan}.nii.gz ]
						then
				
							echo ${subs[$i]} $roi $scan $measure $type `fslstats ${ANALYSISDIR}/${subs[$i]}_diffusion_longitudinal/${TBSSNAME}_${type}/${measure}_${scan} -k ${roi} -M -V` >> ${ANALYSISDIR}/${OUTNAME}_${TBSSNAME}_${tract_name}_${type}_output_mean_vol.txt
						fi
					done
				done
			done
		done
	done
	let i=$i+1
done
#Every time a new session is acquired, we need to edit this file to include it and then re-run
#NOTE lesions are on the actual treated side i.e., not all flipped into one hemisphere, so it does not make sense to run TBSS stats on these. In general running TBSS on the whole skeleton probably will not make sense due to the different lesion locations UNLESS we are correlating with an outcome measure

#ALL OF THIS PREPROCESSING CAN OCCUR BEFORE BEDPOST IS FINISHED

#Input 1 - name of new TBSS folder (consider deleting old ones?)
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
TBSSNAME=$1

#order is very important!
RUNS=( 9001_SH-11644 9001_SH-11692 9001_SH-12271 9001_SH-14297 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9005_BG-13004 9005_BG-13126 9005_BG-13837 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 9013_JD-13455 9013_JD-13722 9013_JD-14227 )

SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD )

#currently only 4 or 3 will work, but easy enough to add more (see below)
NUM_SESS=( 4 3 3 3 3 3 3 3 )

mkdir ${MAINDIR}/${TBSSNAME}
for f in "${RUNS[@]}"
do
	cp ${ANALYSISDIR}/${f}/diffusion/dtifit_FA.nii.gz ${MAINDIR}/${TBSSNAME}/${f}_FA.nii.gz
done

cd ${MAINDIR}/${TBSSNAME}
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2

for measure in MD L1
do
	mkdir ${MAINDIR}/${TBSSNAME}/${measure}
	for f in "${RUNS[@]}"
	do
		cp ${ANALYSISDIR}/${f}/diffusion/dtifit_${measure}.nii.gz ${MAINDIR}/${TBSSNAME}/${measure}/${f}_FA.nii.gz
	done
	tbss_non_FA ${measure}
done

mkdir ${MAINDIR}/${TBSSNAME}/RD
for f in "${RUNS[@]}"
do
	fslmaths ${ANALYSISDIR}/${f}/diffusion/dtifit_L2 -add ${ANALYSISDIR}/${f}/diffusion/dtifit_L3 -div 2 ${ANALYSISDIR}/${f}/diffusion/RD
	cp ${ANALYSISDIR}/${f}/diffusion/RD.nii.gz ${MAINDIR}/${TBSSNAME}/RD/${f}_FA.nii.gz
done
tbss_non_FA RD

# Set up directories
for s in "${SUBS[@]}"
do
	if [ ! -d ${ANALYSISDIR}/${s}_diffusion_longitudinal ]; then
		mkdir ${ANALYSISDIR}/${s}_diffusion_longitudinal
	fi
	mkdir ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_skeleton
	mkdir ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_image
done

#split TBSS images so that the correct ones are associated with the correct subjects/timepoints
for measure in FA MD L1 RD
do
	fslsplit stats/all_${measure}_skeletonised stats/${measure}_skeleton -t
	fslsplit stats/all_${measure} stats/${measure}_image -t
	index=0
	for s in "${SUBS[@]}"
	do
	    
		fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_skeleton/${measure}_TP1
		fslmaths stats/${measure}_image`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_image/${measure}_TP1
		let index=$index+1
		fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_skeleton/${measure}_TP2
		fslmaths stats/${measure}_image`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_image/${measure}_TP2
		let index=$index+1
		fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_skeleton/${measure}_TP3
		fslmaths stats/${measure}_image`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_image/${measure}_TP3
		let index=$index+1
		if [ ${NUM_SESS[$index]} -eq 4 ]; then 
			fslmaths stats/${measure}_skeleton`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_skeleton/${measure}_TP4
			fslmaths stats/${measure}_image`printf '%04d\n' $index` ${ANALYSISDIR}/${s}_diffusion_longitudinal/${TBSSNAME}_image/${measure}_TP4			
			let index=$index+1
		fi
	done
done
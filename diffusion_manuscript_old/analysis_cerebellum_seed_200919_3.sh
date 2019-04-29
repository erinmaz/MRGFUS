# Sep 20, 2018
# Check systematically whether we can track from contralesional cerebellum
MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
#LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
REG_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_310818
CURRENT_ANALYSIS=${MAINDIR}/analysis_cerebellum_seed_200918
#TCKINFO_OUTPUT=${CURRENT_ANALYSIS}/tckinfo_output.txt
#T1_2_DIFF=T1_2_diff_bbr.mat 
#OUTFOLDER=mrtrix
OUTFILE=${CURRENT_ANALYSIS}/summary.txt

SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD )

TREATMENT_SIDE=( L L L R L R L L )

#RUNS=( 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12126 9004_EP-12203 9004_EP-12955 9005_BG-13004 9005_BG-13126 9005_BG-13837 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 9013_JD-13455 9013_JD-13722 9013_JD-14227 )

PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455 )
DAY1_RUNS=( 9001_SH-11692 9002_RA-11833 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9013_JD-13722 )
MONTH3_RUNS=( 9001_SH-12271 9002_RA-12388 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-13055 9009_CRB-13623 9013_JD-14227 )
mkdir ${CURRENT_ANALYSIS}


###### RUN MRTRIX ANALYSIS AND CREATE ROIS ###############################################

index=0
for r in "${PRETREATMENT_RUNS[@]}"
do

WORKDIR=${CURRENT_ANALYSIS}/${r}


if [ "${TREATMENT_SIDE[${index}]}" == "L" ]; then
	OTHERSIDE=R
else
	OTHERSIDE=L
fi


WARP_STDtoT1=${REG_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp_inv
MAT_T1todiff=${QADIR}/${r}/diffusion/xfms/T1_2_diff_bbr.mat


THALAMUS_MASK=${ROIDIR}/thalamus_${TREATMENT_SIDE[${index}]}
THALAMUS_MASK_NAME=`basename ${THALAMUS_MASK}`

RED_MASK=${ROIDIR}/RN_${TREATMENT_SIDE[${index}]}
RED_MASK_NAME=`basename ${RED_MASK}`

CC_MASK=${ROIDIR}/CC
CC_MASK_NAME=`basename ${CC_MASK}`

SCP_MASK=${ROIDIR}/superior_cerebellar_peduncle_${OTHERSIDE}
SCP_MASK_NAME=`basename ${SCP_MASK}`

applywarp -w ${WARP_STDtoT1} --postmat=${MAT_T1todiff} -i ${CC_MASK} -o ${WORKDIR}/${CC_MASK_NAME} --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped
fslmaths ${WORKDIR}/${CC_MASK_NAME} -bin ${WORKDIR}/${CC_MASK_NAME} 

applywarp  -w ${WARP_STDtoT1} --postmat=${MAT_T1todiff} -i ${SCP_MASK} -o ${WORKDIR}/${SCP_MASK_NAME} --interp=trilinear -r ${QADIR}/${r}/diffusion/mean_b0_unwarped

fslmaths ${WORKDIR}/${SCP_MASK_NAME} -bin  ${WORKDIR}/${SCP_MASK_NAME}

# GENERATE STREAMLINES
tckedit -include ${WORKDIR}/${SCP_MASK_NAME}.nii.gz ${WORKDIR}/drtt_exclude_cc.tck ${WORKDIR}/drtt_exclude_cc_include_scp.tck -force

# CONVERT STREAMLINES TO NII
tckmap -template ${QADIR}/${r}/diffusion/mean_b0_unwarped.nii.gz ${WORKDIR}/drtt_exclude_cc_include_scp.tck ${WORKDIR}/drtt_exclude_cc_include_scp.nii.gz -force

red_streamlines=`fslstats ${WORKDIR}/drtt_exclude_cc_include_scp -k ${WORKDIR}/${RED_MASK_NAME} -R`
thalamus_streamlines=`fslstats ${WORKDIR}/drtt_exclude_cc_include_scp -k ${WORKDIR}/${THALAMUS_MASK_NAME} -R`

fsleyes ${QADIR}/${r}/diffusion/mean_b0_unwarped  ${WORKDIR}/${SCP_MASK_NAME} ${WORKDIR}/drtt_exclude_cc_include_scp &

echo ${r} ${red_streamlines} ${thalamus_streamlines} >> ${CURRENT_ANALYSIS}/summary.txt
let index=$index+1
done



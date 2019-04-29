MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
CURRENT_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_310818
TCKINFO_OUTPUT=${CURRENT_ANALYSIS}/tckinfo_output.txt




PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455 )
for i in "${PRETREATMENT_RUNS[@]}"
do
fsleyes ${QADIR}/${i}/diffusion/mean_b0_unwarped ${CURRENT_ANALYSIS}/${i}/rtt_from_cortex_bin
done
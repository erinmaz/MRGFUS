MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYSUB=$1
MYSUB_PRE=${1}-${2}
MYSUB_DAY1=${1}-${3}
MYSUB_3M=${1}-${4}
TREATMENTSIDE=$5
DIFFDIR=${MAINDIR}/${MYSUB_PRE}/diffusion
WORKDIR=${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix
SCRIPTSDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts
CEREBELLUM_MASK=${SCRIPTSDIR}/rois_standardspace/mni_prob_Cerebellum_thr10_binv_1mm
TBSSDIR=/Users/erin/Desktop/Projects/MRGFUS/tbss_160718

analysis_longitudinal_all_T1s_in_pre_space.sh ${MYSUB} $2 $3 $4

#in longitudal_xfms folder for each participant
day1_to_pre_mat=mT1_brain_day1_2_pre_6dof.mat
month3_to_pre_mat=mT1_brain_month3_2_pre_6dof.mat

#in diffusion/xfms for each session
diff_to_T1_mat=diff_2_T1_bbr.mat 

CEREBELLUM_NAME=`basename ${CEREBELLUM_MASK}`

#want to do all the analyses in T1 pre space
convert_xfm -omat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_day1_2_T1_pre.mat -concat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/${day1_to_pre_mat} ${MAINDIR}/${MYSUB_DAY1}/diffusion/xfms/${diff_to_T1_mat} 

convert_xfm -omat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_3M_2_T1_pre.mat -concat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/${month3_to_pre_mat} ${MAINDIR}/${MYSUB_3M}/diffusion/xfms/${diff_to_T1_mat} 

OUTDIR=${MAINDIR}/${MYSUB}_diffusion_longitudinal/dti_in_pre_T1_space_210818
mkdir ${OUTDIR}

if [ ! -e ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean.tck ]; then
cp ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion.tck ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean.tck
fi

if [ ! -e ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion_clean.tck ]; then
cp ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion.tck ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion_clean.tck
fi

invwarp -w ${TBSSDIR}/FA/${MYSUB_PRE}_FA_FA_to_target_warp -r ${DIFFDIR}/mean_b0_unwarped -o ${TBSSDIR}/FA/${MYSUB_PRE}_FA_FA_to_target_warp_inv
applywarp -i ${CEREBELLUM_MASK} -r ${DIFFDIR}/mean_b0_unwarped -w ${TBSSDIR}/FA/${MYSUB_PRE}_FA_FA_to_target_warp_inv -o ${WORKDIR}/${CEREBELLUM_NAME}2diff --interp=nn

tckedit -mask ${WORKDIR}/${CEREBELLUM_NAME}2diff.nii.gz ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean.tck ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean_nocerebellum.tck -force
tckedit -mask ${WORKDIR}/${CEREBELLUM_NAME}2diff.nii.gz ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion_clean.tck ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion_clean_nocerebellum.tck -force

for image in FA MD L1 
do
flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP1
flirt -in ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_day1_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP2
flirt -in ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_3M_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP3
done

for image in RD 
do
flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/${image} -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP1
flirt -in ${MAINDIR}/${MYSUB_DAY1}/diffusion/${image} -applyxfm -init ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_day1_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP2
flirt -in ${MAINDIR}/${MYSUB_3M}/diffusion/${image} -applyxfm -init ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_3M_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP3
done
 
warpinit ${MAINDIR}/${MYSUB_PRE}/anat/T1.nii.gz ${WORKDIR}/initial_warp-[].nii -force
transformconvert ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/diff_2_T1_bbr.mat ${MAINDIR}/${MYSUB_PRE}/diffusion/mean_b0_unwarped.nii.gz ${MAINDIR}/${MYSUB_PRE}/anat/T1.nii.gz flirt_import ${WORKDIR}/diff_2_T1_bbr.mrtrix -force
for i in 0 1 2; do mrtransform ${WORKDIR}/initial_warp-${i}.nii -linear ${WORKDIR}/diff_2_T1_bbr.mrtrix ${WORKDIR}/flirt2tck-${i}.nii.gz -template ${MAINDIR}/${MYSUB_PRE}/anat/T1.nii.gz -force ; done
warpcorrect ${WORKDIR}/flirt2tck-[].nii.gz  ${WORKDIR}/flirt2tck.mif -force
tcktransform ${WORKDIR}/rtt_from_cortex_include_lesion_clean_nocerebellum.tck ${WORKDIR}/flirt2tck.mif ${WORKDIR}/rtt_from_cortex_include_lesion_clean_nocerebellum_T1space.tck -force
tcktransform ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean_nocerebellum.tck ${WORKDIR}/flirt2tck.mif ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean_nocerebellum_T1space.tck -force
cd ${WORKDIR}
mrview ${OUTDIR}/FA_TP1.nii.gz ${OUTDIR}/FA_TP2.nii.gz ${OUTDIR}/FA_TP3.nii.gz 
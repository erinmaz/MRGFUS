MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYSUB=$1
MYSUB_PRE=${1}-${2}
MYSUB_DAY1=${1}-${3}
MYSUB_3M=${1}-${4}
WORKDIR=${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix

#analysis_longitudinal_all_T1s_in_pre_space.sh ${MYSUB} $2 $3 $4

#in longitudal_xfms folder for each participant
day1_to_pre_mat=mT1_day1_2_pre_6dof.mat
month3_to_pre_mat=mT1_month3_2_pre_6dof.mat

#in diffusion/xfms for each session
diff_to_T1_mat=diff_2_T1_bbr.mat 

#want to do all the analyses in T1 pre space
convert_xfm -omat ${MAINDIR}/9001_SH_longitudinal_xfms/diff_day1_2_T1_pre.mat -concat ${MAINDIR}/9001_SH_longitudinal_xfms/${day1_to_pre_mat} ${MAINDIR}/${MYSUB_DAY1}/diffusion/xfms/${diff_to_T1_mat} 

convert_xfm -omat ${MAINDIR}/9001_SH_longitudinal_xfms/diff_3M_2_T1_pre.mat -concat ${MAINDIR}/9001_SH_longitudinal_xfms/${month3_to_pre_mat} ${MAINDIR}/${MYSUB_3M}/diffusion/xfms/${diff_to_T1_mat} 

OUTDIR=${MAINDIR}/${MYSUB}_diffusion_longitudinal/dti_in_pre_T1_space
mkdir ${OUTDIR}

if [ -e ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean.tck ]; then
cp ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion.tck ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_include_lesion_clean.tck
fi

if [ -e ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion_clean.tck ]; then
cp ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion.tck ${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix/rtt_from_cortex_exclude_lesion_clean.tck
fi

for image in FA MD L1 
do
flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP1
flirt -in ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/9001_SH_longitudinal_xfms/diff_day1_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP2
flirt -in ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/9001_SH_longitudinal_xfms/diff_3M_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP3
done

image=RD
flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/${image} -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP1
flirt -in ${MAINDIR}/${MYSUB_DAY1}/diffusion/${image} -applyxfm -init ${MAINDIR}/9001_SH_longitudinal_xfms/diff_day1_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP2
flirt -in ${MAINDIR}/${MYSUB_3M}/diffusion/${image} -applyxfm -init ${MAINDIR}/9001_SH_longitudinal_xfms/diff_3M_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP3

warpinit ${MAINDIR}/${MYSUB_PRE}/anat/T1.nii.gz ${WORKDIR}/initial_warp-[].nii -force
transformconvert ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/diff_2_T1_bbr.mat ${MAINDIR}/${MYSUB_PRE}/diffusion/mean_b0_unwarped.nii.gz ${MAINDIR}/${MYSUB_PRE}/anat/T1.nii.gz flirt_import ${WORKDIR}/diff_2_T1_bbr.mrtrix -force
for i in 0 1 2; do mrtransform ${WORKDIR}/initial_warp-${i}.nii -linear ${WORKDIR}/diff_2_T1_bbr.mrtrix ${WORKDIR}/flirt2tck-${i}.nii.gz -template ${MAINDIR}/${MYSUB_PRE}/anat/T1.nii.gz -force ; done
warpcorrect ${WORKDIR}/flirt2tck-[].nii.gz  ${WORKDIR}/flirt2tck.mif -force
tcktransform ${WORKDIR}/rtt_from_cortex_include_lesion_clean.tck ${WORKDIR}/flirt2tck.mif ${WORKDIR}/rtt_from_cortex_include_lesion_clean_T1space.tck -force
tcktransform ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean.tck ${WORKDIR}/flirt2tck.mif ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean_T1space.tck -force


#FOR 9001_SH - manually read coordinates from MRtrix from level of dentate (ish) to where things started to look really thin towards cortex

#probably should get warps to work and do it in standard space, although doing it per subject is nice too.
tckresample -line 100 -18,11,-41 -11,31,50 rtt_from_cortex_include_lesion_clean_T1space.tck rtt_from_cortex_include_lesion_clean_T1space_line.tck


#retry tckresample with steps from lesion coordinates
#tckresample -step_size 2 ${WORKDIR}/rtt_from_cortex_include_lesion_clean_T1space.tck ${WORKDIR}/rtt_from_cortex_include_lesion_clean_T1space_2m.tck -force 
#tckresample -step_size 2 ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean_T1space.tck ${WORKDIR}/rtt_from_cortex_exclude_lesion_clean_T1space_2m.tck -force
  
for image in FA MD L1 RD 
do
for TP in TP1 TP2 TP3
do
for tract in include exclude
do
tcksample ${WORKDIR}/rtt_from_cortex_${tract}_lesion_clean_T1space_2m.tck ${OUTDIR}/${image}_${TP}.nii.gz ${OUTDIR}/${tract}_lesion_${image}_${TP}.txt -force
sed "s/^[ \t]*//" ${OUTDIR}/${tract}_lesion_${image}_${TP}.txt > ${OUTDIR}/${tract}_lesion_${image}_${TP}_remove_leading_white.txt
done
done
done

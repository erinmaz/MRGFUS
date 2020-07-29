MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYSUB=$1
MYSUB_PRE=${1}-${2}
MYSUB_DAY1=${1}-${3}
MYSUB_3M=${1}-${4}

DIFFDIR=${MAINDIR}/${MYSUB_PRE}/diffusion

SCRIPTSDIR=/Users/erin/Desktop/Projects/MRGFUS/scripts

#analysis_longitudinal_all_T1s_in_pre_space.sh ${MYSUB} $2 $3 $4

#in longitudal_xfms folder for each participant
day1_to_pre_mat=T1_brain_day1_2_pre_6dof.mat
month3_to_pre_mat=T1_brain_month3_2_pre_6dof.mat

#in diffusion/xfms for each session
diff_to_T1_mat=diff_2_T1_bbr.mat 

#want to do all the analyses in T1 pre space
convert_xfm -omat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_day1_2_T1_pre.mat -concat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/${day1_to_pre_mat} ${MAINDIR}/${MYSUB_DAY1}/diffusion/xfms/${diff_to_T1_mat} 

convert_xfm -omat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_3M_2_T1_pre.mat -concat ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/${month3_to_pre_mat} ${MAINDIR}/${MYSUB_3M}/diffusion/xfms/${diff_to_T1_mat} 

mkdir ${MAINDIR}/${MYSUB}_diffusion_longitudinal
OUTDIR=${MAINDIR}/${MYSUB}_diffusion_longitudinal/dti_in_pre_T1_space_220219
mkdir ${OUTDIR}

if [ ! -f ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_RD.nii.gz ]; then
fslmaths ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_L2 -add ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_L3 -div 2 ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_RD
fi

if [ ! -f ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_RD.nii.gz ]; then
fslmaths ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_L2 -add ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_L3 -div 2 ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_RD
fi

if [ ! -f ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_RD.nii.gz ]; then
fslmaths ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_L2 -add ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_L3 -div 2 ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_RD
fi

for image in FA MD L1 RD
do
flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP1
flirt -in ${MAINDIR}/${MYSUB_DAY1}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_day1_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP2
flirt -in ${MAINDIR}/${MYSUB_3M}/diffusion/dtifit_${image} -applyxfm -init ${MAINDIR}/${MYSUB}_longitudinal_xfms_T1/diff_3M_2_T1_pre.mat -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${OUTDIR}/${image}_TP3
done

#flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/Kwon_ROIs/dentate_R_dil_thalterm/fdt_paths -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${MAINDIR}/${MYSUB_PRE}/diffusion/Kwon_ROIs/dentate_R_dil_thalterm/fdt_paths2T1

#flirt -in ${MAINDIR}/${MYSUB_PRE}/diffusion/Kwon_ROIs/dentate_L_dil_thalterm/fdt_paths -applyxfm -init ${MAINDIR}/${MYSUB_PRE}/diffusion/xfms/${diff_to_T1_mat} -ref ${MAINDIR}/${MYSUB_PRE}/anat/T1 -out ${MAINDIR}/${MYSUB_PRE}/diffusion/Kwon_ROIs/dentate_L_dil_thalterm/fdt_paths2T1

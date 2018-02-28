#!/bin/bash

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

#################### SAVE SCRIPT ###################################
#save a copy of this script to the analysis dir, so I know what I've run
#cp $0 ${ANALYSISDIR}/${MYSUB}/.

#subject IDs as input
MYSUB=$1
MYSUB_PRE=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}

#full path of standard2highres_warp  (pre)
MYREG_highres=$4

#full path of highres2diff (pre)
MYREG_diff=$5

ROIS_standard=(/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvox_sub_thalamus_L_final.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_OccipitalLobe_thr25_bin_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_TemporalLobe_thr25_bin_L.nii.gz
/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_FrontalLobe_thr25_bin_L.nii.gz
/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_ParietalLobe_thr25_bin_L.nii.gz)

#NEED TO MASK THRESE WITH GRAY MATTER?
ROIS_freesurfer=(lh.BA4_clean lh.BA6_clean lh.BA123_clean)
DIFFDIR=${ANALYSISDIR}/${MYSUB_PRE}/diffusion
FREESURFER_DIR=${ANALYSISDIR}/${MYSUB_PRE}/freesurfer_output
OUTPUT_ROI=$DIFFDIR/rois_classification_freesurfer
OUTPUT_CLASS=${DIFFDIR}.bedpostX/thalamus_classification_freesurfer


#need to register freesurfer T1 to my T1
regdir=`dirname ${MYREG_highres}`
if [ ! -f ${MYREG_highres} ]
then
	invwarp -w ${regdir}/highres2standard_warp -o ${MYREG_highres} -r ${regdir}/highres
fi

mkdir ${OUTPUT_ROI}
mymasks=""
for i in `seq 0 4`
do
MASKNAME=`basename ${ROIS_standard[$i]} .nii.gz`
applywarp -i ${ROIS_standard[$i]} -r ${DIFFDIR}/nodif_brain -o ${OUTPUT_ROI}/$MASKNAME -w ${MYREG_highres} --postmat=${MYREG_diff} --interp=nn
mymasks=`echo $mymasks ${OUTPUT_ROI}/$MASKNAME`
#applywarp -i ${ROIS[$i]} -r ${ANALYSISDIR}/${MYSUB_PRE}/anat/mT1 -o ${OUTPUT_ROI}/${MASKNAME}_T1 -w ${MYREG_highres}  
#--interp=nn
#mymasks=`echo $mymasks ${OUTPUT_ROI}/${MASKNAME}_T1`
done

for i in `seq 0 2`
do
MASKNAME=`basename ${ROIS_freesurfer[$i]} .nii.gz`
applywarp -i ${FREESURFER_DIR}/${ROIS_freesurfer[$i]} -r ${DIFFDIR}/nodif_brain -o ${OUTPUT_ROI}/$MASKNAME --postmat=${MYREG_diff} --interp=nn
mymasks=`echo $mymasks ${OUTPUT_ROI}/$MASKNAME`
done

#thresholded to make thickness about the same as freesurfer masks, by eye on 9001_SH in left hemisphere on T1
fslmaths ${ANALYSISDIR}/${MYSUB_PRE}/anat/c1T1 -thr .1 -bin ${ANALYSISDIR}/${MYSUB_PRE}/anat/c1T1_thr0.1_bin
applywarp -i ${ANALYSISDIR}/${MYSUB_PRE}/anat/c1T1_thr0.1_bin -r ${DIFFDIR}/nodif_brain -o ${OUTPUT_ROI}/c1T1_thr0.01_bin --postmat=${MYREG_diff} --interp=nn

fslmaths ${OUTPUT_ROI}/mni_prob_FrontalLobe_thr25_bin_L -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin  ${OUTPUT_ROI}/mni_prob_FrontalLobe_thr25_bin_L_gm
fslmaths ${OUTPUT_ROI}/mni_prob_ParietalLobe_thr25_bin_L -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin  ${OUTPUT_ROI}/mni_prob_ParietalLobe_thr25_bin_L_gm
fslmaths ${OUTPUT_ROI}/mni_prob_OccipitalLobe_thr25_bin_L -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin  ${OUTPUT_ROI}/mni_prob_OccipitalLobe_thr25_bin_L_gm
fslmaths ${OUTPUT_ROI}/mni_prob_TemporalLobe_thr25_bin_L -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin  ${OUTPUT_ROI}/mni_prob_TemporalLobe_thr25_bin_L_gm

fslmaths ${OUTPUT_ROI}/lh.BA4_clean -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin ${OUTPUT_ROI}/lh.BA4_clean_gm 
fslmaths ${OUTPUT_ROI}/lh.BA6_clean -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin ${OUTPUT_ROI}/lh.BA6_clean_gm 
fslmaths ${OUTPUT_ROI}/lh.BA123_clean -mas ${OUTPUT_ROI}/c1T1_thr0.01_bin ${OUTPUT_ROI}/lh.BA123_clean_gm 

fslmaths ${OUTPUT_ROI}/mni_prob_FrontalLobe_thr25_bin_L_gm -sub ${OUTPUT_ROI}/lh.BA4_clean -sub ${OUTPUT_ROI}/lh.BA6_clean -sub ${OUTPUT_ROI}/lh.BA123_clean -thr 0 -bin ${OUTPUT_ROI}/mni_prob_FrontalLobe_L_gm_remainder

fslmaths ${OUTPUT_ROI}/mni_prob_ParietalLobe_thr25_bin_L_gm -sub ${OUTPUT_ROI}/lh.BA123_clean -sub ${OUTPUT_ROI}/lh.BA4_clean -sub ${OUTPUT_ROI}/lh.BA6_clean -thr 0 -bin ${OUTPUT_ROI}/mni_prob_ParietalLobe_L_gm_remainder

mkdir -p ${OUTPUT_CLASS}
echo ${OUTPUT_ROI}/mni_prob_FrontalLobe_L_gm_remainder >> ${OUTPUT_CLASS}/targets.txt
echo ${OUTPUT_ROI}/mni_prob_ParietalLobe_L_gm_remainder >> ${OUTPUT_CLASS}/targets.txt
echo ${OUTPUT_ROI}/mni_prob_OccipitalLobe_thr25_bin_L_gm >> ${OUTPUT_CLASS}/targets.txt
echo ${OUTPUT_ROI}/mni_prob_TemporalLobe_thr25_bin_L_gm >> ${OUTPUT_CLASS}/targets.txt
echo ${OUTPUT_ROI}/lh.BA4_clean_gm >> ${OUTPUT_CLASS}/targets.txt
echo ${OUTPUT_ROI}/lh.BA6_clean_gm >> ${OUTPUT_CLASS}/targets.txt
echo ${OUTPUT_ROI}/lh.BA123_clean_gm >> ${OUTPUT_CLASS}/targets.txt

/usr/local/fsl/bin/probtrackx2  -x ${OUTPUT_ROI}/harvox_sub_thalamus_L_final.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${DIFFDIR}.bedpostX/merged -m ${DIFFDIR}.bedpostX/nodif_brain_mask  --dir=${OUTPUT_CLASS} --targetmasks=${OUTPUT_CLASS}/targets.txt --os2t 

find_the_biggest ${OUTPUT_CLASS}/seeds_to_lh.BA4_clean_gm.nii.gz ${OUTPUT_CLASS}/seeds_to_lh.BA6_clean_gm.nii.gz ${OUTPUT_CLASS}/seeds_to_lh.BA123_clean_gm.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_FrontalLobe_L_gm_remainder.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_ParietalLobe_L_gm_remainder.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_OccipitalLobe_thr25_bin_L_gm.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_TemporalLobe_thr25_bin_L_gm ${OUTPUT_CLASS}/find_the_biggest

convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_bbr_6dof_2_mT1_day1.mat -inverse ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr_6dof.mat

flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_bbr_6dof_2_mT1_day1.mat -in ${OUTPUT_CLASS}/find_the_biggest -ref ${ANALYSISDIR}/${MYSUB_DAY1}/anat/mT1 -out ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/pre_thalamus_classification_freesurfer2_day1_T1 -interp nearestneighbour

applywarp -w ${regdir}/highres2standard_warp --premat=${DIFFDIR}/xfms/diff_2_T1_bbr.mat -i ${OUTPUT_CLASS}/find_the_biggest -r ${regdir}/standard -o ${OUTPUT_CLASS}/find_the_biggest2standard --interp=nn
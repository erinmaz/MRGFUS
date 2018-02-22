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

ROIS_freesurfer=(lh.BA4_bin_nooverlap lh.BA6_bin_nooverlap lh.BA123_bin_nooverlap)
DIFFDIR=${ANALYSISDIR}/${MYSUB_PRE}/diffusion
FREESURFER_DIR=${ANALYSISDIR}/${MYSUB_PRE}/freesurfer_output
OUTPUT_ROI=$DIFFDIR/rois_classification_freesurfer
OUTPUT_CLASS=${DIFFDIR}.bedpostX/thalamus_classification_freesurfer


#need to register freesurfer T1 to my T1

if [ ! -f ${MYREG_highres} ]
then
	regdir=`dirname ${MYREG_highres}`
	invwarp -w ${regdir}/highres2standard_warp -o ${MYREG_highres} -r ${regdir}/highres
fi

mkdir ${OUTPUT_ROI}
mymasks=""
for i in `seq 0 4`
do
MASKNAME=`basename ${ROIS_standard[$i]} .nii.gz`
applywarp -i ${ROIS_standard[$i]} -r ${DIFFDIR}/nodif_brain -o ${OUTPUT_ROI}/$MASKNAME -w ${MYREG_highres} --postmat=${MYREG_diff} 
#--interp=nn
mymasks=`echo $mymasks ${OUTPUT_ROI}/$MASKNAME`
#applywarp -i ${ROIS[$i]} -r ${ANALYSISDIR}/${MYSUB_PRE}/anat/mT1 -o ${OUTPUT_ROI}/${MASKNAME}_T1 -w ${MYREG_highres}  
#--interp=nn
#mymasks=`echo $mymasks ${OUTPUT_ROI}/${MASKNAME}_T1`
done

for i in `seq 0 2`
do
MASKNAME=`basename ${ROIS_freesurfer[$i]} .nii.gz`
applywarp -i ${FREESURFER_DIR}/${ROIS_freesurfer[$i]} -r ${DIFFDIR}/nodif_brain -o ${OUTPUT_ROI}/$MASKNAME --postmat=${MYREG_diff} 
mymasks=`echo $mymasks ${OUTPUT_ROI}/$MASKNAME`
done
fsleyes ${DIFFDIR}/nodif_brain $mymasks

fslmaths ${OUTPUT_ROI}/mni_prob_FrontalLobe_thr25_bin_L -sub ${FREESURFER_DIR}/lh.BA4_bin_nooverlap -sub ${FREESURFER_DIR}/lh.BA6_bin_nooverlap -sub -thr 


#fsleyes ${DIFFDIR}/nodif_brain $mymasks
fsleyes ${ANALYSISDIR}/${MYSUB_PRE}/anat/mT1 $mymasks

rm -rf ${OUTPUT_CLASS}
mkdir -p ${OUTPUT_CLASS}
/usr/local/fsl/bin/probtrackx2  -x ${OUTPUT_ROI}/harvox_sub_thalamus_L_final.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${DIFFDIR}.bedpostX/merged -m ${DIFFDIR}.bedpostX/nodif_brain_mask  --dir=${OUTPUT_CLASS} --targetmasks=${OUTPUT_CLASS}/targets.txt --os2t 

find_the_biggest ${OUTPUT_CLASS}/seeds_to_harvardoxford-cortical_prob_Juxtapositional_Lobule_Cortex_thr25_bin_L.nii.gz ${OUTPUT_CLASS}/seeds_to_harvardoxford-cortical_prob_Postcentral_Gyrus_thr25_bin_L.nii.gz ${OUTPUT_CLASS}/seeds_to_harvardoxford-cortical_prob_Precentral_Gyrus_thr25_bin_L.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_FrontalLobe_thr25_bin_nomotor_L.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_OccipitalLobe_thr25_bin_L.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_ParietalLobe_thr25_bin_nosensory_L.nii.gz ${OUTPUT_CLASS}/seeds_to_mni_prob_TemporalLobe_thr25_bin_L.nii.gz ${OUTPUT_CLASS}/thalamus_classification 

convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_bbr_6dof_2_mT1_day1.mat -inverse ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr_6dof.mat

flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_bbr_6dof_2_mT1_day1.mat -in ${OUTPUT_CLASS}/thalamus_classification -ref ${ANALYSISDIR}/${MYSUB_DAY1}/anat/mT1 -out ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/pre_thalamus_classification_2_day1_T1 -interp nearestneighbour


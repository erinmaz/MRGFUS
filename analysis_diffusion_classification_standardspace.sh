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

ROIS=(/Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvox_sub_thalamus_L_final.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Juxtapositional_Lobule_Cortex_thr25_bin_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Postcentral_Gyrus_thr25_bin_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/harvardoxford-cortical_prob_Precentral_Gyrus_thr25_bin_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_FrontalLobe_thr25_bin_nomotor_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_OccipitalLobe_thr25_bin_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_ParietalLobe_thr25_bin_nosensory_L.nii.gz /Users/erin/Desktop/Projects/MRGFUS/scripts/rois_standardspace/mni_prob_TemporalLobe_thr25_bin_L.nii.gz)

DIFFDIR=${ANALYSISDIR}/${MYSUB_PRE}/diffusion

if [ ! -f ${MYREG_highres} ]
then
	regdir=`dirname ${MYREG_highres}`
	invwarp -w ${regdir}/highres2standard_warp -o ${MYREG_highres} -r ${regdir}/highres
fi

mkdir $DIFFDIR/rois_classification
mymasks=""
for i in `seq 0 7`
do
MASKNAME=`basename ${ROIS[$i]} .nii.gz`
#applywarp -i ${ROIS[$i]} -r ${DIFFDIR}/nodif_brain -o $DIFFDIR/rois_classification/$MASKNAME -w ${MYREG_highres} --postmat=${MYREG_diff} --interp=nn
#mymasks=`echo $mymasks $DIFFDIR/rois_classification/$MASKNAME`
#applywarp -i ${ROIS[$i]} -r ${ANALYSISDIR}/${MYSUB_PRE}/anat/mT1 -o $DIFFDIR/rois_classification/${MASKNAME}_T1 -w ${MYREG_highres}  --interp=nn
mymasks=`echo $mymasks $DIFFDIR/rois_classification/${MASKNAME}_T1`
done
#fsleyes ${DIFFDIR}/nodif_brain $mymasks
fsleyes ${ANALYSISDIR}/${MYSUB_PRE}/anat/mT1 $mymasks

rm -rf ${DIFFDIR}.bedpostX/thalamus_classification
mkdir -p ${DIFFDIR}.bedpostX/thalamus_classification
/usr/local/fsl/bin/probtrackx2  -x ${DIFFDIR}/rois_classification/harvox_sub_thalamus_L_final.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s ${DIFFDIR}.bedpostX/merged -m ${DIFFDIR}.bedpostX/nodif_brain_mask  --dir=${DIFFDIR}.bedpostX/thalamus_classification --targetmasks=${DIFFDIR}.bedpostX/thalamus_classification/targets.txt --os2t 

find_the_biggest ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_harvardoxford-cortical_prob_Juxtapositional_Lobule_Cortex_thr25_bin_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_harvardoxford-cortical_prob_Postcentral_Gyrus_thr25_bin_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_harvardoxford-cortical_prob_Precentral_Gyrus_thr25_bin_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_mni_prob_FrontalLobe_thr25_bin_nomotor_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_mni_prob_OccipitalLobe_thr25_bin_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_mni_prob_ParietalLobe_thr25_bin_nosensory_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/seeds_to_mni_prob_TemporalLobe_thr25_bin_L.nii.gz ${DIFFDIR}.bedpostX/thalamus_classification/thalamus_classification 

convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_bbr_6dof_2_mT1_day1.mat -inverse ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr_6dof.mat

flirt -applyxfm -init ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/diff_pre_bbr_6dof_2_mT1_day1.mat -in ${DIFFDIR}.bedpostX/thalamus_classification/thalamus_classification -ref ${ANALYSISDIR}/${MYSUB_DAY1}/anat/mT1 -out ${ANALYSISDIR}/${MYSUB}_diffusion_longitudinal/pre_thalamus_classification_2_day1_T1 -interp nearestneighbour


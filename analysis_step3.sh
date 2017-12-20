#!/bin/bash
PREPROCFEAT=PUrs_fcpreproc.feat

MYSUB=$1

#full path of mask
MYMASK=$2

#full path of pre-processed feat
MYFEAT=$3

ANALYSISDIR=/home/erinmazerolle/MRGFUS/analysis
FUNCDIR=${ANALYSISDIR}/${MYSUB}/fmri

MASKNAME=`basename $MYMASK`

#run preproc feat
sed 's:MYSUB:'${MYSUB}':g' ${SCRIPTSDIR}/fcpreproc.fsf > ${FUNCDIR}/fcpreproc.fsf
feat ${FUNCDIR}/fcpreproc.fsf

#seed based functional connectivity analysis

invwarp -w ${FUNCDIR}/PUrs_fcpreproc.feat/reg/highres2standard_warp -o ${FUNCDIR}/PUrs_fcpreproc.feat/reg/standard2highres_warp -r ${FUNCDIR}/PUrs_fcpreproc.feat/reg/highres

applywarp -i /home/erinmazerolle/MRGFUS/scripts/harvardoxford-subcortical_prob_Lateral_Ventricles -w ${FUNCDIR}/${PREPROCFEAT}/reg/standard2highres_warp --postmat=${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.feat/reg/highres2example_func.mat -r ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.feat/reg/example_func -o ${FUNCDIR}/harvardoxford-subcortical_prob_Lateral_Ventricles2func --interp=nn

fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.feat/reg/example_func ${FUNCDIR}/harvardoxford-subcortical_prob_Lateral_Ventricles2func

fslmeants -i ${FUNCDIR}/${PREPROCFEAT}/filtered_func_data -m ${MYMASK} -o ${FUNCDIR}/${PREPROCFEAT}/${MASKNAME}_ts.txt --eig
fslmeants -i ${FUNCDIR}/${PREPROCFEAT}/filtered_func_data -m ${FUNCDIR}/${PREPROCFEAT}/mask -o ${FUNCDIR}/${PREPROCFEAT}/global_ts.txt --eig
fslmeants -i ${FUNCDIR}/${PREPROCFEAT}/filtered_func_data -m ${FUNCDIR}/harvardoxford-subcortical_prob_Lateral_Ventricles2func -o ${FUNCDIR}/${PREPROCFEAT}/lateral_ventricles_ts.txt --eig

sed 's:MYSUB:'${MYSUB}':g' ${SCRIPTSDIR}/fc.fsf > ${FUNCDIR}/fc_${MASKNAME}.fsf
sed -i '' 's:MYTIMESERIES:${MYFEAT}/${MASKNAME}_ts.txt:g' ${FUNCDIR}/fc_${MASKNAME}.fsf





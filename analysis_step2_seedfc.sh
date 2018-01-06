#!/bin/bash
#seed based functional connectivity analysis

MYSUB=$1

#full path of mask (in func space)
MYMASK=$2

#full path of pre-processed feat (rs.feat in my current pipeline)
MYFEAT=$3

#full path of reg folder to use (rs_reg.feat/reg in my current pipeline)
MYREG=$4

ANALYSISDIR=~/Deskop/Projects/MRGFUS/analysis
FUNCDIR=${ANALYSISDIR}/${MYSUB}/fmri
XFMSDIR=${ANALYSISDIR}/${MYSUB}/xfms
MASKNAME=`basename $MYMASK`

#get lateral ventricles in func space for nuisance regressor
invwarp -w ${FUNCDIR}/PUrs_fcpreproc.feat/reg/highres2standard_warp -o ${FUNCDIR}/PUrs_fcpreproc.feat/reg/standard2highres_warp -r ${FUNCDIR}/PUrs_fcpreproc.feat/reg/highres
applywarp -i /home/erinmazerolle/MRGFUS/scripts/harvardoxford-subcortical_prob_Lateral_Ventricles -w ${FUNCDIR}/${PREPROCFEAT}/reg/standard2highres_warp --postmat=${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.feat/reg/highres2example_func.mat -r ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.feat/reg/example_func -o ${FUNCDIR}/harvardoxford-subcortical_prob_Lateral_Ventricles2func --interp=nn
fsleyes ${ANALYSISDIR}/${MYSUB}/fmri/rs.feat/filtered_func_data.feat/reg/example_func ${FUNCDIR}/harvardoxford-subcortical_prob_Lateral_Ventricles2func

fslmeants -i ${MYFEAT}/filtered_func_data -m ${MYMASK} -o ${MYFEAT}/${MASKNAME}_ts.txt --eig
fslmeants -i ${MYFEAT}/filtered_func_data -m ${MYFEAT}/mask -o ${MYFEAT}/global_ts.txt --eig
fslmeants -i ${MYFEAT}/filtered_func_data -m ${FUNCDIR}/harvardoxford-subcortical_prob_Lateral_Ventricles2func -o ${MYFEAT}/lateral_ventricles_ts.txt --eig

sed 's:MYSUB:'${MYSUB}':g' ${SCRIPTSDIR}/fc.fsf > ${FUNCDIR}/fc_${MASKNAME}.fsf
sed -i '' 's:MYMASKNAME:'${MYFEAT}'/'${MASKNAME}'_ts.txt:g' ${FUNCDIR}/fc_${MASKNAME}.fsf

feat ${FUNCDIR}/fc_${MASKNAME}.fsf





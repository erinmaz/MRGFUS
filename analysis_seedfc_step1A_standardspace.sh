#!/bin/bash
#seed based functional connectivity analysis

MYSUB=$1

MYCOIL=$2 
#full path of mask (in standard space)
MYMASK=`imglob $3`

#full path of pre-processed feat (rs.feat in my current pipeline)
MYFEAT=$4

#full path of reg folder to use (rs_reg.feat/reg in my current pipeline)
MYREG=$5

ANALYSISDIR=~/Desktop/Projects/MRGFUS/analysis
SCRIPTSDIR=~/Desktop/Projects/MRGFUS/scripts
MASKNAME=`basename $MYMASK`

FEATNAME=`basename $MYFEAT`
cp -r $MYFEAT ${ANALYSISDIR}/${MYSUB}/fmri/${FEATNAME}.backup

#get lateral ventricles in func space for nuisance regressor
if [ ! -f ${MYREG}/standard2example_func_warp.nii.gz ]
then
invwarp -w ${MYREG}/example_func2standard_warp -o ${MYREG}/standard2example_func_warp -r ${MYREG}/example_func
fi

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/harvardoxford-subcortical_prob_Lateral_Ventricles -w ${MYREG}/standard2example_func_warp -r ${MYREG}/example_func -o ${MYFEAT}/harvardoxford-subcortical_prob_Lateral_Ventricles2func --interp=nn

#applywarp -i ${MYMASK} -w ${MYREG}/standard2example_func_warp -r ${MYREG}/example_func -o ${MYFEAT}/${MASKNAME}2func --interp=nn
#applywarp -i ${MYMASK} -w ${MYREG}/standard2highres_warp -r ${MYREG}/highres -o ${MYFEAT}/${MASKNAME}2highres --interp=nn
#fslmaths ${ANALYSISDIR}/${MYSUB}/anat/c1T1 -thr .95 -bin ${ANALYSISDIR}/${MYSUB}/anat/c1T1_thr95
#fslmaths ${MYFEAT}/${MASKNAME}2highres -mas ${ANALYSISDIR}/$MYSUB/anat/c1T1_thr95 ${MYFEAT}/${MASKNAME}2highres_gm
#flirt -applyxfm -init ${MYREG}/highres2example_func.mat -in ${MYFEAT}/${MASKNAME}2highres_gm -ref ${MYREG}/example_func -out ${MYFEAT}/${MASKNAME}2highres_gm2example_func -interp nearestneighbour

#fsleyes ${MYREG}/example_func ${MYFEAT}/${MASKNAME}2highres_gm2example_func ${MYFEAT}/harvardoxford-subcortical_prob_Lateral_Ventricles2func ${MYFEAT}/filtered_func_data ${MYFEAT}/mask


#fslmeants -i ${MYFEAT}/filtered_func_data -m ${MYFEAT}/${MASKNAME}2highres_gm2example_func -o ${MYFEAT}/${MASKNAME}2highres_gm2example_func_ts.txt --eig


applywarp -i ${MYMASK} -w ${MYREG}/standard2example_func_warp -r ${MYREG}/example_func -o ${MYFEAT}/${MASKNAME}2example_func --interp=nn

fsleyes ${MYREG}/example_func ${MYFEAT}/${MASKNAME}2example_func ${MYFEAT}/harvardoxford-subcortical_prob_Lateral_Ventricles2func ${MYFEAT}/filtered_func_data ${MYFEAT}/mask

fslmeants -i ${MYFEAT}/filtered_func_data -m ${MYFEAT}/${MASKNAME}2example_func -o ${MYFEAT}/${MASKNAME}2example_func_ts.txt --eig

fslmeants -i ${MYFEAT}/filtered_func_data -m ${MYFEAT}/mask -o ${MYFEAT}/global_ts.txt --eig
fslmeants -i ${MYFEAT}/filtered_func_data -m ${MYFEAT}/harvardoxford-subcortical_prob_Lateral_Ventricles2func -o ${MYFEAT}/lateral_ventricles_ts.txt --eig

sed 's:MYSUB:'${MYSUB}':g' ${SCRIPTSDIR}/fc_${MYCOIL}.fsf > ${ANALYSISDIR}/${MYSUB}/fmri/fc_${MASKNAME}.fsf
sed -i '' 's:MYFEAT:'${MYFEAT}':g'  ${ANALYSISDIR}/${MYSUB}/fmri/fc_${MASKNAME}.fsf
sed -i '' 's:MASKNAME:'${MASKNAME}'2example_func_ts.txt:g' ${ANALYSISDIR}/${MYSUB}/fmri/fc_${MASKNAME}.fsf

feat ${ANALYSISDIR}/${MYSUB}/fmri/fc_${MASKNAME}.fsf

FEATPREFIX=`basename $FEATNAME .feat`
mv $MYFEAT ${ANALYSISDIR}/${MYSUB}/fmri/${FEATPREFIX}_${MASKNAME}.feat
mv ${ANALYSISDIR}/${MYSUB}/fmri/${FEATNAME}.backup ${ANALYSISDIR}/${MYSUB}/fmri/${FEATNAME}




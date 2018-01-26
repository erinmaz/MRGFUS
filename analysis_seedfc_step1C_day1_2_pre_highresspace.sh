#!/bin/bash
#seed based functional connectivity analysis

MYSUB=$1
ANALYSISDIR=~/Desktop/Projects/MRGFUS/analysis
SCRIPTSDIR=~/Desktop/Projects/MRGFUS/scripts




MYCOIL=$2 
#full path of mask (in highres space)
MYMASK=`imglob $3`

#full path of pre-processed feat (rs.feat in my current pipeline)
MYFEAT=$4

#full path of standard2example_func_warp to use
MYREG_STANDARD=$5

#full path of mask2example_func.mat to use
MYREG_MASK2EXAMPLE_FUNC=$6


FEATNAME=`basename $MYFEAT`
MASKNAME=`basename $MYMASK`

#save a copy of this script to the analysis dir, so I know what I've run
cp $0 ${ANALYSISDIR}/${MYSUB}/.

cp -r $MYFEAT ${ANALYSISDIR}/${MYSUB}/fmri/${FEATNAME}.backup

#get lateral ventricles in func space for nuisance regressor

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/scripts/harvardoxford-subcortical_prob_Lateral_Ventricles -w ${MYREG_STANDARD} -r ${MYFEAT}/example_func -o ${MYFEAT}/harvardoxford-subcortical_prob_Lateral_Ventricles2func --interp=nn

flirt -applyxfm -init ${MYREG_MASK2EXAMPLE_FUNC} -in $MYMASK -ref ${MYFEAT}/example_func -o ${MYFEAT}/${MASKNAME}2example_func -interp nearestneighbour

fsleyes ${MYFEAT}/example_func ${MYFEAT}/${MASKNAME}2example_func ${MYFEAT}/harvardoxford-subcortical_prob_Lateral_Ventricles2func ${MYFEAT}/filtered_func_data ${MYFEAT}/mask

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



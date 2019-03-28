#/bin/bash
ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYSUB=$1
T2_to_replace=$2 # either T2 or T2_2
newT2=$3 #dicom dir

rm ${newT2}/*.nii*

dcm2niix $newT2

fsleyes ${newT2}/*.nii* ${ANALYSISDIR}/${MYSUB}/anat/${T2_to_replace}
echo "Use the new T2 image? (Y or N): "
read yn
if [ $yn = "Y" ]; then
fslmaths ${newT2}/*.nii* ${ANALYSISDIR}/${MYSUB}/anat/${T2_to_replace}
flirt -in ${ANALYSISDIR}/${MYSUB}/anat/T2_2 -ref ${ANALYSISDIR}/${MYSUB}/anat/T2 -out ${ANALYSISDIR}/${MYSUB}/anat/T2_2_to_T2 -omat ${ANALYSISDIR}/${MYSUB}/anat/T2_2_to_T2.mat -dof 6 -nosearch
fslmaths ${ANALYSISDIR}/${MYSUB}/anat/T2_2_to_T2 -add ${ANALYSISDIR}/${MYSUB}/anat/T2 -div 2 ${ANALYSISDIR}/${MYSUB}/anat/T2_avg
fsleyes ${ANALYSISDIR}/${MYSUB}/anat/T2_avg ${ANALYSISDIR}/${MYSUB}/anat/T2 ${ANALYSISDIR}/${MYSUB}/anat/T2_2_to_T2 &
fi



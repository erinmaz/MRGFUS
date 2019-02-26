#/bin/bash
cd /Users/erin/Desktop/Projects/MRGFUS/analysis
for f in `find . -name "T2_2.nii.gz"`
do
g=`dirname $f`
if [ ! -f ${g}/T2_avg.nii.gz ]; then
flirt -in ${g}/T2_2 -ref ${g}/T2 -out ${g}/T2_2_to_T2 -omat ${g}/T2_2_to_T2.mat -dof 6 -nosearch
fslmaths ${g}/T2_2_to_T2 -add ${g}/T2 -div 2 ${g}/T2_avg
fsleyes ${g}/T2_avg ${g}/T2 ${g}/T2_2_to_T2 &
fi
done
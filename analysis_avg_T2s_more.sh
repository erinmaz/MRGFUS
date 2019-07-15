#/bin/bash
#did 9010 manually
cd /Users/erin/Desktop/Projects/MRGFUS/analysis
for sub in 9013_JD-16000
do
flirt -in ${sub}/anat/T2_2 -ref ${sub}/anat/T2 -out ${sub}/anat/T2_2_to_T2 -omat ${sub}/anat/T2_2_to_T2.mat -dof 6
fslmaths ${sub}/anat/T2_2_to_T2 -add ${sub}/anat/T2 -div 2 ${sub}/anat/T2_avg
done
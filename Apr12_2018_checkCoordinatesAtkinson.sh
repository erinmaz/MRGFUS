midpoint between ac-pc (zelma marked 0.5 mm MNI)
0.5 -10 -2.5

 	Coordinate (mm)
Outcome Group	X	Y	Z
excellent	−13.4	−3.1	6.5
good & fair	−13.6	−0.6	5.4
essential lesion	−13.2	−5.1	6.7

excellent
-13 -13 4

good and fair
-13 -10.5 3

essential
-13 -15 4

for lesion in MNI152_T1_0.5mm_Kiss_ACPCaligned_Atkinson_essential MNI152_T1_0.5mm_Kiss_ACPCaligned_Atkinson_excellent MNI152_T1_0.5mm_Kiss_ACPCaligned_Atkinson_goodandfair
do
flirt -in /Users/erin/Desktop/Projects/MRGFUS/atlases/InsightecTargeting/MNI152_0.5mm_KissACPC/$lesion -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/atlases/InsightecTargeting/MNI152_0.5mm_KissACPC/ACPCaligned2MNI0.5.mat -ref /usr/local/fsl/data/standard/MNI152_T1_0.5mm.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/atlases/InsightecTargeting/MNI152_0.5mm_KissACPC/${lesion}2MNI0.5.nii.gz 
done

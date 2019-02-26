MAINDIR=/Users/erin/Desktop/Projects/MRGFUS

DAY1_SCANS=( 9001_SH-11692 9002_RA-11833 9003_RB-12064 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9010_RR-13536 9011_BB-14148 9013_JD-13722 9016_EB-14450 9021_WM-14455 )

MONTH3_SCANS=( 9001_SH-12271 9002_RA-12388 9003_RB-12669 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-12910 9009_CRB-13623 9010_RR-14700 9011_BB-14878 9013_JD-14227 9016_EB-15241 9021_WM-15089 )
for f in ${MONTH3_SCANS[@]}
do
if [ ! -f ${MAINDIR}/analysis_lesion_masks/$f/anat/T1_lesion_mask_filled2MNI_1mm.nii.gz ]; then
  analysis_step2_T12MNI_1mm.sh $f &
fi
done

for f in ${DAY1_SCANS[@]}
do 
echo -n $f " "
fslstats ${MAINDIR}/analysis_lesion_masks/$f/anat/T1_lesion_mask_filled2MNI_1mm -k ${MAINDIR}/histthal_label_subthalamicnucleus.nii.gz -V
done

wait

for f in ${MONTH3_SCANS[@]}
do 
echo -n $f " "
fslstats ${MAINDIR}/analysis_lesion_masks/$f/anat/T1_lesion_mask_filled2MNI_1mm -k ${MAINDIR}/histthal_label_subthalamicnucleus.nii.gz -V
done
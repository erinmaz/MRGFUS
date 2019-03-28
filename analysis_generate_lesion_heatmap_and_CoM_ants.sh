MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis

OUT=$1

mystring_day1=""
mystring_month3=""

#LESIONFILE generated in check_stn_ANTs.sh
LESIONFILE=anat/xfms/ants/bet/T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9011_BB 9013_JD 9021_WM 
do
DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
MONTH3_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 
mystring_day1=`echo ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/${LESIONFILE} -add $mystring_day1`
mystring_month3=`echo ${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/${LESIONFILE} -add $mystring_month3`
echo $MYSUB
echo $MYSUB `fslstats ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/${LESIONFILE} -c` >> ${OUT}_CoM_day1
echo $MYSUB `fslstats ${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/${LESIONFILE} -c` >> ${OUT}_CoM_month3

done


LESIONFILE=anat/xfms/ants/T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz
for MYSUB in 9010_RR 9016_EB
do
DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
MONTH3_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 
mystring_day1=`echo ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/${LESIONFILE} -add $mystring_day1`
mystring_month3=`echo ${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/${LESIONFILE} -add $mystring_month3`

echo $MYSUB `fslstats ${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/${LESIONFILE} -c` >> ${OUT}_CoM_day1
echo $MYSUB `fslstats ${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/${LESIONFILE} -c` >> ${OUT}_CoM_month3

done


mystring_day1=${mystring_day1%????}
mystring_month3=${mystring_month3%????}

fslmaths ${mystring_day1} ${OUT}_heatmap_day1
fslmaths ${mystring_month3} ${OUT}_heatmap_month3

fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm ${OUT}_heatmap_day1 -cm "Red-Yellow" ${OUT}_heatmap_month3 -cm "Red-Yellow"


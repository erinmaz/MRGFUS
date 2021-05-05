mkdir /Users/erin/Desktop/Projects/MRGFUS/analysis/results_NeuroImageReportsR1

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
for MYSUB in 9001_SH 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 9022_JG 9023_WS 9024_LLB 9028_PR 9030_GA 9031_DB 
do
PRE=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
DAY1=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
#MONTH3=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'`

#analysis_Kwon_ROIs_probtrackx_thalterm_split_tracts_ants.sh $MYSUB $PRE $DAY1  
#analysis_Kwon_ROIs_probtrackx_thalterm_get_results_ants.sh $MYSUB $PRE $DAY1 /Users/erin/Desktop/Projects/MRGFUS/analysis/results_NeuroImageReportsR1/${MYSUB}_thalterm_

if [ -e ${MAINDIR}/analysis/${MYSUB}/anat/T2_avg.nii.gz ]
then
T2=T2_avg
else
T2=T2
fi

#flirt -in ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/${T2} -ref ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1 -dof 6 -nosearch -omat ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/xfms/${T2}_2_T1.mat -out ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/${T2}_2_T1 -refweight ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_brain

#flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/xfms/${T2}_2_T1.mat -in ${MAINDIR}/T2lesions_SarahScott/${MYSUB:0:4}_02_Day1/T2_lesion -interp trilinear -ref ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1 -out ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1

#fslmaths ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1 -thr 0.5 -bin  ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin

#fsleyes ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/${T2}_2_T1 ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1 ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled &


#fslmaths ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled -mas ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_T1_lesion_overlap

#overlap=`fslstats ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_T1_lesion_overlap -V`
#T2vol=`fslstats ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin -V`
#T1vol=`fslstats ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled -V`
#echo $MYSUB $overlap $T2vol $T1vol >> ${MAINDIR}/analysis/T1_T2_lesionvol_forDice.txt
done

#cd /Users/erin/Desktop/Projects/MRGFUS/analysis/results_NeuroImageReportsR1
#paste -d '\t' `ls *d2s` > thalterm_dentate2scp
#paste -d '\t' `ls *s2l` > thalterm_scp2lesion

#problem with T2 lesion for 9010 day 1. The file is just wrong. Sarah's map is fine
cd /Users/erin/Desktop/Projects/MRGFUS/T2lesions_SarahScott/9010_02_Day1 
fslmaths zone1_T2_redo.nii.gz -add zone2_T2_redo.nii.gz -bin T2_lesion
MYSUB=9010_RR
PRE=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
DAY1=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 

 

if [ -e ${MAINDIR}/analysis/${MYSUB}/anat/T2_avg.nii.gz ]
then
T2=T2_avg
else
T2=T2
fi

flirt -applyxfm -init ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/xfms/${T2}_2_T1.mat -in ${MAINDIR}/T2lesions_SarahScott/${MYSUB:0:4}_02_Day1/T2_lesion -interp trilinear -ref ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1 -out ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1

fslmaths ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1 -thr 0.5 -bin  ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin

fsleyes ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/${T2}_2_T1 ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1 ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled &

fslmaths ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled -mas ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_T1_lesion_overlap


fsleyes ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/${T2}_2_T1 ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1 ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled &

overlap=`fslstats ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_T1_lesion_overlap -V`
T2vol=`fslstats ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T2_lesion_2_T1_bin -V`
T1vol=`fslstats ${MAINDIR}/analysis/${MYSUB}-${DAY1}/anat/T1_lesion_mask_filled -V`
echo $MYSUB $overlap $T2vol $T1vol >> ${MAINDIR}/analysis/T1_T2_lesionvol_forDice.txt
done
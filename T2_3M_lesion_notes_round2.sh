#manually combined zones and renamed everything to T2_lesion
LESIONS=~/Desktop/Projects/MRGFUS/T2lesions_SarahScott
MYFILE=~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums_initialsSeparate.sh
while read line; do

SUB=`echo $line | awk '{print $1}'` 
INITIALS=`echo $line | awk '{print $2}'`
PRE=`echo $line | awk '{print $3}'` 
DAY1=`echo $line | awk '{print $4}'`
MONTH3=`echo $line | awk '{print $5}'`

cp ${LESIONS}/${SUB}_03_3M/T2/T2_lesion.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}_${INITIALS}-${MONTH3}/anat/T2_lesion_Sarah.nii.gz
cp ${LESIONS}/${SUB}_02_Day1/T2/T2_lesion.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}_${INITIALS}-${DAY1}/anat/T2_lesion_Sarah.nii.gz

done <$MYFILE

ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYFILE=~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh
while read line; do 

SUB=`echo $line | awk '{print $1}'` 
PRE=`echo $line | awk '{print $2}'` 
DAY1=`echo $line | awk '{print $3}'`
MONTH3=`echo $line | awk '{print $4}'`

for EXAM in $DAY1 $MONTH3
do
if [ -f ${ANALYSISDIR}/${SUB}-${EXAM}/anat/T2_lesion_Sarah.nii.gz ]; then
if [ -f ${ANALYSISDIR}/${SUB}-${EXAM}/anat/T2_avg.nii.gz ]; then 
infile=T2_avg
else
infile=T2
fi

flirt -in ${ANALYSISDIR}/${SUB}-${EXAM}/anat/${infile} -ref ${ANALYSISDIR}/${SUB}-${EXAM}/anat/T1 -out ${ANALYSISDIR}/${SUB}-${EXAM}/anat/${infile}_2_T1 -omat ${ANALYSISDIR}/${SUB}-${EXAM}/anat/${infile}_2_T1.mat -dof 6 -nosearch
fsleyes ${ANALYSISDIR}/${SUB}-${EXAM}/anat/${infile}_2_T1 ${ANALYSISDIR}/${SUB}-${EXAM}/anat/T1
fi
done

for tp in day1 month3
do
if [ -f ${ANALYSISDIR}/${SUB}_longitudinal_xfms_T1/T1_brain_${tp}_2_pre_6dof.mat ]; then
convert_xfm -omat ${ANALYSISDIR}/${SUB}_longitudinal_xfms/T1_${tp}_2_diff_pre.mat -concat ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${SUB}_longitudinal_xfms_T1/T1_brain_${tp}_2_pre_6dof.mat
else
convert_xfm -omat ${ANALYSISDIR}/${SUB}_longitudinal_xfms/T1_${tp}_2_diff_pre.mat -concat ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${SUB}_longitudinal_xfms_T1/mT1_brain_${tp}_2_pre_6dof.mat
fi
done


convert_xfm -omat ${ANALYSISDIR}/${SUB}_longitudinal_xfms/T2_month3_2_diff_pre.mat -concat ${ANALYSISDIR}/${SUB}_longitudinal_xfms/T1_month3_2_diff_pre.mat ${ANALYSISDIR}/${SUB}-${MONTH3}/anat/${infile}_2_T1.mat

convert_xfm -omat ${ANALYSISDIR}/${SUB}_longitudinal_xfms/T2_day1_2_diff_pre.mat -concat ${ANALYSISDIR}/${SUB}_longitudinal_xfms/T1_day1_2_diff_pre.mat ${ANALYSISDIR}/${SUB}-${DAY1}/anat/${infile}_2_T1.mat


applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}-${MONTH3}/anat/T2_lesion_Sarah -r ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/mean_b0_unwarped --premat=${ANALYSISDIR}/${SUB}_longitudinal_xfms/T2_month3_2_diff_pre.mat -o ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_month3

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}-${DAY1}/anat/T2_lesion_Sarah -r ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/mean_b0_unwarped --premat=${ANALYSISDIR}/${SUB}_longitudinal_xfms/T2_day1_2_diff_pre.mat -o ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_day1


fslmaths ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_month3 -thr 0.5 -bin ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_month3_bin

fslmaths ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_day1 -thr 0.5 -bin ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_day1_bin

done <$MYFILE

cd ${ANALYSISDIR}

for f in `find . -name "T2_lesion_Sarah_day1.nii.gz"`
do
g=`basename $f`
h=`dirname $f`
fslmaths $f -thr 0.5 -bin ${h}/T2_lesion_Sarah_month3_bin
tot=`fslstats ${h}/T2_lesion_Sarah_month3_bin -V`
dr=`fslstats ${h}/T2_lesion_Sarah_month3_bin -k ${h}/Kwon_ROIs_ants/dentate_R_dil_thalterm/fdt_paths -V`
dl=`fslstats ${h}/T2_lesion_Sarah_month3_bin -k ${h}/Kwon_ROIs_ants/dentate_L_dil_thalterm/fdt_paths -V`
echo ${h} $tot $dr $dl
done

for f in `find . -name "T2_lesion_Sarah_month3.nii.gz"`
do
g=`basename $f`
h=`dirname $f`
fslmaths $f -thr 0.5 -bin ${h}/T2_lesion_Sarah_month3_bin
tot=`fslstats ${h}/T2_lesion_Sarah_month3_bin -V`
dr=`fslstats ${h}/T2_lesion_Sarah_month3_bin -k ${h}/Kwon_ROIs_ants/dentate_R_dil_thalterm/fdt_paths -V`
dl=`fslstats ${h}/T2_lesion_Sarah_month3_bin -k ${h}/Kwon_ROIs_ants/dentate_L_dil_thalterm/fdt_paths -V`
echo ${h} $tot $dr $dl
done
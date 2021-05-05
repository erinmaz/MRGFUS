#manually combined zones and renamed everything to T2_lesion
#manually copy T2_avg where appropriate
ANALYSISDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
LESIONS=~/Desktop/Projects/MRGFUS/T2lesions_SarahScott


SUB=9010
INITIALS=RR
PRE=13130
DAY1=13536
MONTH3=14700

cp ${LESIONS}/${SUB}_03_3M/T2_lesion.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}_${INITIALS}-${MONTH3}/anat/T2_lesion_Sarah.nii.gz
cp ${LESIONS}/${SUB}_02_Day1/T2_lesion.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}_${INITIALS}-${DAY1}/anat/T2_lesion_Sarah.nii.gz

SUB=9010_RR

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}-${MONTH3}/anat/T2_lesion_Sarah -r ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/mean_b0_unwarped --premat=${ANALYSISDIR}/${SUB}_longitudinal_xfms/T2_month3_2_diff_pre.mat -o ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_month3

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${SUB}-${DAY1}/anat/T2_lesion_Sarah -r ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/mean_b0_unwarped --premat=${ANALYSISDIR}/${SUB}_longitudinal_xfms/T2_day1_2_diff_pre.mat -o ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_day1

fsleyes ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_day1  ${ANALYSISDIR}/${SUB}-${PRE}/diffusion/T2_lesion_Sarah_month3

cd ${ANALYSISDIR}

for f in `find . -name "T2_lesion_Sarah_day1.nii.gz"`
do
g=`basename $f`
h=`dirname $f`
fslmaths ${h}/T2_lesion_Sarah_day1 -thr 0.5 -bin ${h}/T2_lesion_Sarah_day1_bin
tot=`fslstats ${h}/T2_lesion_Sarah_day1_bin -V`
dr=`fslstats ${h}/T2_lesion_Sarah_day1_bin -k ${h}/Kwon_ROIs_ants/dentate_R_dil_thalterm/fdt_paths -V`
dl=`fslstats ${h}/T2_lesion_Sarah_day1_bin -k ${h}/Kwon_ROIs_ants/dentate_L_dil_thalterm/fdt_paths -V`
echo ${h} $tot $dr $dl
done

for f in `find . -name "T2_lesion_Sarah_month3.nii.gz"`
do
g=`basename $f`
h=`dirname $f`
fslmaths ${h}/T2_lesion_Sarah_month3 -thr 0.5 -bin ${h}/T2_lesion_Sarah_month3_bin
tot=`fslstats ${h}/T2_lesion_Sarah_month3_bin -V`
dr=`fslstats ${h}/T2_lesion_Sarah_month3_bin -k ${h}/Kwon_ROIs_ants/dentate_R_dil_thalterm/fdt_paths -V`
dl=`fslstats ${h}/T2_lesion_Sarah_month3_bin -k ${h}/Kwon_ROIs_ants/dentate_L_dil_thalterm/fdt_paths -V`
echo ${h} $tot $dr $dl
done
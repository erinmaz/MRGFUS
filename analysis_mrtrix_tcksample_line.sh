MAINDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
MYSUB=$1
MYSUB_PRE=${MYSUB}-${2}
TRACTNAME=$3
WORKDIR=${MAINDIR}/${MYSUB_PRE}/diffusion/mrtrix
OUTDIR=${MAINDIR}/${MYSUB}_diffusion_longitudinal/dti_in_pre_T1_space_210818

mkdir ${OUTDIR}.old
mv ${OUTDIR}/*.txt ${OUTDIR}.old/.
for image in FA MD L1 RD 
do
for TP in TP1 TP2 TP3
do
tcksample ${WORKDIR}/${TRACTNAME} ${OUTDIR}/${image}_${TP}.nii.gz ${OUTDIR}/${TRACTNAME}_${image}_${TP}.txt -force
awk NF ${OUTDIR}/${TRACTNAME}_${image}_${TP}.txt > ${OUTDIR}/${TRACTNAME}_${image}_${TP}_noblanklines.txt
awk '{ for(i=1;i<=NF;i++) total[i]+=$i ; } END { for(i=1;i<=NF;i++) printf "%f ",total[i]/NR ;}' ${OUTDIR}/${TRACTNAME}_${image}_${TP}_noblanklines.txt > ${OUTDIR}/${TRACTNAME}_${image}_${TP}_avg.txt 
done
for f in `ls -d ${OUTDIR}/${TRACTNAME}_${image}_*_avg.txt`; do (cat "${f}"; echo) >> ${OUTDIR}/${TRACTNAME}_${image}_allTPs_avg.txt; done
done

for f in `ls -d ${OUTDIR}/${TRACTNAME}_*_allTPs_avg.txt`; do (cat "${f}"; echo) >> ${OUTDIR}/${TRACTNAME}_allimages_allTPs_avg.txt; done
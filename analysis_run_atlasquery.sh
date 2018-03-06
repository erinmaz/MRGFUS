#!/bin/bash
lesiondir=/Users/erin/Dropbox/BigBrainAnalysis/day1_lesions/mni_1mm
outdir=/Users/erin/Desktop/Projects/MRGFUS/analysis
for sub in `ls -d $lesiondir/9*`
do
subnum=`basename $sub`
atlasquery -a "Histological Thalamus Atlas" -m ${sub}/T1_lesion_mask_filled2MNI_1mm > ${outdir}/${subnum}/HistThal_atlasquery_output.txt
sed -i ' ' 's/^/'$subnum':/g' ${outdir}/${subnum}/HistThal_atlasquery_output.txt
done

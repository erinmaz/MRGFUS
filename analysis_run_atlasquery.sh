#!/bin/bash
outname=$1
lesiondir=/Users/erin/Dropbox/BigBrainAnalysis/day1_lesions/mni_1mm
outdir=/Users/erin/Desktop/Projects/MRGFUS/analysis
for sub in `ls -d $lesiondir/9*`
do
subnum=`basename $sub`
atlasquery -a "Histological Thalamus Atlas" -m ${sub}/T1_lesion_mask_filled2MNI_1mm > ${outdir}/${subnum}/HistThal_atlasquery_${outname}.txt
sed -i.bk 's/^/'$subnum':/g' ${outdir}/${subnum}/HistThal_atlasquery_${outname}.txt
rm ${outdir}/${subnum}/HistThal_atlasquery_${outname}.txt.bk
done

mystring=""
for sub in `ls -d $lesiondir/9*`
do
subnum=`basename $sub`
mystring=`echo $mystring ${outdir}/${subnum}/HistThal_atlasquery_${outname}.txt`
done
cat $mystring > ${outdir}/HistThal_atlasquery_all_${outname}.txt


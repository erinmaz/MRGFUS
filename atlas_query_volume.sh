#!/bin/bash
MASK=$1
ROIDIR=$2
for f in `ls -d $ROIDIR/*`
do
index=`basename $f .nii.gz`
vol=`fslstats $MASK -k ${f} -V`
roivol=`fslstats ${f} -V`
roiname=`grep "label index=\"${index}\"" /Users/erin/Desktop/Projects/MRGFUS/atlases/HistThalAtlas/HistThal.xml | sed -n 's/<\(.*\)>\(.*\)<\/label>/\2/p'`
array=($vol)
numvoxels=`echo ${array[0]}`
roiarray=($roivol)
roinumvoxels=`echo ${roiarray[0]}`
if [ "$numvoxels" -gt "0" ]
then
echo $roiname,$numvoxels,$roinumvoxels
fi
done

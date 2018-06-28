#!/bin/bash

statsfolder=$1
q=$2
dof=$3

ttologp -logpout ${statsfolder}/logp1 ${statsfolder}/varcope1 ${statsfolder}/cope1 $dof
fslmaths ${statsfolder}/logp1 -exp ${statsfolder}/p1 
outstr=`fdr -i ${statsfolder}/p1 -q ${q}`
for word in $outstr
do
thr=$word
done
one_minus_thr=`awk -v thr=$thr 'BEGIN {print 1 - thr}'`
fslmaths ${statsfolder}/p1 -mul -1 -add 1 -thr ${one_minus_thr} -mas ${statsfolder}/p1 ${statsfolder}/thresh_1_minus_p1

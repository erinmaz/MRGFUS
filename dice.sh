#!/bin/bash

GT=$1
TEST=$2
OUTPUT=$3

fslmaths $GT -add $TEST -thr 2  ${OUTPUT}/TP
fslmaths $TEST -sub $GT -thr 0 ${OUTPUT}/FP
fslmaths $GT -sub $TEST -thr 0 ${OUTPUT}/FN

TP=`fslstats ${OUTPUT}/TP -V | cut -d ' ' -f 2`
FP=`fslstats ${OUTPUT}/FP -V | cut -d ' ' -f 2`
FN=`fslstats ${OUTPUT}/FN -V | cut -d ' ' -f 2`

awk -v tp="$TP" -v fp="$FP" -v fn="$FN" 'BEGIN { print 2*tp / (2*tp + fp + fn)}'
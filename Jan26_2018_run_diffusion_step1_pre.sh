#!/bin/bash

for f in 9001_SH-11644 9005_BG-13004 9006_EO-12389
do
time analysis_diffusion_step1.sh $f &>/Users/erin/Desktop/Projects/MRGFUS/logs/analysis_diffusion_step1_${f}.log
done

for f in 9007_RB-12461 9008_JO-12613
do
time analysis_diffusion_step1.sh $f &>/Users/erin/Desktop/Projects/MRGFUS/logs/analysis_diffusion_step1_${f}.log
done

for f in 9009_CRB-12609 9010_RR_13130
do
time analysis_diffusion_step1.sh $f &>/Users/erin/Desktop/Projects/MRGFUS/logs/analysis_diffusion_step1_${f}.log
done



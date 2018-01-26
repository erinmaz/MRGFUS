#!/bin/bash

for f in 9001_SH-11692 9002_RA-11833 9004_EP-12203 9006_EO-12487 9007_RB-1291 9009_CRB-13043
do
time analysis_diffusion_step1.sh $f &>/Users/erin/Desktop/Projects/MRGFUS/logs/analysis_diffusion_step1_${f}.log &
done

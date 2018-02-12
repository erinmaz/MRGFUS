#!/bin/bash

for f in 9001_SH-12271 9002_RA-12388 9004_EP-12955
do
time analysis_diffusion_step1.sh $f &>/Users/erin/Desktop/Projects/MRGFUS/logs/analysis_diffusion_step1_${f}.log &
done
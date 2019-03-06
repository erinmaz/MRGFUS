#!/bin/bash
mkdir /Volumes/Pikelab/MRGFUS-shared/ants_reg
cd /Users/erin/Desktop/Projects/MRGFUS/analysis
find . -name "ants" | xargs tar cvf - | ( cd /Volumes/Pikelab/MRGFUS-shared/ants_reg ; tar xfp - )


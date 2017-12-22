#!/bin/bash

MYSUB=$1

mkdir /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/xfms

flirt -in /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/T1 -ref /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/SWAN_mag.nii.gz -out /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/T12SWAN_mag_direct -dof 6 -omat  /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/xfms/T12SWAN_mag_direct.mat 

flirt -in /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/T1_lesion_mask_filled -ref /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/SWAN_mag.nii.gz -out /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/T1_lesion_mask_filled2SWAN_mag -applyxfm -init /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/xfms/T12SWAN_mag_direct.mat -interp nearestneighbour

fsleyes /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/T12SWAN_mag_direct /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/SWAN_mag /home/erinmazerolle/MRGFUS/analysis/${MYSUB}/anat/T1_lesion_mask_filled2SWAN_mag

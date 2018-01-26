#!/bin/bash
GT=T1_lesion_mask_filled2SWAN_mag
TEST=SWAN_mag_lesion_mask
ANALYSIS_DIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
for f in 9005_BG-13126
do
mkdir ${ANALYSIS_DIR}/$f/anat/dice_GT_T1_TEST_SWAN
dice=`dice.sh ${ANALYSIS_DIR}/$f/anat/$GT ${ANALYSIS_DIR}/$f/anat/$TEST ${ANALYSIS_DIR}/$f/anat/dice_GT_T1_TEST_SWAN`
echo $f $dice
done
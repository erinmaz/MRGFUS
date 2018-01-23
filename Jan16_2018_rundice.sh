#!/bin/bash
GT=T1_lesion_mask_filled2SWAN_mag
TEST=SWAN_mag_lesion_mask
ANALYSIS_DIR=/Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks
for f in 9001_SH-11692 9002_RA-11833 9003_RB-12064 9004_EP-12203 9006_EO-12487 9007_RB-12910 9008_JO-12667 9009_CRB-13043
do
mkdir ${ANALYSIS_DIR}/$f/anat/dice_GT_T1_TEST_SWAN
dice=`dice.sh ${ANALYSIS_DIR}/$f/anat/$GT ${ANALYSIS_DIR}/$f/anat/$TEST ${ANALYSIS_DIR}/$f/anat/dice_GT_T1_TEST_SWAN`
echo $f $dice
done
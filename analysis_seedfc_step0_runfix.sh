#!/bin/bash
MYFEAT=$1

cp -r $MYFEAT ${MYFEAT}.backup

cd /Users/erin/fix1.065

./fix ${MYFEAT} ~/fix1.065/training_files/Standard.RData 20

fsleyes ${MYFEAT}/filtered_func_data.ica/melodic_IC
fsleyes ${MYFEAT}/filtered_func_data_clean

#!/bin/bash
MYFEAT=$1
MYREG=$2
cp -r $MYFEAT ${MYFEAT}.backup
cp -r $MYREG ${MYFEAT}/reg
cd /Users/erin/fix1.065


./fix ${MYFEAT} ~/fix1.065/training_files/Standard.RData 20

fsleyes ${MYFEAT}/filtered_func_data.ica/melodic_IC &
fsleyes ${MYFEAT}/filtered_func_data_clean &
bbedit ${MYFEAT}/fix4melview_Standard_thr20.txt

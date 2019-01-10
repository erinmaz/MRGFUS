#!/bin/bash
#catch all subs with 3M data up with linear and nonlinear longitudinal reg
for MYSUB in 9003_RB 9008_JO 9010_RR 9011_BB 9016_EB 9020_JL 9021_WM 
do
analysis_longitudinal_all_T1s_in_pre_space.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done

analysis_step1_T1_lesion_trace.sh 9016_EB-15241

for MYSUB in 9003_RB 9008_JO 9010_RR 9011_BB 9016_EB 9020_JL 9021_WM 
do
analysis_longitudinal_all_T1s_in_pre_space_step2_fnirt.sh `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh`
done
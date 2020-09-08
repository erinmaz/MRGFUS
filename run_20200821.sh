for MYSUB in 9001_SH 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 9022_JG 9023_WS 9024_LLB 9028_PR 9030_GA 9031_DB 
do
PRE=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
DAY1=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
MONTH3=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'`
#analysis_Kwon_ROIs_probtrackx_get_untreated_tract_ants.sh $MYSUB $PRE $DAY1

analysis_Kwon_ROIs_probtrackx_untreated_tract_get_results_ants.sh $MYSUB $PRE $DAY1 /Users/erin/Desktop/Projects/MRGFUS/analysis/results_untreated_tract_ants_${MYSUB}

done


cd /Users/erin/Desktop/Projects/MRGFUS/analysis/

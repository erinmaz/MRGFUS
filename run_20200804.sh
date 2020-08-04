#for updated manuscript for JNeurosurgery
addNewPatient.sh 9001_SH #redid without mT1 to make sure it's not a big difference - it wasn't
addNewPatient.sh 9024_LLB
addNewPatient.sh 9028_PR
addNewPatient.sh 9030_GA
addNewPatient.sh 9031_DB
cd /Users/erin/Desktop/Projects/MRGFUS/analysis
analysis_generate_lesion_heatmap_and_CoM_ants.sh results_20200804
fslstats results_20200804_heatmap_day1 -R # to get range for figure


#manually create a new spreadsheet (Results_Summary_manuscript_20200804.xls), update 9001, remove 9002, and add 9024, 9028, 9030, and 9031
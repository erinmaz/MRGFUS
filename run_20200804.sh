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

#for figure
flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11692/anat/T1.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_day1_2_pre_6dof -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.mat -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1.nii.gz  

analysis_Kwon_ROIs_probtrackx_thalterm_check_lesion_overlap_ants.sh
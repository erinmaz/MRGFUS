#Add a new subject
#FIRST: Put new line in IDs_and_ExamNums.sh
#ASSUMES You have traced the lesions for day1 and month3, and moved it to T1_lesion_zonesIandII in analysis
#ASSUMES you have traced dentates, RNs, SCPs and SCP_decus for pre and put them in diffusion/Kwon_ROIs_ants
#Will work for left hemi lesions only, and only if you use the ants bet reg


MYSUB=$1 #90XX_YY format

PRE=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
DAY1=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
MONTH3=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'`

analysis_longitudinal_all_T1s_in_pre_space.sh $MYSUB $PRE $DAY1 $MONTH3
analysis_ants_reg_one_subject.sh $MYSUB
analysis_T1_day1_2_diff_pre.sh $MYSUB $PRE $DAY1
analysis_Kwon_ROIs_checkOverlap_newSub.sh ${MYSUB}-${PRE}
analysis_Kwon_ROIs_probtrackx_makeROIs_ants_newSubs.sh ${MYSUB}-${PRE}
analysis_Kwon_ROIs_probtrackx_thalterm_ants_newSub.sh ${MYSUB}-${PRE}
analysis_Kwon_ROIs_probtrackx_lesionterm_ants_newSub.sh ${MYSUB}-${PRE}

fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE}/diffusion/Kwon_ROIs_ants/dentate_R_dil_lesionterm/fdt_paths -R

check_stn_ANTs_newSub.sh $MYSUB $DAY1 $MONTH3
analysis_Kwon_ROIs_probtrackx_lesionterm_split_tracts_ants.sh $MYSUB $PRE $DAY1
analysis_longitudinal_diffusion_in_pre_T1_space.sh $MYSUB $PRE $DAY1 $MONTH3
analysis_Kwon_ROIs_probtrackx_makeROI_motorcortex_ants_newSub.sh.sh $MYSUB $PRE 
analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_ants_newSub.sh $MYSUB $PRE
 
analysis_Kwon_ROIs_probtrackx_lesionterm_get_results_ants.sh $MYSUB $PRE $DAY1 /Users/erin/Desktop/Projects/MRGFUS/analysis/results_lesionterm_ants_${MYSUB}
analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_get_results_ants.sh $MYSUB $PRE $DAY1 /Users/erin/Desktop/Projects/MRGFUS/analysis/results_lesionterm_ants_${MYSUB}

#HERE

#run this at the end depending on what subjects we actually keep. NOTE analysis_generate_lesion_heatmap_and_CoM_ants.sh needs to be edited to include the new patient
analysis_generate_lesion_heatmap_and_CoM_ants.sh /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_group_lesions_ants_150719

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM 9022_JG 9023_WS 
do

PRE=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
DAY1=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 
MONTH3=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'`
#analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_get_results_ants.sh $MYSUB $PRE $DAY1 /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_lesion2motorcortex_ants_${MYSUB}
analysis_Kwon_ROIs_probtrackx_lesionterm_get_results_ants.sh $MYSUB $PRE $DAY1 /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_lesionterm_ants_${MYSUB}
done
paste `ls /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_lesion2motorcortex_ants*withinthal` > /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_lesion2motorcortex_ants_all_withinthal
paste `ls /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_lesion2motorcortex_ants*outsidethal` > /Users/erin/Desktop/Projects/MRGFUS/analysis/DTImanuscript_150719/results_lesion2motorcortex_ants_all_outsidethal
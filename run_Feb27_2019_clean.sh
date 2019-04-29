#for new manuscript

#!/bin/bash

analysis_ants_reg.sh

#rerun thalterm tractography using ants to get thalamus into diffusion space


analysis_Kwon_ROIs_probtrackx_makeROIs_ants.sh
analysis_Kwon_ROIs_probtrackx_thalterm_ants.sh
#double check nothing is wrong with 9006,tract from left dentate is super skinny. I think the problem is just that it enters the thalamus at a very lateral point and leaves immediately. I could play with the thalamus ROI but I don't think it will come up because this is the untreated side
# 9009 overlaps with lesion if I don't threshold tract but it looks a bit weird, it's definitely not overlapping the "main" tract
#9013 treated tract is quite skinny but lesion intersects nicely
#9016 - treated side does something too anterior and medial, but there is a small section that looks right that overlaps with lesion

analysis_Kwon_ROIs_probtrackx_lesionterm_ants.sh
#9016 - looks like only two streamlines and one crosses the midline too anterior/superior

#decide if we want to threshold tracts before splitting them
for MYSUB in 9001_SH 9002_RA 9006_EO 9009_CRB 9010_RR 9011_BB 9013_JD 
do
EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${EXAM}/diffusion/Kwon_ROIs_ants/dentate_R_dil_lesionterm/fdt_paths -R
done
0.000000 817.000000 
0.000000 165.000000 
0.000000 1506.000000 
0.000000 3552.000000 
0.000000 3446.000000 
0.000000 92.000000 
0.000000 11.000000 


for MYSUB in 9005_BG 9007_RB 9016_EB
do
EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${EXAM}/diffusion/Kwon_ROIs_ants/dentate_L_dil_lesionterm/fdt_paths -R
done
0.000000 552.000000 
0.000000 141.000000 
0.000000 2.000000 
#decided not to threshold the tracts



for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM
do
analysis_Kwon_ROIs_probtrackx_lesionterm_split_tracts_ants.sh ${MYSUB} `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'`
done

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM
do
analysis_Kwon_ROIs_probtrackx_lesionterm_get_results_ants.sh $MYSUB `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` /Users/erin/Desktop/Projects/MRGFUS/analysis/results_lesionterm_ants
done

analysis_generate_lesion_heatmap_and_CoM_ants.sh results_group_lesions_ants


analysis_Kwon_ROIs_probtrackx_makeROI_motorcortex_ants.sh
analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_ants.sh

for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9021_WM
do
analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_get_results_ants.sh $MYSUB `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` /Users/erin/Desktop/Projects/MRGFUS/analysis/results_lesion2motorcortex_dil_ants
done

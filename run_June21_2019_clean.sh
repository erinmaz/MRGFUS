#for new manuscript

#!/bin/bash

# June 21, 2019 - add 9019 and 9023


for MYSUB in 9019_TB 9023_WS
do
analysis_longitudinal_all_T1s_in_pre_space.sh $MYSUB `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` &
done

analysis_step1_T1_lesion_trace.sh 9023_WS-16422
#no 3 month lesion for 9019_TB

analysis_ants_reg_one_subject.sh 9023_WS
analysis_ants_reg_one_subject.sh 9019_TB

#manually traced dentates, RNs, SCPs and SCP_decus

for MYSUB in 9019_TB 9023_WS
do
#NEW, this step was completed within another script before
analysis_T1_day1_2_diff_pre.sh $MYSUB `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'`
done

#need to check overlap between RNs, also where did my dilations go? analysis_Kwon_ROIs_checkOverlap.sh
analysis_Kwon_ROIs_checkOverlap_newSub.sh 9019_TB-14038
9019_TB-14038 0.000000 0.000000
analysis_Kwon_ROIs_checkOverlap_newSub.sh 9023_WS-14863
9023_WS-14863 0.000000 0.000000


analysis_Kwon_ROIs_probtrackx_makeROIs_ants_newSubs.sh 9019_TB-14038
0 0.000000 
0 0.000000 #checks overlap between SCP and exclude

analysis_Kwon_ROIs_probtrackx_makeROIs_ants_newSubs.sh 9023_WS-14863
0 0.000000 
0 0.000000
#chunk of isthmus/posterior body of CC missing, check if this is a problem in the tracts and fix accordingly

#I've just commented out the previously-run subjects and put the two new subjects into this script, not the tidiest
analysis_Kwon_ROIs_probtrackx_thalterm_ants.sh
analysis_Kwon_ROIs_probtrackx_lesionterm_ants.sh



#double check nothing is wrong with 9006,tract from left dentate is super skinny. I think the problem is just that it enters the thalamus at a very lateral point and leaves immediately. I could play with the thalamus ROI but I don't think it will come up because this is the untreated side
# 9009 overlaps with lesion if I don't threshold tract but it looks a bit weird, it's definitely not overlapping the "main" tract
#9013 treated tract is quite skinny but lesion intersects nicely
#9016 - treated side does something too anterior and medial, but there is a small section that looks right that overlaps with lesion

analysis_Kwon_ROIs_probtrackx_lesionterm_ants.sh
#9016 - looks like only two streamlines and one crosses the midline too anterior/superior

#decide if we want to threshold tracts before splitting them
for MYSUB in 9001_SH 9002_RA 9006_EO 9009_CRB 9010_RR 9011_BB 9013_JD 9019_TB 9023_WS
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
0.000000 257.000000 
0.000000 1332.000000 

for MYSUB in 9005_BG 9007_RB 9016_EB
do
EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${EXAM}/diffusion/Kwon_ROIs_ants/dentate_L_dil_lesionterm/fdt_paths -R
done
0.000000 552.000000 
0.000000 141.000000 
0.000000 2.000000 
#decided not to threshold the tracts

check_stn_ANTs.sh

analysis_generate_lesion_heatmap_and_CoM_ants.sh results_group_lesions_ants_062519

# previous command is not working, perhaps because there is no 3 month lesion for 9019
# Also the day 1 lesion seems to have been traced on a T1 that was shifted from the T1 used for all the other analysis. I am not sure how this could have happened. 

flirt -in /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/analysis_lesion_masks2other -ref /Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-15510/anat/T1.nii.gz -omat /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/analysis_lesion_masks2other.mat -dof 6

flirt -applyxfm -init /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/analysis_lesion_masks2other.mat -in /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1_lesion_mask_filled.nii.gz -ref /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/analysis_lesion_masks2other.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1_lesion_mask_filled2other 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1_lesion_mask_filled2other.nii.gz -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1_lesion_mask_filled2other_bin

fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1_lesion_mask_filled2other_bin -V
95 95.001373 

cp /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9019_TB-15510/anat/T1_lesion_mask_filled2other_bin.nii.gz /Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-15510/anat/T1_lesion_zonesIandII.nii.gz

analysis_ants_reg_one_subject.sh 9019_TB

check_stn_ANTs.sh

#I think I fixed the shift but it didn't fix the problem ...?????
#edited check_stn_ANTs.sh to use the 2mT1 lesion file if it exists


analysis_generate_lesion_heatmap_and_CoM_ants.sh /Users/erin/Desktop/Projects/MRGFUS/analysis/results_group_lesions_ants_062519



for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9019_TB 9021_WM 9023_WS
do
analysis_Kwon_ROIs_probtrackx_lesionterm_split_tracts_ants.sh ${MYSUB} `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'`
done

analysis_longitudinal_diffusion_in_pre_T1_space.sh 9019_TB 14038 15510 16071
analysis_longitudinal_diffusion_in_pre_T1_space.sh 9023_WS 14863 15860 16422



for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9019_TB 9021_WM 9023_WS
do
analysis_Kwon_ROIs_probtrackx_lesionterm_get_results_ants.sh $MYSUB `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` /Users/erin/Desktop/Projects/MRGFUS/analysis/results_lesionterm_ants_062819
done

analysis_Kwon_ROIs_probtrackx_makeROI_motorcortex_ants.sh



analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_ants.sh
NEED TO FIX 9019's CC mask - there is a little bit of the superior part of the body that is letting a few streamlines sneak through. 9023's is actually OK!
#manually fixed 9019 and re-ran


#####HERE### 
for MYSUB in 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9010_RR 9011_BB 9013_JD 9016_EB 9019_TB 9021_WM 9023_WS
do
analysis_Kwon_ROIs_probtrackx_lesion2motorcortex_dil_get_results_ants.sh $MYSUB `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` `sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` /Users/erin/Desktop/Projects/MRGFUS/analysis/results_lesion2motorcortex_dil_ants
done

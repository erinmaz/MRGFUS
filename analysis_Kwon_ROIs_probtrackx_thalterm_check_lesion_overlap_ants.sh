MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis


LESIONFILE=anat/xfms/ants/bet/T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz
for MYSUB in 9001_SH 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9011_BB 9013_JD 9021_WM 9022_JG 9023_WS 9024_LLB 9028_PR 9030_GA 9031_DB
do

PRE_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 

DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 

MONTH3_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 

DAY1_LESION=${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/${LESIONFILE}
MONTH3_LESION=${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/${LESIONFILE}
xcoord_lesion_standard=`fslstats ${DAY1_LESION} -c | awk '{print $1}'` #side of lesion shouldn't change between day 1 and month3, so just get it for day 1

#need to get month3 T1 into pre diff space to check three month lesion overlap (did this step in QA for day 1)

#convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_month3_2_diff_pre_bbr.mat -concat ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.mat

#convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_month3_2_diff_pre_bbr.mat -concat ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat

#applywarp -i ${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/anat/T1_lesion_mask_filled -r ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped -o ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff --interp=trilinear --premat=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_month3_2_diff_pre_bbr.mat

#fslmaths ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff -thr 0.5 -bin ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin

#fsleyes ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin 


if [ $(bc -l <<< "$xcoord_lesion_standard < 0") -eq 1 ]; then 
TREATED_DENTATE=R
UNTREATED_DENTATE=L
else
TREATED_DENTATE=L
UNTREATED_DENTATE=R
fi
side=$TREATED_DENTATE

outdir_dentate_R=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/dentate_R_dil_thalterm
outdir_dentate_L=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/dentate_L_dil_thalterm

if [ $side = "R" ]; then
vol=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`

volmonth3=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin -V | awk '{print $2}'`

else
vol=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
volmonth3=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin -V | awk '{print $2}'`
fi
vollesion=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`

vollesionmonth3=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin -V | awk '{print $2}'`
echo ${MYSUB} $vol $vollesion $volmonth3 $vollesionmonth3
done


LESIONFILE=anat/xfms/ants/T1_lesion_filled_mask_2_MNI152_T1_1mm.nii.gz
for MYSUB in 9010_RR 9016_EB
do

PRE_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $2}'` 

DAY1_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $3}'` 

MONTH3_EXAM=`sed -n '/'${MYSUB}'/p' ~/Desktop/Projects/MRGFUS/scripts/IDs_and_ExamNums.sh | awk '{print $4}'` 


DAY1_LESION=${ANALYSISDIR}/${MYSUB}-${DAY1_EXAM}/${LESIONFILE}
xcoord_lesion_standard=`fslstats ${DAY1_LESION} -c | awk '{print $1}'`

MONTH3_LESION=${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/${LESIONFILE}
#side of lesion shouldn't change between day 1 and month3, so just get it for day 1

#need to get month3 T1 into pre diff space to check three month lesion overlap (did this step in QA for day 1)

#convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_month3_2_diff_pre_bbr.mat -concat ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.mat

#convert_xfm -omat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_month3_2_diff_pre_bbr.mat -concat ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat

#applywarp -i ${ANALYSISDIR}/${MYSUB}-${MONTH3_EXAM}/anat/T1_lesion_mask_filled -r ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped -o ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff --interp=trilinear --premat=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/T1_month3_2_diff_pre_bbr.mat

#fslmaths ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff -thr 0.5 -bin ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin

#fsleyes ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin 


if [ $(bc -l <<< "$xcoord_lesion_standard < 0") -eq 1 ]; then 
TREATED_DENTATE=R
UNTREATED_DENTATE=L
else
TREATED_DENTATE=L
UNTREATED_DENTATE=R
fi
side=$TREATED_DENTATE

outdir_dentate_R=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/dentate_R_dil_thalterm
outdir_dentate_L=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/dentate_L_dil_thalterm

if [ $side = "R" ]; then
vol=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
volmonth3=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin -V | awk '{print $2}'`

else
vol=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
volmonth3=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin -V | awk '{print $2}'`
fi
vollesion=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
vollesionmonth3=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}-${PRE_EXAM}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled_month3_2diff_bin -V | awk '{print $2}'`


echo ${MYSUB} $vol $vollesion $volmonth3 $vollesionmonth3
done
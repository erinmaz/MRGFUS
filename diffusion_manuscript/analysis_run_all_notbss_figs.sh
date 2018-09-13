###### MAKE FIGURES ######################################################################

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
QADIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts/diffusion_manuscript
ROIDIR=${SCRIPTSDIR}/rois_standardspace
LESION_ANALYSIS=${MAINDIR}/analysis_lesion_masks
CURRENT_ANALYSIS=${MAINDIR}/analysis_diffusion_manuscript_310818
TCKINFO_OUTPUT=${CURRENT_ANALYSIS}/tckinfo_output.txt




SUBS=( 9001_SH 9002_RA 9004_EP 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD )

TREATMENT_SIDE=( L L L R L R L L )

PRETREATMENT_RUNS=( 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9013_JD-13455 )
DAY1_RUNS=( 9001_SH-11692 9002_RA-11833 9004_EP-12203 9005_BG-13126 9006_EO-12487 9007_RB-12910 9009_CRB-13043 9013_JD-13722 )
MONTH3_RUNS=( 9001_SH-12271 9002_RA-12388 9004_EP-12955 9005_BG-13837 9006_EO-13017 9007_RB-13055 9009_CRB-13623 9013_JD-14227 )

#THIS FIGURE HASN'T CHANGED, DON'T HAVE TO RERUN

mkdir ${CURRENT_ANALYSIS}/figure_lesion
mkdir ${CURRENT_ANALYSIS}/figure_lesion/9001
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9001/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9001/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9001/.
applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9001_SH-11692/anat/T1_lesion_mask_filled -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1 -o ${CURRENT_ANALYSIS}/figure_lesion/9001/lesion_day1_2_pre --interp=nn

applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9001_SH-12271/anat/T1_lesion_mask_filled -r  /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/anat/T1 -o ${CURRENT_ANALYSIS}/9001/figure_lesion/lesion_month3_2_pre --interp=nn

fsleyes ${CURRENT_ANALYSIS}/figure_lesion/9001/*.nii.gz

mkdir ${CURRENT_ANALYSIS}/figure_lesion/9004
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/anat/T1.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9004/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9004/.
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.nii.gz ${CURRENT_ANALYSIS}/figure_lesion/9004/.
applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_day1_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9004_EP-12203/anat/T1_lesion_mask_filled -r /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/anat/T1 -o ${CURRENT_ANALYSIS}/figure_lesion/9004/lesion_day1_2_pre --interp=nn

applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP_longitudinal_xfms_T1/T1_brain_month3_2_pre_6dof.mat -i /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/9004_EP-12955/anat/T1_lesion_mask_filled -r  /Users/erin/Desktop/Projects/MRGFUS/analysis/9004_EP-12126/anat/T1 -o ${CURRENT_ANALYSIS}/figure_lesion/9004/lesion_month3_2_pre --interp=nn

fsleyes ${CURRENT_ANALYSIS}/figure_lesion/9004/*.nii.gz



# Figure 2 - example ROIs. Display on day1 T1 space to show relationship with lesion

r=9004_EP-12126
q=9004_EP-12203
sub=9004_EP
applywarp --postmat=${CURRENT_ANALYSIS}/${sub}_longitudinal_xfms/day1_T1_brain_2_pre_T1_brain.mat -i ${QADIR}/${q}/anat/mT1 -o ${CURRENT_ANALYSIS}/${sub}_longitudinal_xfms/day1_T1_2_pre_T1 -r ${QADIR}/${r}/anat/mT1
fsleyes ${CURRENT_ANALYSIS}/${sub}_longitudinal_xfms/day1_T1_2_pre_T1 ${CURRENT_ANALYSIS}/${r}/rtt_from_cortex_include_lesion_nooverlap_bin2T1_nolesion_noneighbours_inferior_nothalamus ${CURRENT_ANALYSIS}/${r}/rtt_from_cortex_include_lesion_nooverlap_bin2T1_nolesion_noneighbours_thalamusonly  ${CURRENT_ANALYSIS}/${r}/rtt_from_cortex_include_lesion_nooverlap_bin2T1_nolesion_noneighbours_superior_nothalamus ${CURRENT_ANALYSIS}/${r}/superior_cerebellar_peduncle_L ${CURRENT_ANALYSIS}/${r}/superior_cerebellar_peduncle_R ${CURRENT_ANALYSIS}/${r}/middle_cerebellar_peduncle_L ${CURRENT_ANALYSIS}/${r}/middle_cerebellar_peduncle_R  


#Centre of mass of the lesions
index=0
for r in "${PRETREATMENT_RUNS[@]}"
do 
WARP_T1_to_STD=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp
mkdir ${CURRENT_ANALYSIS}/${DAY1_RUNS[${index}]}
applywarp --premat=${CURRENT_ANALYSIS}/${SUBS[$index]}_longitudinal_xfms/day1_T1_brain_2_pre_T1_brain.mat -w ${WARP_T1_to_STD} -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -i ${LESION_ANALYSIS}/${DAY1_RUNS[${index}]}/anat/T1_lesion_mask_filled -o ${CURRENT_ANALYSIS}/${DAY1_RUNS[${index}]}/T1_lesion_mask_filled2standard
fslmaths ${CURRENT_ANALYSIS}/${DAY1_RUNS[${index}]}/T1_lesion_mask_filled2standard -thr 0.5 -bin ${CURRENT_ANALYSIS}/${DAY1_RUNS[${index}]}/T1_lesion_mask_filled2standard
echo -n ${DAY1_RUNS[${index}]} " "
fslstats ${CURRENT_ANALYSIS}/${DAY1_RUNS[${index}]}/T1_lesion_mask_filled2standard -c
let index=$index+1
done

index=0
for r in "${PRETREATMENT_RUNS[@]}"
do 
WARP_T1_to_STD=${CURRENT_ANALYSIS}/${r}/xfms/T12MNI_1mm_warp
mkdir ${CURRENT_ANALYSIS}/${MONTH3_RUNS[${index}]}
applywarp --premat=${CURRENT_ANALYSIS}/${SUBS[$index]}_longitudinal_xfms/month3_T1_brain_2_pre_T1_brain.mat -w ${WARP_T1_to_STD} -r ${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -i ${LESION_ANALYSIS}/${MONTH3_RUNS[${index}]}/anat/T1_lesion_mask_filled -o ${CURRENT_ANALYSIS}/${MONTH3_RUNS[${index}]}/T1_lesion_mask_filled2standard
fslmaths ${CURRENT_ANALYSIS}/${MONTH3_RUNS[${index}]}/T1_lesion_mask_filled2standard -thr 0.5 -bin ${CURRENT_ANALYSIS}/${MONTH3_RUNS[${index}]}/T1_lesion_mask_filled2standard
echo -n ${MONTH3_RUNS[${index}]} " "
fslstats ${CURRENT_ANALYSIS}/${MONTH3_RUNS[${index}]}/T1_lesion_mask_filled2standard -c
let index=$index+1
done

mystr=""
for r in "${DAY1_RUNS[@]}"
do
mystr=`echo $mystr ${CURRENT_ANALYSIS}/${r}/T1_lesion_mask_filled2standard -add`
done

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9001_SH-11692/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9002_RA-11833/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9004_EP-12203/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13126/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9006_EO-12487/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-12910/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9009_CRB-13043/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9013_JD-13722/T1_lesion_mask_filled2standard /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/lesion_heatmap_day1

mystr=""
for r in "${MONTH3_RUNS[@]}"
do
mystr=`echo $mystr ${CURRENT_ANALYSIS}/${r}/T1_lesion_mask_filled2standard -add`
done


fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9001_SH-12271/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9002_RA-12388/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9004_EP-12955/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13837/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9006_EO-13017/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-13055/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9009_CRB-13623/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9013_JD-14227/T1_lesion_mask_filled2standard /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/lesion_heatmap_month3



#MRTRIX FIGURE
applywarp --postmat=/Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9004_EP_longitudinal_xfms/day1_T1_brain_2_pre_diff.mat -i ${QADIR}/9004_EP-12203/anat/mT1 -r ${QADIR}/9004_EP-12126/diffusion/mean_b0_unwarped -o /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9004_EP_longitudinal_xfms/day1_mT1_2_pre_diff

#added after Bruce's comments Sep 13, 2018
#heatmap with 9005 and 9007 flipped in to L, to calc COG
fslswapdim /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13126/T1_lesion_mask_filled2standard -x y z /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13126/T1_lesion_mask_filled2standard_swap
fslswapdim /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-12910/T1_lesion_mask_filled2standard -x y z /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-12910/T1_lesion_mask_filled2standard_swap
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9001_SH-11692/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9002_RA-11833/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9004_EP-12203/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13126/T1_lesion_mask_filled2standard_swap -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9006_EO-12487/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-12910/T1_lesion_mask_filled2standard_swap -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9009_CRB-13043/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9013_JD-13722/T1_lesion_mask_filled2standard /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/lesion_heatmap_day1_all_in_L
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/lesion_heatmap_day1_all_in_L -c 

fslswapdim /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13837/T1_lesion_mask_filled2standard -x y z /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13837/T1_lesion_mask_filled2standard_swap
fslswapdim /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-13055/T1_lesion_mask_filled2standard -x y z /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-13055/T1_lesion_mask_filled2standard_swap
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9001_SH-12271/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9002_RA-12388/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9004_EP-12955/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9005_BG-13837/T1_lesion_mask_filled2standard_swap -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9006_EO-13017/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9007_RB-13055/T1_lesion_mask_filled2standard_swap -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9009_CRB-13623/T1_lesion_mask_filled2standard -add /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/9013_JD-14227/T1_lesion_mask_filled2standard /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/lesion_heatmap_month3_all_in_L
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis_diffusion_manuscript_310818/lesion_heatmap_month3_all_in_L -c
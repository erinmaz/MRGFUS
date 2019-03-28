MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis


for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127

do
PREFIX=${MYSUB%??????}
DAY1=`ls -d /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${PREFIX}* | head -1`
DAY1_ID=`basename ${DAY1}`
DAY1_ANALYSIS=${ANALYSISDIR}/${DAY1_ID}
DAY1_LESION=${MAINDIR}/analysis_lesion_masks/${DAY1_ID}
xcoord_lesion_standard=`fslstats ${DAY1_LESION}/anat/T1_lesion_mask_filled2MNI_1mm -c | awk '{print $1}'`

if [ $(bc -l <<< "$xcoord_lesion_standard < 0") -eq 1 ]; then 
TREATED_DENTATE=R
UNTREATED_DENTATE=L
else
TREATED_DENTATE=L
UNTREATED_DENTATE=R
fi
side=$TREATED_DENTATE

outdir_dentate_R=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_R_dil_2_cortex_dil
outdir_dentate_L=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_L_dil_2_cortex_dil

if [ $side = "R" ]; then
vol=`fslstats ${outdir_dentate_R}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
else
vol=`fslstats ${outdir_dentate_L}/fdt_paths -k /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`
fi
vollesion=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -V | awk '{print $2}'`

echo $MYSUB `basename ${DAY1}` $vol $vollesion 
done
for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 9010_RR-13130
#for MYSUB in 9001_SH-11644 
#for MYSUB in 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 9010_RR-13130
do
echo $MYSUB

echo dentate_R_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil -V`
echo SCP_R_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil -V`
echo RN_L_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil -V ``
echo motorcortex_L `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_L -V`
echo exclude_R2 `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R2 -V`
 
echo cerebellum_L `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L -V`
echo ALIC_L `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L -V`
echo thalamus_R `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R -V`

echo dentate_L_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil -V`
echo SCP_L_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil -V`
echo RN_R_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil -V`
echo motorcortex_R `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_R -V`
echo exclude_L2 `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L2 -V`

echo cerebellum_R `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R -V`
echo ALIC_R `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R -V`
echo thalamus_L `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L -V`

echo midsag_CC_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -V`
echo brainstem_slice_below_pons_dil `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -V`
echo optic_chiasm `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm -V`
echo frontal_pole `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole -V`
echo AC `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -V`
echo occipital_lobe `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/occipital_lobe -V`
echo temporal_lobe `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/temporal_lobe -V`
echo csf `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf -V`




done
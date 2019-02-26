string=""

 echo REGIONS >> regions.txt
 echo dentate_R_dil >> regions.txt
 echo SCP_R_dil >> regions.txt
 echo RN_L_dil  >> regions.txt
 echo motorcortex_L >> regions.txt
 echo exclude_R2 >> regions.txt
 echo cerebellum_L >> regions.txt
 echo ALIC_L >> regions.txt
 echo thalamus_R  >> regions.txt
 echo dentate_L_dil  >> regions.txt
 echo SCP_L_dil  >> regions.txt
 echo RN_R_dil >> regions.txt
 echo motorcortex_R >> regions.txt
 echo exclude_L2 >> regions.txt
 echo cerebellum_R  >> regions.txt
 echo ALIC_R >> regions.txt
 echo thalamus_L >> regions.txt
 echo midsag_CC_dil  >> regions.txt
 echo brainstem_slice_below_pons_dil  >> regions.txt
 echo optic_chiasm  >> regions.txt
 echo frontal_pole >> regions.txt
 echo AC >> regions.txt
 echo occipital_lobe >> regions.txt
 echo temporal_lobe >> regions.txt
# echo csf >> regions.txt
 echo left_dentate_tract >> regions.txt
 echo left_dentate_waytotal >> regions.txt
 echo right_dentate_tract >> regions.txt
 echo right_dentate_waytotal >> regions.txt
 
 string=`echo $string regions.txt`
 outdir_L=dentate_L_dil_exclude2_corticalwaypoint
 outdir_R=dentate_R_dil_exclude2_corticalwaypoint
 #outdir_R=dentate_R_dil_thalterm
#outdir_L=dentate_L_dil_thalterm
#outdir_R=dentate_R_dil_thalwaypoint
#outdir_L=dentate_L_dil_thalwaypoint
#  outdir_L=dentate_L_dil_exclude2_corticalwaypoint_dilmore
# outdir_R=dentate_R_dil_exclude2_corticalwaypoint_dilmore
# outdir_L=dentate_L_dil_exclude2_thalterm_dilmore
# outdir_R=dentate_R_dil_exclude2_thalterm_dilmore
outdir_L=dentate_L_dil_exclude2_cortical_thal_waypoint_dilmore
outdir_R=dentate_R_dil_exclude2_cortical_thal_waypoint_dilmore

 for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
#for MYSUB in 9001_SH-11644 
#for MYSUB in 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 9010_RR-13130 
do 
echo $MYSUB >> ${MYSUB}.txt

 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil -V | awk '{print $2}' >> ${MYSUB}.txt
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_L -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R2 -V | awk '{print $2}' >> ${MYSUB}.txt
 
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L -V | awk '{print $2}' >> ${MYSUB}.txt
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R -V | awk '{print $2}' >> ${MYSUB}.txt

fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil -V | awk '{print $2}' >> ${MYSUB}.txt
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_R -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L2 -V | awk '{print $2}' >> ${MYSUB}.txt

fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L -V | awk '{print $2}' >> ${MYSUB}.txt

fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -V | awk '{print $2}' >> ${MYSUB}.txt
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -V | awk '{print $2}' >> ${MYSUB}.txt
fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/occipital_lobe -V | awk '{print $2}' >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/temporal_lobe -V | awk '{print $2}' >> ${MYSUB}.txt
# fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf -V | awk '{print $2}' >> ${MYSUB}.txt
 
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/${outdir_L}/fdt_paths -V | awk '{print $2}' >> ${MYSUB}.txt
 more /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/${outdir_L}/waytotal >> ${MYSUB}.txt
 fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/${outdir_R}/fdt_paths -V | awk '{print $2}' >> ${MYSUB}.txt
 more /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/${outdir_R}/waytotal >> ${MYSUB}.txt
 
string=`echo $string ${MYSUB}.txt`
done 
paste -d , $string > refined_vols.txt
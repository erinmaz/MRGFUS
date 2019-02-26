for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
#for MYSUB in 9001_SH-11644 
#for MYSUB in 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 
#for MYSUB in HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
#for MYSUB in 9001_SH-11644 9010_RR-13130 9011_BB-13042 9013_JD-13455
do

#probtrackx2 calls from fixoverlap2 directly

seed_r=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil -V | awk '{print $2}'`
exclude_r=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R2 -V | awk '{print $2}'`
i=0
while read line; do
array_r[$i]=`fslstats $line -V | awk '{print $2}'`
i=$(($i+1))
done</Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waypoints.txt
fdt_r=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/fdt_paths -V | awk '{print $2}'`
waytotal_r=`more /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waytotal`
 
fdt_r=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/fdt_paths -V | awk '{print $2}'`
waytotal_r=`more /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waytotal`
 
seed_l=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil -V | awk '{print $2}'`
exclude_l=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L2 -V | awk '{print $2}'`
i=0
while read line; do
array_l[$i]=`fslstats $line -V | awk '{print $2}'`
i=$(($i+1))
done</Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waypoints.txt

fdt_l=`fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/fdt_paths -V | awk '{print $2}'`
waytotal_l=`more /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waytotal`

echo $MYSUB $seed_r $exclude_r ${array_r[*]} $fdt_r $waytotal_r $seed_l $exclude_l ${array_l[*]} $fdt_l $waytotal_l


done
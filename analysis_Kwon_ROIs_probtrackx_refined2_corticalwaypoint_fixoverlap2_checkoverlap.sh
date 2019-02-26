for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
#for MYSUB in 9001_SH-11644 
#for MYSUB in 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 
#for MYSUB in HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
#for MYSUB in 9001_SH-11644 9010_RR-13130 9011_BB-13042 9013_JD-13455
do

#probtrackx2 calls from fixoverlap2 directly

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil -mas /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf tmp
fslstats tmp -V
i=0
while read line; do
fslmaths $line -mas /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf tmp
fslstats tmp -V
i=$(($i+1))
done</Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil_exclude2_corticalwaypoint/waypoints.txt

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil -mas /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf tmp
fslstats tmp -V
i=0
while read line; do
fslmaths $line -mas /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/csf tmp
fslstats tmp -V
i=$(($i+1))
done</Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil_exclude2_corticalwaypoint/waypoints.txt


done
MYSUB=9001_SH-11644
MYSUB=9002_RA-11764
MYSUB=9004_EP-12126
MYSUB=9005_BG-13004
MYSUB=9006_EO-12389
MYSUB=9007_RB-12461
MYSUB=9009_CRB-12609
MYSUB=9011_BB-13042
MYSUB=9013_JD-13455
MYSUB=9016_EB-13634
MYSUB=9021_WM-14127
MYSUB=9010_RR-13130
rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L
echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L > /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L.nii.gz  -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L/waypoints.txt  --waycond=AND


rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R
echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R > /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R.nii.gz  -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R/waypoints.txt  --waycond=AND

mystring=""
cd /Users/erin/Desktop/Projects/MRGFUS/analysis
for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127
do
#dentate_L=`fslstats ${MYSUB}/diffusion/Kwon_ROIs/dentate_L -V | awk '{print $2}'`
#dentate_R=`fslstats ${MYSUB}/diffusion/Kwon_ROIs/dentate_R -V | awk '{print $2}'`
#SCP_L=`fslstats ${MYSUB}/diffusion/Kwon_ROIs/SCP_L -V | awk '{print $2}'`
#SCP_R=`fslstats ${MYSUB}/diffusion/Kwon_ROIs/SCP_R -V | awk '{print $2}'`
#RN_L=`fslstats ${MYSUB}/diffusion/Kwon_ROIs/RN_L -V | awk '{print $2}'`
#RN_R=`fslstats ${MYSUB}/diffusion/Kwon_ROIs/RN_R -V | awk '{print $2}'`
#waytotal_dentate_L=`more ${MYSUB}/diffusion/Kwon_ROIs/dentate_L/waytotal`
#waytotal_dentate_R=`more ${MYSUB}/diffusion/Kwon_ROIs/dentate_R/waytotal`

applywarp -i ${MYSUB}/diffusion/Kwon_ROIs/dentate_L/fdt_paths -r /usr/local/fsl/data/standard/MNI152_T1_1mm -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp --premat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/diff_2_T1_bbr.mat -o ${MYSUB}/diffusion/Kwon_ROIs/dentate_L/fdt_paths2standard --interp=nn

applywarp -i ${MYSUB}/diffusion/Kwon_ROIs/dentate_R/fdt_paths -r /usr/local/fsl/data/standard/MNI152_T1_1mm -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warp --premat=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/xfms/diff_2_T1_bbr.mat -o ${MYSUB}/diffusion/Kwon_ROIs/dentate_R/fdt_paths2standard --interp=nn

mystring=`echo $mystring ${MYSUB}/diffusion/Kwon_ROIs/dentate_L/fdt_paths2standard ${MYSUB}/diffusion/Kwon_ROIs/dentate_R/fdt_paths2standard`

#echo $MYSUB $dentate_L $SCP_L $RN_R $waytotal_dentate_L $dentate_R $SCP_R $RN_L $waytotal_dentate_R 
done
fsleyes $mystring
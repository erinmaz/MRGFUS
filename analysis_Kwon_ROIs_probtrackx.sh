rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_L
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_L
/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_L.nii.gz  -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_L --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_L/waypoints.txt  --waycond=AND


rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_R
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_R
/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_R.nii.gz  -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_R --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9001_SH-11644/diffusion/Kwon_ROIs/dentate_R/waypoints.txt  --waycond=AND


rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L
echo /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/SCP_L > /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/RN_R >> /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L.nii.gz  -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_L/waypoints.txt  --waycond=AND


rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R
echo /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/SCP_R > /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/RN_L >> /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R.nii.gz  -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R --waypoints=/Users/erin/Desktop/Projects/MRGFUS/analysis/9002_RA-11764/diffusion/Kwon_ROIs/dentate_R/waypoints.txt  --waycond=AND



MYSUB=9004_EP-12126
MYSUB=9005_BG-13004
MYSUB=9006_EO-12389
MYSUB=9007_RB-12461
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




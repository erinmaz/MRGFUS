#left thalamus lesions
for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9006_EO-12389 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9021_WM-14127
do
outdir_dentate_R=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_R_dil_lesionterm
rm -rf ${outdir_dentate_R}
mkdir -p ${outdir_dentate_R}

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/SCP_R_dil > ${outdir_dentate_R}/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/RN_L_dil >> ${outdir_dentate_R}/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin >> ${outdir_dentate_R}/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_R_dil -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=${outdir_dentate_R} --waypoints=${outdir_dentate_R}/waypoints.txt  --waycond=AND --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_R --wtstop=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped ${outdir_dentate_R}/fdt_paths &

done

#right thalamus lesions
for MYSUB in 9005_BG-13004 9007_RB-12461 9016_EB-13634

do
outdir_dentate_L=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_L_dil_lesionterm
rm -rf ${outdir_dentate_L}
mkdir -p ${outdir_dentate_L}

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/SCP_L_dil > ${outdir_dentate_L}/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/RN_R_dil >> ${outdir_dentate_L}/waypoints.txt

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin >> ${outdir_dentate_L}/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/dentate_L_dil -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=${outdir_dentate_L} --waypoints=${outdir_dentate_L}/waypoints.txt  --waycond=AND --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_L --wtstop=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped ${outdir_dentate_L}/fdt_paths &
done


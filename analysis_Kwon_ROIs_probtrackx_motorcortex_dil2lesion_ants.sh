#left thalamus lesions
for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9006_EO-12389 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9021_WM-14127
do
outdir_lesion=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/motorcortex_dil2lesion
rm -rf ${outdir_lesion}
mkdir -p ${outdir_lesion}

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin > ${outdir_lesion}/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_L2diff_dilM -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=${outdir_lesion} --waypoints=${outdir_lesion}/waypoints.txt --waycond=AND --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_R --wtstop=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped ${outdir_lesion}/fdt_paths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_L2diff_dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_R  &

done

#right thalamus lesions
for MYSUB in 9005_BG-13004 9007_RB-12461 9016_EB-13634

do
outdir_lesion=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/motorcortex_dil2lesion
rm -rf ${outdir_lesion}
mkdir -p ${outdir_lesion}

echo echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin > ${outdir_lesion}/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_R2diff_dilM -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=${outdir_lesion} --waypoints=${outdir_lesion}/waypoints.txt --waycond=AND --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_L --wtstop=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped ${outdir_lesion}/fdt_paths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_R2diff_dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_L &
done


#left thalamus lesions
MYSUB=${1}-${2}

outdir_lesion=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/lesion2motorcortex_dil
rm -rf ${outdir_lesion}
mkdir -p ${outdir_lesion}

echo /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_L2diff_dilM > ${outdir_lesion}/waypoints.txt

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin -l --onewaycondition --wayorder -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=${outdir_lesion} --waypoints=${outdir_lesion}/waypoints.txt --waycond=AND --wtstop=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_L2diff_dilM --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_R

fsleyes /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/mean_b0_unwarped ${outdir_lesion}/fdt_paths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/T1_lesion_mask_filled2diff_bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/harvardoxford-cortical_prob_Precentral+Juxtapositional_L2diff_dilM /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/Kwon_ROIs_ants/exclude_R &

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
OUTDIR=/Users/erin/Desktop/Projects/MRGFUS/analysis
outdir_L=$1
outdir_R=$2
outfile=$3
string=""

echo REGIONS >> ${OUTDIR}/regions.txt
echo dentate_R_dil >> ${OUTDIR}/regions.txt
echo SCP_R_dil >> ${OUTDIR}/regions.txt
echo RN_L_dil  >> ${OUTDIR}/regions.txt
echo motorcortex_L >> ${OUTDIR}/regions.txt
echo exclude_R2 >> ${OUTDIR}/regions.txt
echo cerebellum_L >> ${OUTDIR}/regions.txt
echo ALIC_L >> ${OUTDIR}/regions.txt
echo thalamus_R  >> ${OUTDIR}/regions.txt
echo dentate_L_dil  >> ${OUTDIR}/regions.txt
echo SCP_L_dil  >> ${OUTDIR}/regions.txt
echo RN_R_dil >> ${OUTDIR}/regions.txt
echo motorcortex_R >> ${OUTDIR}/regions.txt
echo exclude_L2 >> ${OUTDIR}/regions.txt
echo cerebellum_R  >> ${OUTDIR}/regions.txt
echo ALIC_R >> ${OUTDIR}/regions.txt
echo thalamus_L >> ${OUTDIR}/regions.txt
echo midsag_CC_dil  >> ${OUTDIR}/regions.txt
echo brainstem_slice_below_pons_dil  >> ${OUTDIR}/regions.txt
echo optic_chiasm  >> ${OUTDIR}/regions.txt
echo frontal_pole >> ${OUTDIR}/regions.txt
echo AC >> ${OUTDIR}/regions.txt
echo occipital_lobe >> ${OUTDIR}/regions.txt
echo temporal_lobe >> ${OUTDIR}/regions.txt
echo left_dentate_tract >> ${OUTDIR}/regions.txt
echo right_dentate_tract >> ${OUTDIR}/regions.txt
 
string=`echo $string ${OUTDIR}/regions.txt` 

for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127 HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436
do 
echo $MYSUB >> ${OUTDIR}/${MYSUB}.txt

fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_R_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_R_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_L_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_L -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_R2 -M >> ${OUTDIR}/${MYSUB}.txt
 
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_L -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_L -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_R -M >> ${OUTDIR}/${MYSUB}.txt

fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/dentate_L_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/SCP_L_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/RN_R_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/Precentral+Juxtapositional_R -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/exclude_L2 -M >> ${OUTDIR}/${MYSUB}.txt

fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/cerebellum_R -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/ALIC_R -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/thalamus_L -M >> ${OUTDIR}/${MYSUB}.txt

fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/midsag_CC_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/brainstem_slice_below_pons_dil -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/optic_chiasm -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/frontal_pole -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/AC -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/occipital_lobe -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/temporal_lobe -M >> ${OUTDIR}/${MYSUB}.txt
 
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/${outdir_L}/fdt_paths -M >> ${OUTDIR}/${MYSUB}.txt
fslstats ${MAINDIR}/analysis/${MYSUB}/diffusion/dw_tsnr -k ${MAINDIR}/analysis/${MYSUB}/diffusion/Kwon_ROIs/${outdir_R}/fdt_paths -M >> ${OUTDIR}/${MYSUB}.txt
 
string=`echo $string ${OUTDIR}/${MYSUB}.txt`
done 
paste -d , $string > ${outfile}
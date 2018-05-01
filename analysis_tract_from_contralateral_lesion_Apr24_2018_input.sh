# script to track from day1 T1 lesion, using midsag plane as an exclusion mask

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
MYSUB=${1}-${2}
#day1 rs_reg.feat/reg folder
REG=${3}
#current session warp (standard2highres) from rs_reg.feat folder
WARP=${4}
#postmat used in applywarp, varies depending on timepoint being analyzed
POSTMAT=${5}
THALAMUS_ROI=${6}
lesion=${7}

#get midsag plane from standard space to diffusion space

#mkdir ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018
#mkdir ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10

#invwarp -w ${ANALYSISDIR}/${MYSUB}/fmri/rs_reg.feat/reg/highres2standard_warp -o ${WARP} -r ${ANALYSISDIR}/${MYSUB}/fmri/rs_reg.feat/reg/highres 

#get into input space
#applywarp -i ${SCRIPTSDIR}/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -w ${WARP}  --postmat=${POSTMAT} -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC

#get into input space
applywarp -i ${THALAMUS_ROI} -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -w ${WARP} --postmat=${POSTMAT} -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_contralateral --interp=nn 

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_contralateral -binv ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_contralateral_inv

#fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC -bin ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC_bin

#Get lesion into standard space, flip into untreated hemisphere, and then get into input space THIS DOESN'T WORK FOR NON-DAY1 data
applywarp -i ${lesion} -r ${REG}/standard -w ${REG}/highres2standard_warp -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/lesion2standard --interp=nn

fslswapdim ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/lesion2standard -x y z ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/lesion2standard_contralateral

applywarp -i ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/lesion2standard_contralateral -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -w ${REG}/standard2highres_warp -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral --postmat=${POSTMAT} --interp=nn

#Get into input space
#applywarp -i ${lesion} -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion --postmat=${POSTMAT} --interp=nn

rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC

/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=10.0 --sampvox=0.0 --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC_bin.nii.gz --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC

waytotal=`more ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm -thr 0.01 -bin ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin

#we get negative values in final ROIs if we subtract a lesion from a tract if there were voxels in the lesion that had 0 streamlines. Corrected fslmaths call below
#fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral -binv /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral_inv

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin -mas /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral_inv ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion

LESION_COG=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral -C`
coords=( $LESION_COG )

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -roi 0 -1 0 -1 ${coords[2]} -1 0 1  ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior

#NEW
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -roi 0 -1 0 -1 0 ${coords[2]} 0 1  ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -mas ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_contralateral ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior -mas ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_contralateral_inv ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus

#NEW
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior -mas ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_contralateral_inv ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus

fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus &

FA_lesion=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion_contralateral -M`

FA_tract_nolesion=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -M`

FA_tract_nolesion_superior=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior -M`

FA_tract_nolesion_superior_outside_thal=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus -M`

FA_tract_nolesion_inferior=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior -M`

FA_tract_nolesion_inferior_outside_thal=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus -M`

FA_tract_nolesion_inside_thal=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_contralateral_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus -M`
echo $MYSUB ${FA_lesion} ${FA_tract_nolesion} ${FA_tract_nolesion_superior} ${FA_tract_nolesion_superior_outside_thal} ${FA_tract_nolesion_inside_thal} ${FA_tract_nolesion_inferior} ${FA_tract_nolesion_inferior_outside_thal} >> ${MAINDIR}/analysis/Apr24_2018_FA_minlength_10_contralateral.txt

#get rings in sub diffusion space? 

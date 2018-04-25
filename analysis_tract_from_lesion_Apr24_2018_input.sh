# script to track from day1 T1 lesion, using midsag plane as an exclusion mask

MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
MYSUB=${1}-${2}
#day1 standard2highres warp from rs_reg
WARP=${3}
#postmat used in applywarp, varies depending on timepoint being analyzed
POSTMAT=${4}
THALAMUS_ROI=${5}
lesion=${6}

#get midsag plane from standard space to diffusion space

mkdir ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018

#invwarp -w ${ANALYSISDIR}/${MYSUB}/fmri/rs_reg.feat/reg/highres2standard_warp -o ${WARP} -r ${ANALYSISDIR}/${MYSUB}/fmri/rs_reg.feat/reg/highres 

#get into 3m diff space
#standard to day1 T1 to pre T1 to pre diff

applywarp -i ${SCRIPTSDIR}/rois_standardspace/midsag_plane_CC_MNI152_T1_2mm -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -w ${WARP}  --postmat=${POSTMAT} -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC

#get into 3, space
applywarp -i ${THALAMUS_ROI} -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -w ${WARP} --postmat=${POSTMAT} -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_treatment_side --interp=nn 

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_treatment_side -binv ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_treatment_side_inv

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC -bin ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC_bin

#Get into 3m-space
applywarp -i ${lesion} -r ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -o ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion --postmat=${POSTMAT} --interp=nn

mkdir ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018

rm -rf /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC
mkdir -p /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC
/usr/local/fsl/bin/probtrackx2  -x /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion.nii.gz  -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC_bin.nii.gz --forcedir --opd -s /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/merged -m /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/nodif_brain_mask  --dir=/Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC

waytotal=`more ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/waytotal`

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths -div $waytotal ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm -thr 0.01 -bin ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin -sub /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion

LESION_COG=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion -C`
coords=( $LESION_COG )

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -roi 0 -1 0 -1 ${coords[2]} -1 0 1  ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -mas ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_treatment_side ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior -mas ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/thalamus_treatment_side_inv ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus

fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/midsag_plane_CC_bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus &

FA_lesion=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion/rois_Apr24_2018/day1_T1_lesion -M`

FA_tract_nolesion=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -M`

FA_tract_nolesion_superior=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior -M`

FA_tract_nolesion_superior_outside_thal=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_superior_outside_thalamus -M`

FA_tract_nolesion_inside_thal=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA -k ${ANALYSISDIR}/${MYSUB}/diffusion.bedpostX/Apr24_2018/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_thalamus -M`
echo $MYSUB ${FA_lesion} ${FA_tract_nolesion} ${FA_tract_nolesion_superior} ${FA_tract_nolesion_superior_outside_thal} ${FA_tract_nolesion_inside_thal} >> ${MAINDIR}/analysis/Apr24_2018_FA.txt

#get rings in sub diffusion space

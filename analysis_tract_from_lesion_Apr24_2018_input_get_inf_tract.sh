cd /Users/erin/Desktop/Projects/MRGFUS/analysis 
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12126 9004_EP-12203 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 
do 
LESION_COG=`fslstats ${f}/diffusion/rois_Apr24_2018/day1_T1_lesion -C`
coords=( $LESION_COG )
fslmaths ${f}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion -roi 0 -1 0 -1 0 ${coords[2]} 0 1  ${f}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior
fslmaths ${f}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior -mas ${f}/diffusion/rois_Apr24_2018/thalamus_treatment_side_inv ${f}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus

FA_tract_nolesion_inferior=`fslstats ${f}/diffusion/dtifit_FA -k ${f}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior -M`

FA_tract_nolesion_inferior_outside_thal=`fslstats ${f}/diffusion/dtifit_FA -k ${f}/diffusion.bedpostX/Apr24_2018_minlength10/day1_lesion_exclude_midsag_plane_CC/fdt_paths_norm_thr0.01_bin_nolesion_inferior_outside_thalamus -M`

echo $f ${FA_tract_nolesion_inferior} ${FA_tract_nolesion_inferior_outside_thal} >> May1_2018_FA_minlength_10_inferior.txt
done 
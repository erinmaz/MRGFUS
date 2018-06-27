# manually xfmed to ACPC space rotating x by 6.5, saved as /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/09c_2_ACPC_aligned.mat

# first get all the relevant files from Ayca in ACPC aligned space
applywarp -i /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mallar_bertrand_thalamus_atlas_to_icbm_nifti.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned.nii.gz -o /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mallar_bertrand_thalamus_atlas_to_icbm_nifti_ACPC_aligned --interp=nn --postmat=/Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/09c_2_ACPC_aligned.mat

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/rois/thalamus.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned.nii.gz  --interp=nn --postmat=/Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/09c_2_ACPC_aligned.mat -o /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/rois/thalamus_to_ACPC_aligned

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/Vim.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned.nii.gz  --interp=nn --postmat=/Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/09c_2_ACPC_aligned.mat -o /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/Vim_to_ACPC_aligned

# now reg colin27 to 2009c ACPC aligned
 flirt -in /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin.nii.gz -ref /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned.nii.gz -out /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned -omat /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned.mat

fnirt --ref=/Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned --in=/Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin --aff=/Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned.mat --cout=/Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/colin2mni_1mm_09c_warp --iout=/Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/colin2mni_1mm_90c --refmask=/Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_mask --config=T1_2_MNI152_2mm --warpres=10,10,10 

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin -r /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned -w /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/colin2mni_1mm_09c_warp -o /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned_nlin

applywarp --premat=/Users/erin/Desktop/Projects/MRGFUS/atlases/labels2colin.mat -i /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_nifti_integers.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned_nlin.nii.gz -o /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_nifti_integers_to_MNI152_2009c_ACPCaligned_nlin --interp=nn -w /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/colin2mni_1mm_09c_warp 

applywarp --premat=/Users/erin/Desktop/Projects/MRGFUS/atlases/labels2colin.mat -i /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/thalamus.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned_nlin.nii.gz -o /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/thalamus_to_MNI152_2009c_ACPCaligned_nlin --interp=nn -w /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/colin2mni_1mm_09c_warp 

applywarp --premat=/Users/erin/Desktop/Projects/MRGFUS/atlases/labels2colin.mat -i /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/Vim.nii.gz -r /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/mni_colin27_1998_nifti/colin27_t1_tal_lin_to_MNI152_2009c_ACPCaligned_nlin.nii.gz -o /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/Vim_to_MNI152_2009c_ACPCaligned_nlin --interp=nn -w /Users/erin/Desktop/Projects/MRGFUS/atlases/colin2mni_1mm/colin2mni_1mm_09c_warp 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_nifti_integers_to_MNI152_2009c_ACPCaligned_nlin -roi 0 96 0 -1 0 -1 0 -1 /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_nifti_integers_to_MNI152_2009c_ACPCaligned_nlin_Lhemi

fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/thalamus_to_MNI152_2009c_ACPCaligned_nlin -roi 0 96 0 -1 0 -1 0 -1 /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/thalamus_to_MNI152_2009c_ACPCaligned_nlin_Lhemi 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/Vim_to_MNI152_2009c_ACPCaligned_nlin -roi 0 96 0 -1 0 -1 0 -1 

fslstats /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/Vim_to_MNI152_2009c_ACPCaligned_nlin_Lhemi.nii.gz -V
297 297.000000 
Erins-MacBook-Pro:~ erin$ fslstats /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/Vim_to_ACPC_aligned.nii.gz -V
552 552.000000 

fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned  /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/mni_icbm152_t1_tal_nlin_sym_09c_ACPC_aligned  

fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/rois/thalamus_to_ACPC_aligned.nii.gz /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/thal_v1
fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/Vim_to_ACPC_aligned.nii.gz /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/Vim_v1
fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/FromAyca/mallar_bertrand_thalamus_atlas_to_icbm_nifti_ACPC_aligned.nii.gz /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/atlas_v1

fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_nifti_integers_to_MNI152_2009c_ACPCaligned_nlin_Lhemi.nii.gz /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/atlas_v2
fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/thalamus_to_MNI152_2009c_ACPCaligned_nlin_Lhemi.nii.gz /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/thal_v2
fslmaths /Users/erin/Desktop/Projects/MRGFUS/atlases/labels_on_colin_Nov2010_rois/Vim_to_MNI152_2009c_ACPCaligned_nlin_Lhemi.nii.gz  /Users/erin/GoogleDrive/DataForOthers/atlas_versions/MNI152_2009c_ACPC_aligned/Vim_v2
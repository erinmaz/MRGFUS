for MYSUB in 9001_SH-11644 9002_RA-11764 9004_EP-12126 9005_BG-13004 9006_EO-12389 9007_RB-12461 9009_CRB-12609 9010_RR-13130 9011_BB-13042 9013_JD-13455 9016_EB-13634 9021_WM-14127
#for MYSUB in HIFU_ET_C01-14458 HIFU_ET_C02-14709 hifu_et_c03-14983 HIFU_ET_C04-15436

do
PREFIX=${MYSUB%??????}
DAY1=`ls -d /Users/erin/Desktop/Projects/MRGFUS/analysis_lesion_masks/${PREFIX}* | head -1`
fslswapdim ${DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -x y z ${DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_xswap 
fsleyes ${FSLDIR}/data/standard/MNI152_T1_1mm ${DAY1}/anat/T1_lesion_mask_filled2MNI_1mm -cm "Red-Yellow" ${DAY1}/anat/T1_lesion_mask_filled2MNI_1mm_xswap -cm "Blue-Lightblue" &

done


MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

mkdir ${MAINDIR}/tbss
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017
do
cp ${ANALYSISDIR}/${f}/diffusion/dtifit_FA.nii.gz ${MAINDIR}/tbss/${f}_FA.nii.gz
done

cd ${MAINDIR}/tbss
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2


mkdir ${MAINDIR}/tbss/MD
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017
do
cp ${ANALYSISDIR}/${f}/diffusion/dtifit_MD.nii.gz ${MAINDIR}/tbss/MD/${f}_FA.nii.gz
done
tbss_non_FA MD

mkdir ${MAINDIR}/tbss/L1
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017
do
cp ${ANALYSISDIR}/${f}/diffusion/dtifit_L1.nii.gz ${MAINDIR}/tbss/L1/${f}_FA.nii.gz
done
tbss_non_FA L1

mkdir ${MAINDIR}/tbss/RD
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017
do
fslmaths ${ANALYSISDIR}/${f}/diffusion/dtifit_L2 -add ${ANALYSISDIR}/${f}/diffusion/dtifit_L3 -div 2 ${ANALYSISDIR}/${f}/diffusion/RD
cp ${ANALYSISDIR}/${f}/diffusion/RD.nii.gz ${MAINDIR}/tbss/RD/${f}_FA.nii.gz
done
tbss_non_FA RD


#split TBSS images so that the correct ones are associated with the correct subjects/timepoints

fslsplit stats/all_FA_skeletonised stats/FA_skeleton -t

mkdir ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images

fslmaths stats/FA_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/FA_pre

fslmaths stats/FA_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/FA_day1

fslmaths stats/FA_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/FA_3M

mkdir ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images

fslmaths stats/FA_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/FA_pre

fslmaths stats/FA_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/FA_day1

fslmaths stats/FA_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/FA_3M

mkdir ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images

fslmaths stats/FA_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/FA_pre

fslmaths stats/FA_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/FA_day1

fslmaths stats/FA_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/FA_3M

mkdir ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images

fslmaths stats/FA_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/FA_pre

fslmaths stats/FA_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/FA_day1

fslmaths stats/FA_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/FA_3M

fslsplit stats/all_MD_skeletonised stats/MD_skeleton -t

fslmaths stats/MD_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/MD_pre

fslmaths stats/MD_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/MD_day1

fslmaths stats/MD_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/MD_3M

fslmaths stats/MD_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/MD_pre

fslmaths stats/MD_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/MD_day1

fslmaths stats/MD_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/MD_3M

fslmaths stats/MD_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/MD_pre

fslmaths stats/MD_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/MD_day1

fslmaths stats/MD_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/MD_3M

fslmaths stats/MD_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/MD_pre

fslmaths stats/MD_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/MD_day1

fslmaths stats/MD_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/MD_3M


fslsplit stats/all_L1_skeletonised stats/L1_skeleton -t

fslmaths stats/L1_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/L1_pre

fslmaths stats/L1_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/L1_day1

fslmaths stats/L1_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/L1_3M

fslmaths stats/L1_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/L1_pre

fslmaths stats/L1_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/L1_day1

fslmaths stats/L1_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/L1_3M

fslmaths stats/L1_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/L1_pre

fslmaths stats/L1_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/L1_day1

fslmaths stats/L1_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/L1_3M

fslmaths stats/L1_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/L1_pre

fslmaths stats/L1_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/L1_day1

fslmaths stats/L1_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/L1_3M


fslsplit stats/all_RD_skeletonised stats/RD_skeleton -t

fslmaths stats/RD_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/RD_pre

fslmaths stats/RD_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/RD_day1

fslmaths stats/RD_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_images/RD_3M

fslmaths stats/RD_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/RD_pre

fslmaths stats/RD_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/RD_day1

fslmaths stats/RD_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_images/RD_3M

fslmaths stats/RD_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/RD_pre

fslmaths stats/RD_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/RD_day1

fslmaths stats/RD_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_images/RD_3M

fslmaths stats/RD_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/RD_pre

fslmaths stats/RD_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/RD_day1

fslmaths stats/RD_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_images/RD_3M



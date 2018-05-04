MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

mkdir ${MAINDIR}/tbss_Apr24_2018
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623
do
cp ${ANALYSISDIR}/${f}/diffusion/dtifit_FA.nii.gz ${MAINDIR}//tbss_Apr24_2018/${f}_FA.nii.gz
done

cd ${MAINDIR}/tbss_Apr24_2018
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2

#running above code

mkdir ${MAINDIR}/tbss_Apr24_2018/MD
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623
do
cp ${ANALYSISDIR}/${f}/diffusion/dtifit_MD.nii.gz ${MAINDIR}/tbss_Apr24_2018/MD/${f}_FA.nii.gz
done
tbss_non_FA MD

mkdir ${MAINDIR}/tbss_Apr24_2018/L1
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623
do
cp ${ANALYSISDIR}/${f}/diffusion/dtifit_L1.nii.gz ${MAINDIR}/tbss_Apr24_2018/L1/${f}_FA.nii.gz
done
tbss_non_FA L1

mkdir ${MAINDIR}/tbss_Apr24_2018/RD
for f in 9001_SH-11644 9001_SH-11692 9001_SH-12271 9002_RA-11764 9002_RA-11833 9002_RA-12388 9004_EP-12203 9004_EP-12126 9004_EP-12955 9006_EO-12389 9006_EO-12487 9006_EO-13017 9007_RB-12461 9007_RB-12910 9007_RB-13055 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623
do
fslmaths ${ANALYSISDIR}/${f}/diffusion/dtifit_L2 -add ${ANALYSISDIR}/${f}/diffusion/dtifit_L3 -div 2 ${ANALYSISDIR}/${f}/diffusion/RD
cp ${ANALYSISDIR}/${f}/diffusion/RD.nii.gz ${MAINDIR}/tbss_Apr24_2018/RD/${f}_FA.nii.gz
done
tbss_non_FA RD


#split TBSS images so that the correct ones are associated with the correct subjects/timepoints

fslsplit stats/all_FA_skeletonised stats/FA_skeleton -t

mkdir ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images

fslmaths stats/FA_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/FA_pre

fslmaths stats/FA_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/FA_day1

fslmaths stats/FA_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/FA_3M

mkdir ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images

fslmaths stats/FA_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/FA_pre

fslmaths stats/FA_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/FA_day1

fslmaths stats/FA_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/FA_3M

mkdir ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images

fslmaths stats/FA_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/FA_pre

fslmaths stats/FA_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/FA_day1

fslmaths stats/FA_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/FA_3M

mkdir ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images

fslmaths stats/FA_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/FA_pre

fslmaths stats/FA_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/FA_day1

fslmaths stats/FA_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/FA_3M

mkdir ${ANALYSISDIR}/9007_RB_diffusion_longitudinal
mkdir ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images

fslmaths stats/FA_skeleton0012 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/FA_pre

fslmaths stats/FA_skeleton0013 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/FA_day1

fslmaths stats/FA_skeleton0014 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/FA_3M

mkdir ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal
mkdir ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images

fslmaths stats/FA_skeleton0015 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/FA_pre

fslmaths stats/FA_skeleton0016 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/FA_day1

fslmaths stats/FA_skeleton0017 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/FA_3M

fslsplit stats/all_MD_skeletonised stats/MD_skeleton -t

fslmaths stats/MD_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/MD_pre

fslmaths stats/MD_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/MD_day1

fslmaths stats/MD_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/MD_3M

fslmaths stats/MD_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/MD_pre

fslmaths stats/MD_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/MD_day1

fslmaths stats/MD_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/MD_3M

fslmaths stats/MD_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/MD_pre

fslmaths stats/MD_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/MD_day1

fslmaths stats/MD_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/MD_3M

fslmaths stats/MD_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/MD_pre

fslmaths stats/MD_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/MD_day1

fslmaths stats/MD_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/MD_3M

fslmaths stats/MD_skeleton0012 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/MD_pre

fslmaths stats/MD_skeleton0013 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/MD_day1

fslmaths stats/MD_skeleton0014 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/MD_3M

fslmaths stats/MD_skeleton0015 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/MD_pre

fslmaths stats/MD_skeleton0016 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/MD_day1

fslmaths stats/MD_skeleton0017 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/MD_3M

fslsplit stats/all_RD_skeletonised stats/RD_skeleton -t

fslmaths stats/RD_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/RD_pre

fslmaths stats/RD_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/RD_day1

fslmaths stats/RD_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/RD_3M

fslmaths stats/RD_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/RD_pre

fslmaths stats/RD_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/RD_day1

fslmaths stats/RD_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/RD_3M

fslmaths stats/RD_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/RD_pre

fslmaths stats/RD_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/RD_day1

fslmaths stats/RD_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/RD_3M

fslmaths stats/RD_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/RD_pre

fslmaths stats/RD_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/RD_day1

fslmaths stats/RD_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/RD_3M

fslmaths stats/RD_skeleton0012 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/RD_pre

fslmaths stats/RD_skeleton0013 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/RD_day1

fslmaths stats/RD_skeleton0014 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/RD_3M

fslmaths stats/RD_skeleton0015 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/RD_pre

fslmaths stats/RD_skeleton0016 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/RD_day1

fslmaths stats/RD_skeleton0017 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/RD_3M

fslsplit stats/all_L1_skeletonised stats/L1_skeleton -t

fslmaths stats/L1_skeleton0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/L1_pre

fslmaths stats/L1_skeleton0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/L1_day1

fslmaths stats/L1_skeleton0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/L1_3M

fslmaths stats/L1_skeleton0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/L1_pre

fslmaths stats/L1_skeleton0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/L1_day1

fslmaths stats/L1_skeleton0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/L1_3M

fslmaths stats/L1_skeleton0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/L1_pre

fslmaths stats/L1_skeleton0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/L1_day1

fslmaths stats/L1_skeleton0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/L1_3M

fslmaths stats/L1_skeleton0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/L1_pre

fslmaths stats/L1_skeleton0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/L1_day1

fslmaths stats/L1_skeleton0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/L1_3M

fslmaths stats/L1_skeleton0012 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/L1_pre

fslmaths stats/L1_skeleton0013 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/L1_day1

fslmaths stats/L1_skeleton0014 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/L1_3M

fslmaths stats/L1_skeleton0015 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/L1_pre

fslmaths stats/L1_skeleton0016 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/L1_day1

fslmaths stats/L1_skeleton0017 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/L1_3M

for type in FA RD L1 MD
do

fslsplit stats/all_${type} stats/${type}_image -t

fslmaths stats/${type}_image0000 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_pre

fslmaths stats/${type}_image0001 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_day1

fslmaths stats/${type}_image0002 ${ANALYSISDIR}/9001_SH_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_3M

fslmaths stats/${type}_image0003 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_pre

fslmaths stats/${type}_image0004 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_day1

fslmaths stats/${type}_image0005 ${ANALYSISDIR}/9002_RA_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_3M

fslmaths stats/${type}_image0006 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_pre

fslmaths stats/${type}_image0007 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_day1

fslmaths stats/${type}_image0008 ${ANALYSISDIR}/9004_EP_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_3M

fslmaths stats/${type}_image0009 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_pre

fslmaths stats/${type}_image0010 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_day1

fslmaths stats/${type}_image0011 ${ANALYSISDIR}/9006_EO_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_3M

fslmaths stats/${type}_image0012 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_pre

fslmaths stats/${type}_image0013 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_day1

fslmaths stats/${type}_image0014 ${ANALYSISDIR}/9007_RB_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_3M

fslmaths stats/${type}_image0015 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_pre

fslmaths stats/${type}_image0016 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_day1

fslmaths stats/${type}_image0017 ${ANALYSISDIR}/9009_CRB_diffusion_longitudinal/tbss_Apr24_2018_images/${type}_image_3M

done

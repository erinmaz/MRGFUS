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
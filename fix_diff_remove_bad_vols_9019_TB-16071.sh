#!/bin/bash

MYSUB=9019_TB-16071
cp -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion /Users/erin/Desktop/Projects/MRGFUS/analysis/${MYSUB}/diffusion_auto


MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
ANALYSISDIR=${MAINDIR}/analysis
SCRIPTSDIR=${MAINDIR}/scripts_QA
DIFFDIR=${ANALYSISDIR}/${MYSUB}/diffusion

DICOMDIR=${MAINDIR}/dicoms

#################### GET SESSION INFO ##################################
file1=`find ${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO* -type f -not -name ".DS_Store" | head -1;` 
STUDYINFO=`dicom_hdr $file1 | egrep "ID Study Description" | cut -f5- -d "/"`
DATE=`dicom_hinfo -tag 0008,0020 -no_name $file1`

#################### GET COIL INFO ##################################
COIL=`dicom_hinfo -tag 0018,1250 -no_name $file1`
if [ "$COIL" = "RM:Nova32ch" ]; then
	MYCOIL=32ch
else
	MYCOIL=12ch
fi

for f in ${DICOMDIR}/${MYSUB}/*PUSAG_FSPGR_BRAVO*; do
    if [ -e "$f" ]; then
	PURET1=YES
	T1dir=$f
    else
	PURET1=NO
	T1dir=${DICOMDIR}/${MYSUB}/*SAG_FSPGR_BRAVO*
    fi
    break
done

mkdir ${DIFFDIR}/tmp
fslsplit ${DIFFDIR}/data_uncorrected ${DIFFDIR}/tmp/data_uncorrected -t

#rm vols 1,2, 43,44, 49,50

mystring=""
for i in 00 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 45 46 47 48 51 52 53 54 55 56
do
mystring=`echo $mystring ${DIFFDIR}/tmp/data_uncorrected00${i}`
done
fslmerge -t ${DIFFDIR}/data_uncorrected $mystring

#awk counts from 0, so remove 2,3,44,45,50,51
#awk '!($15="")' ${SCRIPTSDIR}/bvecs > ${DIFFDIR}/bvecs
awk '{print $1 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $20 " " $21 " " $22 " " $23 " " $24 " " $25 " " $26 " " $27 " " $28 " " $29 " " $30 " " $31 " " $32 " " $33 " " $34 " " $35 " " $36 " " $37 " " $38 " " $39 " " $40 " " $41 " " $42 " " $43 " " $46 " " $47 " " $48 " " $49 " " $52 " " $53 " " $54 " " $55 " " $56 " " $57}' ${SCRIPTSDIR}/bvals > ${DIFFDIR}/bvals
#awk '!($15="")' ${SCRIPTSDIR}/bvals > ${DIFFDIR}/bvals
awk '{print $1 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $20 " " $21 " " $22 " " $23 " " $24 " " $25 " " $26 " " $27 " " $28 " " $29 " " $30 " " $31 " " $32 " " $33 " " $34 " " $35 " " $36 " " $37 " " $38 " " $39 " " $40 " " $41 " " $42 " " $43 " " $46 " " $47 " " $48 " " $49 " " $52 " " $53 " " $54 " " $55 " " $56 " " $57}' ${SCRIPTSDIR}/bvecs > ${DIFFDIR}/bvecs
#awk '!(NR==15)' ${SCRIPTSDIR}/index.txt > $DIFFDIR/index.txt
sed '2d; 3d; 44d; 45d; 50d; 51d' ${SCRIPTSDIR}/index.txt > ${DIFFDIR}/index.txt
for f in ${DICOMDIR}/${MYSUB}/*PUDWI_45*; do
if [ -e "$f" ]; then
PUREdiff=YES
diff_fow_dir=$f
diff_rev_dir=${DICOMDIR}/${MYSUB}/*PUDWI_PE*
else
PUREdiff=NO
diff_fow_dir=${DICOMDIR}/${MYSUB}/*DWI_45*
diff_rev_dir=${DICOMDIR}/${MYSUB}/*DWI_PE*
fi
break
done

#NEED TO MAKE ALL B0
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_b0 0 1
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_b0 0 1
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/all_b0 ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_b0 ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_b0
sed -n '1p;4p'  ${SCRIPTSDIR}/acqp.txt > ${DIFFDIR}/acqp.txt

topup --imain=${ANALYSISDIR}/${MYSUB}/diffusion/all_b0 --datain=${DIFFDIR}/acqp.txt --config=b02b0.cnf --out=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --fout=${ANALYSISDIR}/${MYSUB}/diffusion/topup_field --iout=${ANALYSISDIR}/${MYSUB}/diffusion/all_b0_unwarped

#HERE

fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/all_b0_unwarped -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped
if [ "$MYCOIL" = "32ch" ]
then
	bet ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -m -f 0.3
else
	bet ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain -m
fi
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask 

time eddy_cpu --imain=${ANALYSISDIR}/${MYSUB}/diffusion/data_uncorrected --mask=${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask --acqp=${SCRIPTSDIR}/acqp_eddy.txt --index=${DIFFDIR}/index.txt --bvecs=${DIFFDIR}/bvecs --bvals=${DIFFDIR}/bvals --topup=${ANALYSISDIR}/${MYSUB}/diffusion/topup_results --cnr_maps --repol --out=${ANALYSISDIR}/${MYSUB}/diffusion/data
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/data &
dtifit -k ${ANALYSISDIR}/${MYSUB}/diffusion/data -o ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit -m ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -r ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_rotated_bvecs -b ${DIFFDIR}/bvals --sse
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_FA ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_V1 ${ANALYSISDIR}/${MYSUB}/diffusion/dtifit_sse &
#diffusion tsnr calc
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow 1 43
fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/data ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev 45 6
fslmerge -t ${ANALYSISDIR}/${MYSUB}/diffusion/dw ${ANALYSISDIR}/${MYSUB}/diffusion/dw_fow ${ANALYSISDIR}/${MYSUB}/diffusion/dw_rev
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tmean ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw -Tstd ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std
fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dw_mean -div ${ANALYSISDIR}/${MYSUB}/diffusion/dw_std ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_cnr_maps &
difftsnr=`fslstats ${ANALYSISDIR}/${MYSUB}/diffusion/dw_tsnr -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`
diffcnr=`fslstats -t ${ANALYSISDIR}/${MYSUB}/diffusion/data.eddy_cnr_maps -k ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask -M`

if [ "$PURET1" = "YES" ] && [ "$PUREdiff" = "YES" ] 
then
	T1fordiffreg=${ANATDIR}/T1
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped
elif [ "$PURET1" = "NO" ] && [ "$PUREdiff" = "NO" ] 
then
	T1fordiffreg=${ANATDIR}/T1
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped

elif [ "$PURET1" = "YES" ]
then
	#not very efficient, because I potentially run these lines twice (once for fMRI and once for diffusion)
	dcm2niix -z y -b n -f %d_s%s_e%e ${DICOMDIR}/${MYSUB}/*-SAG_FSPGR_BRAVO*
	mv ${DICOMDIR}/${MYSUB}/*-SAG_FSPGR_BRAVO*/*.nii.gz ${ANATDIR}/T1_noPURE.nii.gz
	fslmaths ${ANATDIR}/T1_noPURE -mas ${ANATDIR}/spm_mask ${ANATDIR}/T1_noPURE_brain
	T1fordiffreg=${ANATDIR}/T1_noPURE
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/mean_b0_unwarped

elif [ "$PUREdiff" = "YES" ]
then
	T1fordiffreg=${ANATDIR}/T1
	dcm2niix -z y -b n -f %d_s%s_e%e ${DICOMDIR}/${MYSUB}/*-DWI_45*
	mv ${DICOMDIR}/${MYSUB}/*-DWI_45*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE.nii.gz
	fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE ${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE_nodif 0 3
	dcm2niix -z y -b n -f %d_s%s_e%e ${DICOMDIR}/${MYSUB}/*-DWI_PE*
	mv ${DICOMDIR}/${MYSUB}/*-DWI_PE*/*.nii.gz ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE.nii.gz
	fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE ${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE_nodif 0 3
	applytopup --imain=${ANALYSISDIR}/${MYSUB}/diffusion/dti_fow_noPURE_nodif,${ANALYSISDIR}/${MYSUB}/diffusion/dti_rev_noPURE_nodif -t ${ANALYSISDIR}/${MYSUB}/diffusion/topup_results -o ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif -a ${SCRIPTSDIR}/acqp_eddy.txt --inindex=1,2
	fslroi ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif 0 1
	fslmaths ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif -mas ${ANALYSISDIR}/${MYSUB}/diffusion/nodif_brain_mask ${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif_brain
	diffforreg=${ANALYSISDIR}/${MYSUB}/diffusion/dti_noPURE_unwarped_nodif
fi
mkdir ${ANALYSISDIR}/${MYSUB}/diffusion/xfms
#flirt -in $diffforreg -ref $T1fordiffreg -omat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio -out ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff2str 

epi_reg --epi=${diffforreg} --t1=${T1fordiffreg} --t1brain=${T1fordiffreg}_brain --out=${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff_2_T1_bbr
convert_xfm -omat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat -inverse ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff_2_T1_bbr.mat
fsleyes ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/diff_2_T1_bbr ${T1fordiffreg} &

echo $difftsnr $diffcnr

fslmaths ${DIFFDIR}/data ${DIFFDIR}/data_extravols
fslsplit ${DIFFDIR}/data_extravols ${DIFFDIR}/tmp/data_extravols -t

mystring=""
for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 43 44 45 46 47 48 49 50 51 52 
do
mystring=`echo $mystring ${DIFFDIR}/tmp/data_extravols00${i}`
done
fslmerge -t ${DIFFDIR}/data $mystring

cp ${DIFFDIR}/data.eddy_rotated_bvecs ${DIFFDIR}/data.eddy_rotated_bvecs_extravols

awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $20 " " $21 " " $22 " " $23 " " $24 " " $25 " " $26 " " $27 " " $28 " " $29 " " $30 " " $31 " " $32 " " $33 " " $34 " " $35 " " $36 " " $37 " " $38 " " $39 " " $40 " " $41 " " $44 " " $45 " " $46 " " $47 " " $48 " " $49 " " $50 " " $51 " " $52 " " $53}' ${SCRIPTSDIR}/bvals > ${DIFFDIR}/bvals
#awk '!($15="")' ${SCRIPTSDIR}/bvals > ${DIFFDIR}/bvals
awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 " " $13 " " $14 " " $15 " " $16 " " $17 " " $18 " " $19 " " $20 " " $21 " " $22 " " $23 " " $24 " " $25 " " $26 " " $27 " " $28 " " $29 " " $30 " " $31 " " $32 " " $33 " " $34 " " $35 " " $36 " " $37 " " $38 " " $39 " " $40 " " $41 " " $44 " " $45 " " $46 " " $47 " " $48 " " $49 " " $50 " " $51 " " $52 " " $53}' ${DIFFDIR}/data.eddy_rotated_bvecs_extravols > ${DIFFDIR}/data.eddy_rotated_bvecs

dtifit -k ${DIFFDIR}/data -o ${DIFFDIR}/dtifit -m ${DIFFDIR}/nodif_brain_mask -r ${DIFFDIR}/data.eddy_rotated_bvecs -b ${DIFFDIR}/bvals --sse
fsleyes ${DIFFDIR}/dtifit_FA ${DIFFDIR}/dtifit_V1 ${DIFFDIR}/dtifit_sse &

#11 July 2019 - try niter=10 as per Conrad/Jesper Anderrsen
 time eddy_cpu --imain=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/data_uncorrected.nii.gz --mask=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/nodif_brain_mask.nii.gz --acqp=/Users/erin/Desktop/Projects/MRGFUS/scripts_QA/acqp_eddy.txt --index=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/index.txt --bvecs=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/bvecs --bvals=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/bvals --topup=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/topup_results --cnr_maps --repol --out=/Users/erin/Desktop/Projects/MRGFUS/analysis/9019_TB-16071/diffusion_niter10/data --niter=10

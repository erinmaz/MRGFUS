MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis

MYSUB=$1
MYSUB_TOTRACK=${MYSUB}-${2}
MYSUB_DAY1=${MYSUB}-${3}
TRACT_OUTPUT=$4
TREATMENTSIDE=$5

if [ ! $TREATMENTSIDE = "R" ]; then 
	OTHERSIDE=R
else OTHERSIDE=L
fi
	
mkdir ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}

MYSEED=${MAINDIR}/analysis_lesion_masks/${MYSUB_DAY1}/anat/T1_lesion_mask_filled
MYXFM=${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr.mat 
 
applywarp -i $MYSEED -r ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/standard -w ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/highres2standard_warp -o ${MYSEED}2standard --interp=spline

fslswapdim ${MYSEED}2standard -x y z ${MYSEED}2standard_contralateral

if [ ! -f ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/standard2highres_warp.nii.gz ]; then
invwarp -w ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/highres2standard_warp -o ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/standard2highres_warp -r ${ANALYSISDIR}/${MYSUB_DAY1}/fmri/rs_reg.feat/reg/highres
fi

applywarp -i ${MYSEED}2standard -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain -w ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT} --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat --interp=spline

applywarp -i ${MYSEED}2standard_contralateral -r ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/nodif_brain -w ${ANALYSISDIR}/${MYSUB_TOTRACK}/fmri/rs_reg.feat/reg/standard2highres_warp -o ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}_contralateral --postmat=${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/xfms/T1_2_diff_bbr.mat --interp=spline

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}_contralateral -thr 0.25 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}_contralateral

fslmaths ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT} -thr 0.25 -bin ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}

lesionvol=`fslstats ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT} -V`
contravol=`fslstats ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}_contralateral -V`
echo $MYSUB $lesionvol $contravol >> ~/Desktop/Projects/MRGFUS/scratch/testvol.txt

fsleyes ${ANALYSISDIR}/${MYSUB}_longitudinal_xfms/mT1_day1_2_diff_pre_bbr ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT} ${ANALYSISDIR}/${MYSUB_TOTRACK}/diffusion/rois_${TRACT_OUTPUT}/${TRACT_OUTPUT}_contralateral &
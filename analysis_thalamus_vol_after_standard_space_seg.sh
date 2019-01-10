pre=$1
day1=$2
month3=$3
sub=$4

for MYSUB in ${pre} ${day1} ${month3}
do
for side in L R
do
for roi in thal hipp
applywarp -i ${MAINDIR}/analysis/${pre}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi} -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1 -o  ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi}_2_mT1_nn --interp=nn

applywarp -i ${MAINDIR}/analysis/${pre}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi} -w ${MAINDIR}/analysis/${MYSUB}/anat/xfms/MNI_1mm_2_mT1_warp -r ${MAINDIR}/analysis/${MYSUB}/anat/mT1 -o  ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi}_2_mT1

fslmaths  ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi}_2_mT1 -thr 0.5 -bin ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi}_2_mT1_thr_bin

vol_nn=`fslstats ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi}_2_mT1_nn -V | awk '{print $2}'

vol_thr_bin=`fslstats ${MAINDIR}/analysis/${MYSUB}/anat/xfms/mT1_2_MNI_1mm_warped_first_${side}_${roi}_2_mT1_thr_bin -V | awk '{print $2}'

echo $MYSUB $side $roi $vol_nn $vol_thr_bin


done
done
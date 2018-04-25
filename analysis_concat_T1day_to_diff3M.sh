MAINDIR=/Users/erin/Desktop/Projects/MRGFUS
SCRIPTSDIR=${MAINDIR}/scripts
ANALYSISDIR=${MAINDIR}/analysis
MYSUB=${1}-${2}
MYSUB_XFMS=${1}_longitudinal_xfms

convert_xfm -omat ${ANALYSISDIR}/${MYSUB_XFMS}/mT1_day1_2_diff_3M_bbr_6dof.mat -concat ${ANALYSISDIR}/${MYSUB}/diffusion/xfms/T1_2_diff_bbr.mat ${ANALYSISDIR}/${MYSUB_XFMS}/mT1_day1_2_3M_6dof.mat
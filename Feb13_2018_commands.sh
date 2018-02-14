epi_reg --epi=/Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-13017/diffusion/dti_noPURE_unwarped_nodif --t1=/Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-13017/anat/T1 --t1brain=/Users/erin/Desktop/Projects/MRGFUS/analysis/9006_EO-13017/anat/T1_brain --out=diff_2_T1_bbr


for f in 9001_SH-11644 9003_RB-12013 9005_BG-13004 9007_RB-12910 9011_BB-13042 9001_SH-11692 9003_RB-12064 9005_BG-13126 9008_JO-12613 9001_SH-12271 9003_RB-12669 9006_EO-12389 9008_JO-12667 9002_RA-11764 9004_EP-12126 9006_EO-12487 9009_CRB-12609 9002_RA-11833 9002_RA-12388 9004_EP-12955 9007_RB-12461 
do
analysis_diffusion_bbr_reg.sh $f
done


for f in 9004_EP-12203 9009_CRB-13043 9010_RR-13130
do
analysis_diffusion_bbr_reg.sh $f
done

analysis_longitudinal_step1.sh 9001_SH 11644 11692 
analysis_longitudinal_step1.sh 9002_RA 11764 11833 
analysis_longitudinal_step1.sh 9003_RB 12013 12064 
analysis_longitudinal_step1.sh 9004_EP 12126 12203 
analysis_longitudinal_step1.sh 9006_EO 12389 12487 
analysis_longitudinal_step1.sh 9007_RB 12461 12910 
analysis_longitudinal_step1.sh 9008_JO 12613 12667
analysis_longitudinal_step1.sh 9009_CRB 12609 13043 

analysis_longitudinal_step2.sh 9001_SH 11692 12271
analysis_longitudinal_step2.sh 9002_RA 11833 12388
analysis_longitudinal_step2.sh 9003_RB 12064 12669
analysis_longitudinal_step2.sh 9004_EP 12203 12955
analysis_longitudinal_step2.sh 9006_EO 12487 13017

#redo 9003 without extra brain extracted

analysis_longitudinal_step1.sh 9003_RB 12013 12064 
analysis_diffusion_bbr_reg.sh 9003_RB-12013

cd /Users/erin/Desktop/Projects/MRGFUS/analysis
for f in `ls -d *diffusion_longitudinal`
do
mv ${f}/day1_T1_lesion ${f}/day1_T1_lesion_old_reg
done



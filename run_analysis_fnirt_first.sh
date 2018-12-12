cd /Users/erin/Desktop/Projects/MRGFUS/analysis

analysis_fnirt_first.sh 9001_SH-11644 9001_SH-11692 9001_SH-12271 9001_SH
analysis_fnirt_first.sh 9002_RA-11764 9002_RA-11833 9002_RA-12388 9002_RA
#do 9003 but first check that all of the files I think are there are there
analysis_fnirt_first.sh 9004_EP-12126 9004_EP-12203 9004_EP-12955 9004_EP


for sub in 9005_BG 9006_EO 9007_RB 9009_CRB 9013_JD 
do
mkdir ~/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms/mT1_day1_2_pre_6dof.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat 
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms/mT1_month3_2_pre_6dof.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat 
done
analysis_fnirt_no_first.sh 9005_BG-13004 9005_BG-13126 9005_BG-13837 9005_BG
analysis_fnirt_no_first.sh 9006_EO-12389 9006_EO-12487 9006_EO-13017 9006_EO
analysis_fnirt_first.sh 9007_RB-12461 9007_RB-12910 9007_RB-13055 9007_RB
analysis_fnirt_first.sh 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 9009_CRB
analysis_fnirt_first.sh 9013_JD-13455 9013_JD-13722 9013_JD-14227 9013_JD


 for f in `find . -name 'longitudinal_thal_vol.txt'`; do sed "s:^:$f :" $f >> thal_vol_all.txt; done

 mv thal_vol_all.txt thal_vol_all_old.txt
 find . -name 'longitudinal_thal_vol.txt' -delete
 
analysis_fnirt_first_fix.sh 9001_SH-11644 9001_SH-11692 9001_SH-12271 9001_SH
analysis_fnirt_first_fix.sh 9002_RA-11764 9002_RA-11833 9002_RA-12388 9002_RA
analysis_fnirt_first_fix.sh 9004_EP-12126 9004_EP-12203 9004_EP-12955 9004_EP
analysis_fnirt_first_fix.sh  9005_BG-13004 9005_BG-13126 9005_BG-13837 9005_BG
analysis_fnirt_first_fix.sh  9006_EO-12389 9006_EO-12487 9006_EO-13017 9006_EO
analysis_fnirt_first_fix.sh  9007_RB-12461 9007_RB-12910 9007_RB-13055 9007_RB
analysis_fnirt_first_fix.sh  9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 9009_CRB
analysis_fnirt_first_fix.sh  9013_JD-13455 9013_JD-13722 9013_JD-14227 9013_JD

 for f in `find . -name 'longitudinal_thal_vol.txt'`; do sed "s:^:$f :" $f >> thal_vol_all.txt; done
 
 
analysis_fnirt_first_control_rois.sh 9001_SH-11644 9001_SH-11692 9001_SH-12271 9001_SH
analysis_fnirt_first_control_rois.sh 9002_RA-11764 9002_RA-11833 9002_RA-12388 9002_RA
analysis_fnirt_first_control_rois.sh 9004_EP-12126 9004_EP-12203 9004_EP-12955 9004_EP
analysis_fnirt_first_control_rois.sh 9005_BG-13004 9005_BG-13126 9005_BG-13837 9005_BG
analysis_fnirt_first_control_rois.sh 9006_EO-12389 9006_EO-12487 9006_EO-13017 9006_EO
analysis_fnirt_first_control_rois.sh 9007_RB-12461 9007_RB-12910 9007_RB-13055 9007_RB
analysis_fnirt_first_control_rois.sh 9009_CRB-12609 9009_CRB-13043 9009_CRB-13623 9009_CRB
analysis_fnirt_first_control_rois.sh 9013_JD-13455 9013_JD-13722 9013_JD-14227 9013_JD

for f in `find . -name 'longitudinal_putamen_vol.txt'`; do sed "s:^:$f :" $f >> putamen_vol_all.txt; done
 
for f in `find . -name 'longitudinal_hipp_vol.txt'`; do sed "s:^:$f :" $f >> hipp_vol_all.txt; done

#added to get warps for Graham Dec 6 2018

for sub in 9010_RR 9011_BB
do
mkdir ~/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms/mT1_day1_2_pre_6dof.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_day1_2_pre_6dof.mat 
cp /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms/mT1_month3_2_pre_6dof.mat /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/mT1_brain_month3_2_pre_6dof.mat 
done
analysis_fnirt_first.sh 9010_RR-13130 9010_RR-13536 9010_RR-14700 9010_RR
analysis_fnirt_first.sh 9011_BB-13042 9011_BB-14148 9010_BB-14878 9011_BB
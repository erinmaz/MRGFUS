pre=$1
day1=$2
month3=$3
sub=$4

for side in L R
do
echo first_${side}_thal `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_thal_vol.txt
for tp in day1 month3
do
applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_${tp}_warp -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp} -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${!tp}/anat/mT1

fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp} -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_thr_bin

applywarp -i /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal -w /Users/erin/Desktop/Projects/MRGFUS/analysis/${sub}_longitudinal_xfms_T1/pre_to_${tp}_warp -o /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_nn -r /Users/erin/Desktop/Projects/MRGFUS/analysis/${!tp}/anat/mT1 --interp=nn

echo first_${side}_thal_to_${tp}_nn `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_nn -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_thal_vol.txt
echo first_${side}_thal_to_${tp}_thr_bin `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_thr_bin -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_thal_vol.txt

done
done
pre=$1
day1=$2
month3=$3
sub=$4

for side in L R
do
echo first_${side}_thal `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_thal_vol.txt
for tp in day1 month3
do
fslmaths /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp} -thr 0.5 -bin /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_thr_bin
echo first_${side}_thal_to_${tp}_nn `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_nn -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_thal_vol.txt
echo first_${side}_thal_to_${tp}_thr_bin `fslstats /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/first_${side}_thal_to_${tp}_thr_bin -V` >> /Users/erin/Desktop/Projects/MRGFUS/analysis/${pre}/anat/first/longitudinal_thal_vol.txt

done
done
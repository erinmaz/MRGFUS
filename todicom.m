cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9013_JD-13455/anat
new = niftiread('T2_avg_Vim_burned_high_swap.nii');
newflip=flipud(new);
newflip2=fliplr(newflip);
new_int=int16(newflip2);

cd '/Users/erin/Desktop/Projects/MRGFUS/analysis/9013_JD-13455/anat/Orig-HorosOutput/9013_Jd/Mrgfus_PreTreatment(Zk_Fmc_Mrgfus_13455) - 13455/PUSag_CUBE_T2_400'
uid=dicomuid;
files=dir('IM*.dcm');
for i=1:length(files)
old_info=dicominfo(files(i).name);
old_info.Filename=[pwd '/new/' sprintf('new%03d.dcm',i)];
old_info.SeriesDescription='T2_avg_Vim_burned_high';
old_info.SeriesNumber=9999;
old_info.SeriesInstanceUID=uid;
dicomwrite(new_int(:,:,i), sprintf('new%03d.dcm',i), old_info, 'WritePrivate',true);
end
mkdir new
system('mv new*.dcm new/.')

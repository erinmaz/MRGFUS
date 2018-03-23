cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9013_JD-13455/anat
new = niftiread('T2_avg_Vim_burned_high_swap.nii');
newflip=flipud(new);
newflip2=fliplr(newflip);
new_int=int16(newflip2);

%using Horos output because image files will be in correct order in
%directory
cd '/Users/erin/Desktop/Projects/MRGFUS/analysis/9013_JD-13455/anat/Orig-HorosOutput/9013_Jd/Mrgfus_PreTreatment(Zk_Fmc_Mrgfus_13455) - 13455/PUSag_CUBE_T2_400'

seriesUID=dicomuid;
files=dir('IM*.dcm');
for i=1:length(files)
old_info=dicominfo(files(i).name);
old_info.Filename=[pwd '/new/' sprintf('new%03d.dcm',i)];
old_info.SeriesDescription='T2_avg_Vim_burned_high';
old_info.SeriesNumber=9999;
old_info.SeriesInstanceUID=seriesUID;
old_info.ImageType='DERIVED\SECONDARY';

uid=dicomuid;
old_info.SOPInstanceUID=uid;
old_info.MediaStorageSOPInstanceUID=uid;

dicomwrite(new_int(:,:,i),sprintf('new%03d.dcm',i),old_info,'CreateMode','copy','WritePrivate',true);
%dicomwrite(new_int(:,:,i), sprintf('new%03d.dcm',i), old_info);
end
mkdir new_copy_cipac
system('mv new*.dcm new_copy_cipac/.')

new = niftiread('T2_avg_Vim_burned_high_swap.nii');
newflip=flipud(new);
newflip2=fliplr(newflip);
new_int=int16(newflip2);
%cd into directory with original image
files=dir('IM*');
for i=1:length(files)
old_info=dicominfo(files(i).name);
old_info.Filename=[pwd '/new/' sprintf('new%03d.dcm',i)];
old_info.SeriesDescription='T2_avg_Vim_burned_high';
old_info.SeriesNumber=9999;
dicomwrite(new_int(:,:,i), sprintf('new%03d.dcm',i), old_info);
end
mkdir new
system('mv new*.dcm new/.')

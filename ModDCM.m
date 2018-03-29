function ModDCM

cd /Users/erin/Desktop/Projects/MRGFUS/dicoms/9013_JD-13455/400-PUSag_CUBE_T2-
%   Get file listing in current directory
files = dir;
nfiles = size(files);
nfiles = nfiles(1);


%   Loop and read only dicoms
count = 1;
for i = 1:nfiles
    name = files(i).name;
    if length(name) > 4
        if ( ~strcmpi(name(1),'.') && ...
             ~strcmpi(name(end-3:end),'.txt') && ...
             ~strcmpi(name(end-3:end),'.nii') && ...
             (strcmpi(name(end-3:end),'.IMA') || ...
              strcmpi(name(end-3:end),'.dcm') || ...
             ~isempty(strfind(name,'MRDC'))) )
         
            hdr = dicominfo(name);
            inst(count) = hdr.InstanceNumber;
            img(:,:,count) = dicomread(name);
            ref_file(count).name = name;
            count = count + 1;
        end
    end
end
clear count i files nfiles hdr name

%   Sort
[~, inst] = sort(inst);
%img = img(:,:,inst);
ref_file = ref_file(inst);


%   Modify as needed
%img = smile_erin(img);
cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9013_JD-13455/anat
new = niftiread('T2_avg_Vim_burned_high_swap.nii');
newflip=flipud(new);
img=fliplr(newflip);

cd /Users/erin/Desktop/Projects/MRGFUS/dicoms/9013_JD-13455/400-PUSag_CUBE_T2-
%   Write new dicoms based on reference images
mkdir('Mod');
for i = 1:size(img,3)
    new_name = ['Mod/mod_' ref_file(i).name];
    GERecon('Dicom.Write', new_name, int16(img(:,:,i)), ref_file(i).name, ...
            9999, 'Modified_image');
end



end


% function img = smile_erin(img)
% val = max(abs(img(:)));
% img(10,10,:) = val;
% img(10,20,:) = val;
% img(19,4,:) = val;
% img(20,5,:) = val;
% img(21,6,:) = val;
% img(22,7,:) = val;
% img(23,8:9,:) = val;
% img(24,10:12,:) = val;
% img(25,13:18,:) = val;
% img(24,19:21,:) = val;
% img(23,22:23,:) = val;
% img(22,24,:) = val;
% img(21,25,:) = val;
% img(20,26,:) = val;
% img(19,27,:) = val;
% end
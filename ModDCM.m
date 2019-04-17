function ModDCM

cd /Users/erin/Desktop/Projects/MRGFUS/dicoms/9012_AT-13418/500-PUSag_CUBE_T2-
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

cd /Users/erin/Desktop/Projects/MRGFUS/analysis/9012_AT-13418/anat
new = niftiread('T2_avg_Vim_burned_high_swap.nii');
newflip=flipud(new);
img=fliplr(newflip);

cd /Users/erin/Desktop/Projects/MRGFUS/dicoms/9012_AT-13418/500-PUSag_CUBE_T2-
%   Write new dicoms based on reference images
mkdir('Mod');
for i = 1:size(img,3)
    new_name = ['Mod/mod_' ref_file(i).name];
    GERecon('Dicom.Write', new_name, int16(img(:,:,i)), ref_file(i).name, ...
            9999, 'Modified_image');
end



end

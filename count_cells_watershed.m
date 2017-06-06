function [final_counts,props,originalstack] = count_cells_watershed(filename)
%COUNT_CELLS_WATERSHED(filename) counts the cells in stacks with multiple channels.
%Ideal for time-lapse experiments with differently labeled fluorescent
%cells. This function performs the watershed algorithm from the image
%processing toolbox.
%   Inputs:     filename - CZI stack name as a string, if the file is in
%                           your current MATLAB directory
%               no inputs if you want to select a czi that's not in your 
%                           current MATLAB folder
%   Output:     cell matrix with the cell counts per image slice for the
%                           input file
% Written by Javier Manzella-Lapeira for LIG Imaging
% Last updated on 5/30/17

global water filter_size size_thresh cmap

fs = str2double(filter_size);
sth = str2double(size_thresh);

if nargin == 0
    [file,path] = uigetfile;
    filename = [path,file];
end

cmp_name = strcmp(filename(end-2:end),'tif');
if cmp_name == 1
    image_stack = imread(filename); %figure, imshow(imadjust(image_stack));
    I_w = wiener2(image_stack,[3,3]);
    I_backg = medfilt2(I_w,[3,3]);
    level = graythresh(I_backg);
    bw = im2bw(I_backg,level); %figure, imshow(bw);
    d_transform = bwdist(~bw); %max_dt = max(d_transform(:)); %figure, imshow(d_transform,[0 max_dt]);
    dtrans = -d_transform;
    W = watershed(dtrans);
    bw(W == 0) = 0; %figure, imshow(bw);
    original_stats = regionprops(bw,image_stack,'Area','Centroid',...
        'EquivDiameter','PixelIdxList','MinIntensity','WeightedCentroid');
    count = length(original_stats);
    ROIdata = original_stats;
    originalstack = image_stack;
else
    stack_data = bfopen(filename);
    image_stack = stack_data{1,1};
    image_stack = image_stack(:,1);
    colormat = stack_data{1,3};
    cmap = colormat{1,1};
    num = numel(image_stack);
    originalstack = cell(num,1);
    count = zeros(num,1);
    ROIdata = cell(num);
    for n = 1:num
        I_raw = image_stack{n};
        I_w = wiener2(I_raw,[fs,fs]);
        I_backg = medfilt2(I_w,[fs,fs]);
        originalstack{n} = imadjust(I_backg);
        level = graythresh(imadjust(I_backg));
        bw = im2bw(imadjust(I_backg),level);
        bw = imfill(bw,'holes');
        % add watershed if specified
        if water == 1
            d_transform = bwdist(~bw);
            DT_complement = -d_transform; % DT_complement(~bw) = -Inf;
            W = watershed(DT_complement);
            bw(W == 0) = 0;
        end
        properties = regionprops(bw,I_raw,'Area','Centroid','EquivDiameter',...
            'PixelIdxList');
        % Exclusion loops:
        % 1 - Size
        if sth > 0
           properties = slimstruct(properties,'Area',[0 sth 1]); 
        end
        L = length(properties);
        count(n,1) =  L;
        ROIdata{n} = properties;
    end
end 
final_counts = count;
props = ROIdata;

end
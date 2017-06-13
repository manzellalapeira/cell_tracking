%% Colormap project

%% Retrieve image 1
global cmap filter_size size_thresh cmap2

filter_size = '3';
size_thresh = '1';

% Retrieve file 1
[file, path] = uigetfile({'*.czi'}, 'Select your image');
filename = [path,file];

[original] = count_cells_overlay01(filename);

%% Image 1
figure
ax1 = axes;
imshow(original{1},'ColorMap',cmap);

%% Retrieve image 2
[file2, path2] = uigetfile({'*.czi'}, 'Select your image');
filename2 = [path2,file2];

[original2] = count_cells_overlay02(filename2);

%% Image 2
figure
imshow(original2{1},'ColorMap',cmap2);

%% Mask
for n = 1:numel(original2)
    mimg{n} = im2double(original2{n});
    mim_rgb{n} = ind2rgb(round(mimg{n}.*size(cmap2,1)),cmap2);
end

%% Overlayed Image

figure
for n = 1:numel(original)
    imshow(original{n},'Colormap',cmap)
    hold on
    h = image(mim_rgb{n}); a = 0.8;
    set(h,'AlphaData',(mimg{n}>0).*a)
    drawnow limitrate
end

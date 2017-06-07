%% Colormap project

%% Retrieve image 1
global cmap filter_size size_thresh water

filter_size = 3;
size_thresh = 1;
water = 1;

% Retrieve file 1
[file, path] = uigetfile({'*.czi'}, 'Select your image');
filename = [path,file];

% [mat,struct,original] = count_cells_watershed(filename);
n = 1;
fs = filter_size;
st = size_thresh;

stack_data = bfopen(filename);
image_stack = stack_data{1,1};
image_stack = image_stack(:,1);
colormat = stack_data{1,3};
cmap = colormat{1,1};
num = numel(image_stack);
originalstack = cell(num,1);
count = zeros(num,1);
ROIdata = cell(num);
I_raw = image_stack{n};
I_w = wiener2(I_raw,[fs,fs]);
I_backg = medfilt2(I_w,[fs,fs]);
originalstack{n} = imadjust(I_backg);

%% Image 1
figure
ax1 = axes;
imshow(originalstack{n},'ColorMap',cmap);

%% Retrieve image 2
[file2, path2] = uigetfile({'*.czi'}, 'Select your image');
filename2 = [path2,file2];

stack_data2 = bfopen(filename2);
image_stack2 = stack_data2{1,1};
image_stack2 = image_stack2(:,1);
colormat2 = stack_data2{1,3};
cmap2 = colormat2{1,1};
num2 = numel(image_stack2);
originalstack2 = cell(num2,1);
count2 = zeros(num,1);
ROIdata2 = cell(num2);
I_raw2 = image_stack2{n};
I_w2 = wiener2(I_raw2,[fs,fs]);
I_backg2 = medfilt2(I_w2,[fs,fs]);
originalstack2{n} = imadjust(I_backg2);

%% Image 2

ax2 = axes;
axes(ax2)
imshow(originalstack2{1},'ColorMap',cmap2);

%% Mask

mimg = im2double(originalstack2{1});
cmap3 = zeros(512,3);
cmap3(:,1) = linspace(0,0.7500,512);
mim_rgb = ind2rgb(round(mimg.*size(cmap3,1)),cmap3);

%% Overlayed Image

figure 
imshow(originalstack{1},'Colormap',cmap)
hold on
h = image(mim_rgb); a = 0.8;
set(h,'AlphaData',(mimg>0).*a)








function [originalstack] = count_cells_overlay01(filename)
global filter_size size_thresh cmap

fs = str2double(filter_size);
sth = str2double(size_thresh);

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
end
end

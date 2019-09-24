% MIT License
% 
% Copyright (c) 2019 Asim Iqbal
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% The following code takes N images, removes zero padding and creates a
% montage (reconstruct the original brain region) of them.
 
%function brain_section = montage() % return brain section (stars_image)
% brain_section;
% imsection(10,10,10,255)
%% Testing random images
stars_name = 'stars_';
png_name = 'sect_9.png';
png_ref_name =  'ref_9.png';
stars = strcat(stars_name,png_name);

file_name_1 = 'C:\Users\iqbal\Desktop\Markus\montage_samples\';

image_name = strcat(file_name_1,png_name);
original_image = imread(image_name);
original_image = imresize(original_image,0.5);
imwrite(original_image,png_name);


imsection(10,10,10,255)
 
%
image_index=1;
%original_image  =  imread('F:\Asim_Theo_Lab_Work\Active_Projects\RAR_Project\Code_New\Starter_Cells_DNN_Code\i4_colored\temp.png');
%imread('D:\RCNN_fall_2017_analysis\Filtered_testing_GAD1\scalable_ground_truth\Original_all_sections\p14g1.jpg');
[size_y,size_x, size_z] = size(original_image);
%original_image = padarray(original_image,[10 10],255,'both');
%original_image  = imresize(original_image,0.5);
%
%purp_section = imread('D:\RCNN_fall_2017_analysis\Filtered_testing_GAD1\scalable_ground_truth\Filtered\p14g1_filtered.png');
%purp_section = imresize(purp_section,0.5);
%[size_y,size_x,size_z] = size(purp_section);
brain_stars_section = zeros(size_y,size_x);
% getting the list of images
list = string(ls ('C:\Users\iqbal\Desktop\Markus\montage_samples\'));
%list = string(ls ('D:\RCNN_fall_2017_analysis\Filtered_testing_GAD1\scalable_ground_truth\Filtered\i4\'));
list = string(sort_nat(list));

%%
list(1:3)=[]; % remove the first two because they are . and ..

%%
num_of_images = size(list);
index_y_start = 1;
index_y_end = 1;
index_x_start = 0;
index_x_end = 0;
error_array = [];
for k=1:num_of_images
    disp(k); % to display index of number of images
    %image = imread(strcat('D:\RCNN_fall_2017_analysis\Filtered_testing_GAD1\scalable_ground_truth\Original_all_sections\i1\', char(list(k)))); % purp images with white background
    %colored_image =  imread(strcat('D:\RCNN_fall_2017_analysis\Filtered_testing_GAD1\scalable_ground_truth\Colored_all_sections\i1\', char(list(k))));
    %image = allen_color_filter(colored_image,image); % change allen_color_filter for your threshold of cells
    image = imread(strcat('C:\Users\iqbal\Desktop\Markus\montage_samples\', char(list(k))));
    [bboxes, scores] = detect(detector, image); %returns the classification/detection(scores) and locations(bboxes) of cells
    [y_image,x_image,channels] = size(image);
    black_image = zeros(y_image,x_image);
    error_k = 0;
    %[index_y_end,index_x_end] = size(black_image);
    if (k ==1)
          index_y_end = index_y_start+y_image-20-1;
    end
    
    if (index_x_end == size_x)
        index_x_start = 1;%m
        index_x_end = index_x_start+x_image-20-1;
        index_y_start = index_y_end+1;
        index_y_end = index_y_start+y_image-20-1;
    else
        index_x_start = index_x_end+1;
        index_x_end = index_x_start+x_image-20-1;
        
    end
    [bboxes_size,bboxes_num] = size(bboxes);
    %disp(bboxes_size);
    
    for l=1:bboxes_size
        center=[bboxes(l,2)+ceil(0.5*bboxes(l,4)), bboxes(l,1)+ceil(0.5*bboxes(l,3))]; %where the positions are correct
        if (image(center(1), center(2), :) == [255, 255, 255])
            error_k = error_k+1;
                
        else
            %disp(k);
            black_image(center(1), center(2), :) = 1; 
 
        end
    end
    
        brain_stars_section(index_y_start:index_y_end, index_x_start:index_x_end) = black_image(11:end-10,11:end-10);
        error_array(k) = error_k;
        clear bboxes;
end
%
imwrite(brain_stars_section,stars);
r = 1;
SE = strel('sphere',r);
J = imdilate(brain_stars_section,SE);
overlay_image = imoverlay(original_image,brain_stars_section,'red');
figure; imshow(overlay_image);
% viscircles(centers,radii)
 
% 
% %% draw bounding box around the cells
% green_red_image =  imread('F:\Asim_Theo_Lab_Work\Active_Projects\RAR_Project\Data\Cleared_Brains\VIP-HTB-P5-P11-Rabies\L3nbr5\DL\Red_DL_MAX_Reslice of L3#5_VIP_P5_P12_BF_3.2x_ColorMerge_rot_Cropped.png');
% %imread('F:\Asim_Theo_Lab_Work\Active_Projects\RAR_Project\Code_New\Starter_Cells_DNN_Code\i4_colored\Green_DL_MAX_Reslice of L3#5_VIP_P5_P12_BF_3.2x_ColorMerge_rot_Cropped.png');
BW = imbinarize(brain_stars_section);
st = regionprops(BW,'BoundingBox' );
figure; imshow(overlay_image);
hold on;
for k = 1 : length(st)
    thisBB = st(k).BoundingBox;
    rectangle('Position', [thisBB(1)-5,thisBB(2)-5,thisBB(3)+10,thisBB(4)+10],... 
        'EdgeColor','red','LineWidth',1)
end
hold off;


%% SMALL GIRAFFE (a.k.a. sagittal brain section)

%% create dataset with zero padding to have same object with different sizes


x=0;
num_kernels = 1;%testing with one!
% sobs = zeros(1,num_kernels);
% kernel_size = zeros(1,num_kernels);
% objs = zeros(1,num_kernels);
% 
% %%
small_gf_orig = imcomplement(imbinarize(rgb2gray(imread('C:\Users\iqbal\Documents\GitHub\DeNeRD\data_augmentation/sect_2_ref_3_section83_40.png'))));
% 
% %%
% 
% se = strel('disk',200);
% 
% small_gf = imclose(small_gf_orig,se);
% small_gf = bwareaopen(small_gf, 15550);
% 
% small_gf = bwareafilt(small_gf, 1);
% [rows, columns] = find(small_gf);
% row1 = min(rows);
% row2 = max(rows);
% col1 = min(columns);
% col2 = max(columns);
% % Crop
% small_gf = small_gf(row1:row2, col1:col2, :);
% 
% figure;
% imshow(small_gf)
%%
for pad=1:num_kernels
    padsize = [x x];
    B = padarray(small_gf,padsize,'both');
    GB_resized = imresize(B, [100 100]); 

    %% image rotation
    rot_var = 0;     %rotating image

    for i=1:36
        g = figure('visible','off');
        s = regionprops(imrotate(small_gf_orig,rot_var,'bilinear','crop'  ),'BoundingBox');
        GB = imrotate(small_gf_orig,rot_var,'bilinear','crop');
        title(['image rotated by: ' num2str(rot_var)''])
        
        %cd('C:\Users\iqbal\Documents\GitHub\DeNeRD\data_augmentation\rotation\rotations_00');
        %imwrite(GB,strcat('class_medial_image_scale:',num2str(pad),'_rot:',num2str(i),'.jpg'));
        figure; imshow(GB);
        rot_var = rot_var+10;
        
        
%         cd('/Users/drasif/Documents/romesa_coding_projects/classification_of_brain_sections_using_deep_learning/Dataset/class_medial_test');
%         saveas(gcf,strcat('class_medial_image_scale:',num2str(pad),'_rot:',num2str(i),'.jpg'));

    end 
    x = x + 100;
end

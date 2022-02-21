function [] = montage_testing_LOOP_DeNeRD(im_name,grid_size,scale_ratio,path,int_factor,detector)
    %%
    cd(path)
    cd Cleared_samples\
    temp_name = im_name;
    temp = imread(temp_name);
    temp = imresize(temp,scale_ratio);
    cd ..
    
    cd padded_output_i4_colored\
    imwrite(temp(:,:,1)*int_factor,'temp.png');
    cd ..
    cd padded_output_i4\ 
    imwrite(temp(:,:,1)*int_factor,'temp.png')
    imsection_DeNeRD_auto_Cleared(grid_size,grid_size,10,0,1); % padding settings
    delete temp.png
    %%
    original_image  =  imread('E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\padded_output_i4_colored\temp.png');
    [size_y,size_x] = size(original_image);
    brain_stars_section = zeros(size_y,size_x);

    %% getting the list of images
    list = string(ls ('E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\padded_output_i4\'));
    list = string(sort_nat(list));
    list(1:2)=[]; % remove the first two because they are . and ..
    num_of_images = size(list);
    index_y_start = 1;
    index_y_end = 1;
    index_x_start = 0;
    index_x_end = 0;
    error_array = [];
    for k=1:num_of_images
        disp(k); % to display index of number of images
        %fprintf('processing sample %d / %d...\n', k, num_of_images);
        image = imread(strcat('E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\padded_output_i4\', char(list(k))));
        [bboxes, scores] = detect(detector, image); % returns the classification/detection(scores) and locations(bboxes) of cells
        [y_image,x_image] = size(image);
        black_image = zeros(y_image,x_image);
        error_k = 0;
        if (k ==1)
              index_y_end = index_y_start+y_image-20-1;
        end

        if (index_x_end == size_x)
            index_x_start = 1;
            index_x_end = index_x_start+x_image-20-1;
            index_y_start = index_y_end+1;
            index_y_end = index_y_start+y_image-20-1;
        else
            index_x_start = index_x_end+1;
            index_x_end = index_x_start+x_image-20-1;

        end
        [bboxes_size,bboxes_num] = size(bboxes);

        for l=1:bboxes_size
            center=[bboxes(l,2)+ceil(0.5*bboxes(l,4)), bboxes(l,1)+ceil(0.5*bboxes(l,3))]; %where the positions are correct
            if (image(center(1), center(2), :) == [255, 255, 255])
                error_k = error_k+1;

            else
                black_image(center(1)-1, center(2)-1, :) = 1; 

            end
        end
            brain_stars_section(index_y_start:index_y_end, index_x_start:index_x_end) = black_image(11:end-10,11:end-10);
            error_array(k) = error_k;
            clear bboxes;
    end
    %classification scores of bboxes
    %% visualization
    r = 2;
    SE = strel('square',r);
    J = imdilate(brain_stars_section,SE);
    overlay_image = imoverlay(original_image,J,'red');
    %figure; imshow(overlay_image);
    %figure; plot(scores,'k.','Markersize',30); xlabel('bboxes of cells'); ; xlabel('CA scores'); % to visualize the predicted

    %%
    cd E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\Cleared_Results
    im_name = char(im_name);
    l_of_name = length(im_name)-4;
    im_name = im_name(1:l_of_name);
    imwrite_name = strcat(im_name,'_','stars','_','scale_',string(scale_ratio),'_intensity_',string(int_factor),'.png');
    imoverlay_name = strcat(im_name,'_','overlay','_','scale_',string(scale_ratio),'_intensity_',string(int_factor),'.png');
    imwrite(brain_stars_section,imwrite_name);
    imwrite(overlay_image,imoverlay_name);
    %close;
end
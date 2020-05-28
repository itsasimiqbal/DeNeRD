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
%% DeNeRD pipeline
% Cite: Iqbal A, et al. DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning. Scientific Reports. 2019 Sep 25; 9 (1): 1-3.
%% steps
%1. save figures with different intensities
%2. add new file names with their bounding boxes in training.mat
%3. save, validate and use new training.mat

% starting an empty training file
load('training.mat');
augment_training = training;
augment_training(:,1)={"empty.png"};
augment_training(:,2)={[]};
[tr_size,xxx] = size(training);

%%
tr_mat_index = 1;
tr_aug_index = 1;
for x=1:tr_size
    names = strsplit(training{x,1},'/');
    name = names(1,2);
    name = strcat('dataset','/',name);
    image = imread(training{x,1});
    cd(name)
    scale = 0.5;
    for y=1:10
        augmented_image = image*scale;
        scale=scale+0.1;
        image_name = strsplit(names(3),'.png');
        image_name = strcat(image_name(1),'_augment_',string(y),'.png');
        imwrite(augmented_image,image_name);
        new_image_name = strcat(name,'/',image_name);
        augment_training{tr_aug_index,1} = new_image_name;
        augment_training{tr_aug_index,2} = training{tr_mat_index,2};
        
        tr_aug_index = tr_aug_index+1;
    end
    tr_mat_index=tr_mat_index+1;
    %figure; imshow(image);
    disp(name)
    disp(x)
    cd .. % i/ folder location 
    cd .. % dataset/ folder location
end
save('training_old.mat','training');
training = augment_training;
save('training.mat','training');




%% go inside each folder
% i_folder_names = dir('dataset');
% i_folder_names(1:2) = [];
% [num_folders,xxx] = size(i_folder_names);
% going through each i folder
% for x=1:num_folders
%     i_folder_name = i_folder_names(x).name;
%     dir_folder_name = i_folder_names(x).folder;
%     i_folder_name = strcat(dir_folder_name,'\',i_folder_name);
%     cd (i_folder_name)
%     
%     % going inside i folder
%     image_names = dir(i_folder_name);
%     image_names(1:2) = []; 
%     image_names
    
    
    %disp(dir_folder_name)
    %disp(i_folder_name)
% end

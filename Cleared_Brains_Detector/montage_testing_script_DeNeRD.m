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


clear all;
%% GPU setting issue resolve
warning off parallel:gpu:device:DeviceLibsNeedsRecompiling
try
    gpuArray.eye(2)^2;
catch ME
end
try
    nnet.internal.cnngpu.reluForward(1);
catch ME
end

cd E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector

for kk=1:2%max_images
    % just need to run this only once before your analysis to load the
    % trained model, if the model is already loaded then set first_start=0
    first_start = 1;%0
    if first_start==1
        load('E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\Cleared_DeNeRD.mat');
        fprintf(1, 'Trained model loaded %s\n', 'DeNeRD');
    end    
    %%
    list = string(ls ('E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\Cleared_samples'));
    list = string(sort_nat(list));
    list(1:2)=[]; % remove the first two because they are . and ..
    max_images = size(list);
    %%
    disp(kk); % to display index of number of images
    im_name = list(kk);
    % location where padded crops will be made
    myFolder = 'E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector\padded_output_i4';
    filePattern = fullfile(myFolder, '*.png'); % Change it to other file formats if needed e.g. .png, .tif, .jpeg, etc.
    theFiles = dir(filePattern);
    for k = 1 : length(theFiles)
      baseFileName = theFiles(k).name;
      fullFileName = fullfile(myFolder, baseFileName);
      fprintf(1, 'Now deleting %s\n', fullFileName);
      delete(fullFileName);
    end
    path = 'E:\iqbal\Github\DeNeRD\Cleared_Brains_Detector';
    grid_size = 10; % you can experiment it with bigger or smaller grid sizes based on the size of your sample images
    counter=1;
    scale_ratio = 0.5; % to run a sweep of scale starting with downsampling ratio of 0.5, sampling every 0.5    
    for x=1:3
        int_factor = 0.8; % to run a sweep of intensity starting with initial value of 0.4, sampling every 0.2
        for y=1:3
            montage_testing_LOOP_DeNeRD(im_name,grid_size,scale_ratio,path,int_factor,detector)
            int_factor = int_factor+0.2;
        end
        scale_ratio = scale_ratio+0.5;
    end
    clear; % to clear the workspace everytime to avoid memory issues for large scale brain-wide analysis
    
end
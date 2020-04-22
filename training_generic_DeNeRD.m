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
%% ## going inside dataset/ folder
% code to generate an initial training.mat file for Faster R-CNN
% works for multiple folders (e.g. i1, i2) inside the dataset/ folder
clc; clear all;
data_list=string(ls('dataset')); %go inside 
data_list(1:2) = [];
data_list = sort_nat(data_list);
disp('data_list: '); disp(data_list);
disp('shape of data_list: '); disp(size(data_list));
data_list(:,1)=strcat('dataset/', data_list(:,1));
disp('data_list: '); disp(data_list);

%% ## going inside dataset/iNs folders
data_final = strings(); %start with an empty string
for i=1:length(data_list)
    data_new = strcat(data_list(i),'/', string(ls(data_list(i))));
    data_new(1:2) = [];
    data_new = sort_nat(data_new);
    data_final = cat(1,data_new,data_final);
end
data_lim = length(data_final)-1;
data_final = data_final(1:data_lim);
trainingdata = array2table(data_final);
trainingdata = table2cell(trainingdata);

%% generate a sample bounding box on top left of each image for start
for j=1:length(data_final)
    bounds = [1, 1, 10, 10];
    bounds3{j,1}=bounds;
end
s2 = horzcat(trainingdata,bounds3);
training = cell2table(s2);
training = table2cell(training);
save('training_generic.mat', 'training');
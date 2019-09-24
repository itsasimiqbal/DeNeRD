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

%Create table of training file
%% conversion of training.mat into RCNN compatible format
%load('training.mat');
%training3 = cell2table(training); %save('training.mat', 'training', 'training3', 'currentIndex', 'imagesInFolder');
%save('training.mat');


% Load  data set
data = load('training.mat');
%data = load('cells_allen3.mat');
%data = cells_training;
vehicleDataset = data.training3;

%%
% The training data is stored in a table. The first column contains the
% path to the image files. The remaining columns contain the ROI labels for
% vehicles.

% Display first few rows of the data set.
vehicleDataset(1:4,:)

%%
% Display one of the images from the data set to understand the type of
% images it contains.

dataDir = ('G:\Asim_Theo_Lab_Work\Active_Projects\DeNeRD\Code\Revision_1\dataset\');
%dataDir = ('C:\Users\Asfandyar\Documents\RCNN\CELL_SEGMENTATION_Deep_Neural_Network_Project\cortex_p14_gad1_dataset\i_folders'); % folder where your i1 - i4 folders are located
%dataDir = ('C:\Users\Asfandyar\Documents\RCNN\CELL_SEGMENTATION_Deep_Neural_Network_Project\P14_GAD1_dataset');
vehicleDataset.training1 = fullfile(dataDir, vehicleDataset.training1);

 % Read one of the images.
I = imread(vehicleDataset.training1{20});

% Insert the ROI labels.
% I2 = im2uint16(I); %necessary for BW images, for normal I2=I
I2 = insertShape(I, 'Rectangle', vehicleDataset.training2{20});

% Resize and display image.
I = imresize(I, 3);
%figure
imshow(I)


%%
% Split the data set into a training set for training the detector, and a
% test set for evaluating the detector.

% Split data into a training and test set.
trainingData = vehicleDataset(1:2:91,:);
testData = vehicleDataset(2:2:91,:);


%% Create a Convolutional Neural Network (CNN)
% A CNN is the basis of the Faster R-CNN object detector. Create the CNN
% layer by layer using Neural Network Toolbox(TM) functionality.
%
% Start with the |imageInputLayer| function, which defines the type and
% size of the input layer. For classification tasks, the input size is
% typically the size of the training images. For detection tasks, the CNN
% needs to analyze smaller sections of the image, so the input size must be
% similar in size to the smallest object in the data set. In this data set
% all the objects are larger than [16 16], so select an input size of [32
% 32]. This input size is a balance between processing time and the amount
% of spatial detail the CNN needs to resolve.

% Create image input layer.
inputLayer = imageInputLayer([6 6 3]); % 6 6

%%
% Next, define the middle layers of the network. The middle layers are made
% up of repeated blocks of convolutional, ReLU (rectified linear units),
% and pooling layers. These layers form the core building blocks of
% convolutional neural networks.

% Define the convolutional layer parameters.
filterSize = [3 3];
%numFilters1 = 128;
numFilters = 128; %works_good=128; %original=32
%1024
% Create the middle layers.
middleLayers = [
                
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)          
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)
    reluLayer()
    maxPooling2dLayer(3, 'Stride',2)
];
%%
% You can create a deeper network by repeating these basic layers. However,
% to avoid downsampling the data prematurely, keep the number of pooling
% layers low. Downsampling early in the network discards image information
% that is useful for learning.
% 
% The final layers of a CNN are typically composed of fully connected
% layers and a softmax loss layer. 

finalLayers = [
    
    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    %fullyConnectedLayer(64)%64

    % Add a ReLU non-linearity.
    reluLayer()
    
    % Add the last fully connected layer. At this point, the network must
    % produce outputs that can be used to measure whether the input image
    % belongs to one of the object classes or background. This measurement
    % is made using the subsequent loss layers.
   % fullyConnectedLayer(width(vehicleDataset))
    fullyConnectedLayer(width(vehicleDataset))

    % Add the softmax loss layer and classification layer. 
    softmaxLayer()
    
    classificationLayer()
];

%%
% Combine the input, middle, and final layers.
layers = [
    inputLayer
    middleLayers
    finalLayers
    ]

%% Configure Training Options
% |trainFasterRCNNObjectDetector| trains the detector in four steps. The first
% two steps train the region proposal and detection networks used in Faster
% R-CNN. The final two steps combine the networks from the first two steps
% such that a single network is created for detection [1]. Each training
% step can have different convergence rates, so it is beneficial to specify
% independent training options for each step. To specify the network
% training options use |trainingOptions| from Neural Network Toolbox(TM).
% 
% Options for step 1.
epoch_size = 50;
optionsStage1 = trainingOptions('sgdm', ...
    'MaxEpochs', epoch_size, ...
    'InitialLearnRate', 1e-5, ...
    'CheckpointPath', tempdir);
% 
% Options for step 2.
optionsStage2 = trainingOptions('sgdm', ...
    'MaxEpochs', epoch_size, ...
    'InitialLearnRate', 1e-5, ...
    'CheckpointPath', tempdir);

% Options for step 3.
optionsStage3 = trainingOptions('sgdm', ...
    'MaxEpochs', epoch_size, ...
    'InitialLearnRate', 1e-6, ...
    'CheckpointPath', tempdir);

% Options for step 4.
optionsStage4 = trainingOptions('sgdm', ...
    'MaxEpochs', epoch_size, ...
    'InitialLearnRate', 1e-6, ...
    'CheckpointPath', tempdir);

options = [
    optionsStage1
    optionsStage2
    optionsStage3
    optionsStage4
    ];

%% true when training needs to be performed
doTrainingAndEval = true;

if doTrainingAndEval
    % Set random seed to ensure example training reproducibility.
    rng(0);
    
    % Train Faster R-CNN detector. Select a BoxPyramidScale of 1.2 to allow
    % for finer resolution for multiscale object detection.
    detector = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
        'NegativeOverlapRange', [0 0.5], ... % ORIGINAL = [0 0.3]
        'PositiveOverlapRange', [0.5 1], ...  % ORIGINAL = [0.7 1]
        'BoxPyramidScale', 1.2);
else
    % Load pretrained detector for the example.
    test = load('detector.mat'); % load existing trained model
    detector = test.detector;
end

%%
% To quickly verify the training, run the detector on a test image.

% Read a test image.
cd G:\Asim_Theo_Lab_Work\Active_Projects\DeNeRD\Code\Revision_1\dataset
I = imread('i4_section34_57.png');
%I = imread('p14g1_filtered_resized.png');
%I = I(2500:2700,3000:3200,:);
%I = allen_color_filter(I);
bboxes_real = size(data.training3.training2{68,1});
L   = imread('G:\Asim_Theo_Lab_Work\Active_Projects\DeNeRD\Code\Revision_1\dataset_colored\i4_section34_57.png');
%memory runs out in bigger images
S = 'Cell count - Predicted.';

% Run the detector.
[bboxes, scores] = detect(detector, I);
s_array = [];
count=0;
s_scores = size(scores);
% change this threshold if necessary
for s=1:s_scores(1)
    if scores(s)<0.5
        count = count+1;
        scores(s) = 0;
        s_array(count)=s;
        %bboxes(s,:)=[];
    end
end

scores(scores==0) = [];
bboxes(s_array,:)=[];
clear s_array;
disp(S); 
disp(size(bboxes));


S = 'Cell count - Ground truth.';
disp(S);
disp(bboxes_real);

% Annotate detections in the image.
%subplot(1,2,1)
figure;
%subplot(1,2,1)0,
L = insertShape(L, 'rectangle',bboxes, 'Color','red');imshow(L)
%I = insertShape(I, 'rectangle',bboxes, 'Color','red');imshow(I)
%subplot(1,2,2)


%figure;
%I = insertObjectAnnotation(I, 'rectangle', bboxes, scores,'Color','red');
%imshow(I)
%I2 = insertObjectAnnotation(I2, 'rectangle', bboxes, scores);


%I2 = insertShape(I2, 'rectangle', bboxes,'Color','blue');
%subplot(1,2,2)
%imshow(I2)
%% Evaluate Detector Using Test Set
% Testing a single image showed promising results. To fully evaluate the
% detector, testing it on a larger set of images is recommended. Computer
% Vision System Toolbox(TM) provides object detector evaluation functions
% to measure common metrics such as average precision
% (|evaluateDetectionPrecision|) and log-average miss rates
% (|evaluateDetectionMissRate|). Here, the average precision metric is
% used. The average precision provides a single number that incorporates
% the ability of the detector to make correct classifications (precision)
% and the ability of the detector to find all relevant objects (recall).
%
% The first step for detector evaluation is to collect the detection
% results by running the detector on the test set. To avoid long evaluation
% time, the results are loaded from disk. Set the |doTrainingAndEval| flag
% from the previous section to true to execute the evaluation locally.

if doTrainingAndEval
    % Run detector on each image in the test set and collect results.
    resultsStruct = struct([]);
    for i = 1:height(testData)
        
        % Read the image.
        I = imread(testData.training1{i});
        
        % Run the detector.
        [bboxes, scores, labels] = detect(detector, I);
        
        % Collect the results.
        resultsStruct(i).Boxes = bboxes;
        resultsStruct(i).Scores = scores;
        resultsStruct(i).Labels = labels;
    end
    
    % Convert the results into a table.
    results = struct2table(resultsStruct);
else
    % Load results from disk.
    results = data.results;
end

% Extract expected bounding box locations from test data.
expectedResults = testData(:, 2:end);

% Evaluate the object detector using Average Precision metric.
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

%%
% The precision/recall (PR) curve highlights how precise a detector is at
% varying levels of recall. Ideally, the precision would be 1 at all recall
% levels. In this example, the average precision is 0.6. The use of
% additional layers in the network can help improve the average precision,
% but might require additional training data and longer training time.

% Plot precision/recall curve
%[ap, recall, precision] = evaluateDetectionPrecision(results, new_Resuts);

%expectedResults_new.training2 = results.Boxes;
%[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults_new);
figure
plot(recall, precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.1f', ap))
disp('Average Precision:');
disp(ap)


%% References
% [1] Ren, Shaoqing, et al. "Faster R-CNN: Towards Real-Time Object
% detection with Region Proposal Networks." _Advances in Neural Information
% Processing Systems._ 2015.
%
% [2] Girshick, Ross, et al. "Rich feature hierarchies for accurate object
% detection and semantic segmentation." _Proceedings of the IEEE Conference
% on Computer Vision and Pattern Recognition._ 2014.
%
% [3] Girshick, Ross. "Fast r-cnn." _Proceedings of the IEEE International
% Conference on Computer Vision._ 2015.
%
% [4] Zitnick, C. Lawrence, and Piotr Dollar. "Edge boxes: Locating object
% proposals from edges." _Computer Vision-ECCV_ 2014. Springer
% International Publishing, 2014. 391-405.
%
% [5] Uijlings, Jasper RR, et al. "Selective search for object recognition."
% _International Journal of Computer Vision_ (2013): 154-171.

displayEndOfDemoMessage(mfilename)
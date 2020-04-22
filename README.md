# DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning

#### [Iqbal, A., Sheikh, A. and Karayannis, T., 2019. DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning. Scientific Reports](https://rdcu.be/b3Iwl)

The block diagram of our system is demonstrated below:

![alt text](https://github.com/itsasimiqbal/DeNeRD/blob/master/DeNeRD_block.png)


# Download:
#### Clone the DeNeRD repository by running the following command in your terminal window:
```
git clone https://github.com/itsasimiqbal/DeNeRD.git
```

# Steps to follow to run the DeNeRD on your dataset:

#### 1. Copy/Download your dataset images and place them in /dataset folder, you can put each brain section (.png/.jpg) image inside sub-folders: i01, i02, ...
```
dataset --> i01, i02, ..., iN
```

#### 2. Navigate inside the dataset/i01, i02, ..., iN and run the following script:
```
imsection(10,10,pad_size,pad_color,resize_ratio)
```
(10, 10) generates 10x10 images from the original brain section (.png/.jpg) image; pad_size = 10 (number of pixels); pad_color = 0(black)/255(white), resize_ratio = 1/0.5 will resize/downsample the image.
This will generate the small images (.png/.jpg) from the original (large) brain section image (.png/.jpg).
Before quitting the folder, make sure you have removed the original brain section (.png/.jpg) image from each folder.

#### 3. Make a sample training file by running the following script at the location where /dataset folder is located:
```
training_generic_DeNeRD.m 
```
This will create your first training file (training.mat) and will be saved in the current folder.


#### 4. Run the following script where your dataset folder is located to start drawing the ground truth (bounding boxes) on top of your object(s) of interest: neurons, etc.
Remove the additional (preset) bounding boxes from the top left corner of each image before moving to the next image and so on.
```
SimpleGUI.m
```
Feel free to navigate to the left and right images. Your progress will be saved automatically. You can also close the MATLAB and reload your training.mat file to resume your ground truth collection. When you are finished, you can close the SimpleGUI and your final training.mat file is ready for the deep neural network.

#### 5. Make a new RCNN file for your current project. Change the testing and training images to the ones in your dataset. Run the following script:
```
RCNN.m
```
Training session of the deep neural network can be observed now. Once you have your final detector ready then SAVE IT!

#### 6. Run the following script to analyse your brain sections and save them in your machine as stars_sect_N.png.
```
montage.m 
```

The pipeline takes a brain section as input and generates detections on the neurons as bounding boxes:
![alt text](https://github.com/itsasimiqbal/DeNeRD/blob/master/Figure_2.jpg)

## Cite:
If you use any part of this code for your work, please cite the following:
```
Iqbal, Asim, Asfandyar Sheikh, and Theofanis Karayannis. 
"DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning." 
Scientific Reports 9.1 (2019): 1-13.
```

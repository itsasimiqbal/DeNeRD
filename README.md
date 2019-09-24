# DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning

#### [Iqbal, A., Sheikh, A. and Karayannis, T., 2019. DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning. Nature Scientific Reports](http://www.nature.com/articles/s41598-019-50137-9)

The block diagram of our system is demonstrated below:

![alt text](https://github.com/itsasimiqbal/DeNeRD/blob/master/DeNeRD_block.png)

The pipeline takes a brain section as input and generates detections on the neurons as bounding boxes:
![alt text](https://github.com/itsasimiqbal/DeNeRD/blob/master/Figure_2.jpg)

# Download:
#### Clone the DeNeRD repository by running the following command in your terminal window:
```
git clone https://github.com/itsasimiqbal/DeNeRD.git
```

# Steps to follow to run the DeNeRD on your dataset:

#### 1. Copy/Download your dataset images and place them in a folder called dataset, you can put each brain section image inside sub-folders: i01, i02, ...
```
dataset->i01,i02,...iN
```

#### 2. Navigate inside dataset/i01...iN and run the following script:
```
imsection(10,10,pad_size,pad_color)
```
pad_size = 10;
pad_color = 0/1 (binary) | 0/255 (RGB)
Before quitting the folder, make sure you have removed the brain section from this folder.

#### 3. Make a sample training file by running the following script at the location where /dataset folder is located:
```
create_training_generic.m in the folder 
```
This will create your first training file. This training file will be called training.mat and will be saved in the current folder.


#### 4. Run the following script where your dataset folder is located to start drawing your bounding boxes. Remove the additional bounding box 
in the top left corner of the image.
```
SimpleGUI.m
```
Your progress will be saved automatically. When you are finished, you can close the SimpleGUI and your final training file is ready for the network.

#### 5. Make a new RCNN file for your current project. Change the testing and training images to the
ones in your dataset. Run the following script:
```
RCNN.m
```
Training session of the deep neural network can be observed now. Once you have your final detector ready then SAVE IT!

#### 6. Run the following script to analyse your brain sections and save them in your machine as stars_sect_N.png.
```
montage.m 
```

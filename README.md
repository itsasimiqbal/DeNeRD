# DeNeRD
high-throughput detection of neurons for brain-wide analysis with deep learning

#### [Iqbal, A., Sheikh, A. and Karayannis, T., 2019. DeNeRD: high-throughput detection of neurons for brain-wide analysis with deep learning. Nature Scientific Reports](http://www.nature.com/articles/s41598-019-50137-9)

# Download:
#### Clone the DeNeRD repository by running the following command in your terminal window:
```
git clone https://github.com/itsasimiqbal/DeNeRD.git
```

#### Steps to follow to run the DeNeRD:

1. Copy/Download your dataset images and place them in a folder
#### dataset->i01,i02,...iN]

2. Navigate inside dataset/i1...iN and run the following script:
#### imsection (10, 10, pad_size, pad_color)
pad_size = 10;
pad_color = 0/1 (binary) | 0/255 (RGB)
Before quitting the folder, make sure you have removed the brain section
from this folder.

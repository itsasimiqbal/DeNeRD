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

%% Data Augmentation
% Generate scale, intensity and rotation changes in the images
% https://ch.mathworks.com/matlabcentral/answers/57186-how-can-i-rescale-an-image-while-not-changing-the-dimension-of-the-image
function OutPicture = data_augmentation_DeNeRD(InPicture, ZoomFactor)
      % Si el factor de escala es 1, no se hace nada
      if ZoomFactor == 1
          OutPicture = InPicture;
          return;
      end
      % Se obtienen las dimensiones de las imágenes
      ySize = size(InPicture, 1);
      xSize = size(InPicture, 2);
      zSize = size(InPicture, 3);
      yCrop = floor(ySize / 2 * abs(ZoomFactor - 1));
      xCrop = floor(xSize / 2 * abs(ZoomFactor - 1));
      % Si el factor de escala es 0 se devuelve una imagen en negro
      if ZoomFactor == 0
          OutPicture = uint8(zeros(ySize, xSize, zSize));
          return;
      end
      % Se reescala y se reposiciona en en centro
      zoomPicture = imresize(InPicture, ZoomFactor);
      ySizeZ = size(zoomPicture, 1);
      xSizeZ = size(zoomPicture, 2);      
      if ZoomFactor > 1
          OutPicture = zoomPicture( 1+yCrop:yCrop+ySize, 1+xCrop:xCrop+xSize, :);
      else
          OutPicture = uint8(zeros(ySize, xSize, zSize));
          OutPicture( 1+yCrop:yCrop+ySizeZ, 1+xCrop:xCrop+xSizeZ, :) = zoomPicture;
      end
end
%% intensity play
% cd data_augmentation\
% image = imread('sect_2_ref_3_section83_40.png');
% figure;
% int_factor = 0.5;
% for i=1:20
%     subplot(10,2,i);
%     imshow(image*int_factor)
%     int_factor = int_factor+0.05;
% end
% cd ..
%% scale play
%figure; imshow( data_augmentation_DeNeRD(image, 2))
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
%% Image Sectioning Tool
% Use this function to chop up an image into smaller sections
% Specify image file, number of horizontal sections, and number of vertical sections
% Image should be in the same folder as the script file
% Image sections will be saved in the same folder as the script file (as .png, can be edited in script)
% Specify image using ' ', e.g. sections = section('banana.jpg',5,3)

function  [] = imsection(HorzSec,VertSec, pad_size, pad_color)
    resize_ratio = 1;%0.5
    path = pwd;
    filter = {'*.png'; '*.tif'; '*.jpg'};
    [images, imPath, ~] = uigetfile(filter, 'MultiSelect', 'On');
    if ischar(images)
        images = {images};
    end
    
    for imID = 1:numel(images)
        image = images{imID};
        I = imread(fullfile(imPath, image));
        resized = imresize(I,resize_ratio);
        x = size(resized,2);
        y = size(resized,1);
        xsec = HorzSec;
        ysec = VertSec;
        xsize = floor(x/xsec);
        ysize = floor(y/ysec);
        sections = xsec*ysec;
        k = 1;
        
        for j = 1:ysec
            fprintf('File %d of %d: Processing image %d of %d...\n', ...
                imID, numel(images), k, sections);
            if j == ysec % for the last vertical section:
                for i = 1:xsec
                       disp([num2str(j) '__' num2str(i)]);
                       message = strcat('ysec: ', num2str(j), 'xsec: ', num2str(i))
                   % disp(message);
                   % figure;
                    if i == xsec % for the last horizonal section:
                        %resized = imresize(I,resize_ratio); %0.7
                        cropped = imcrop(resized,[(i-1)*xsize+1,(j-1)*ysize+1,xsize+(x-(xsec*xsize))-1,ysize+(y-(ysec*ysize))-1]);
                        %x=10;
                        cropped = padarray(cropped,[pad_size pad_size],pad_color,'both');
                        filename = sprintf('%s_section%d_%d.png', image(1:end-4), j, i);
                        imwrite(cropped, filename);
                        %%subplot(ysec, xsec, k);
                        %I2 = imread(strcat('section',num2str(j), '_', num2str(i),'.png'));
                        %imshow(I2);
                        k = k + 1;
                        break
                        % the last section will be a few pixels larger because initailly, the sections
                        % were created with floor division (rounded down) to avoid exceeding the image borders
                    else
                        %resized = imresize(I,resize_ratio); %0.7
                        cropped = imcrop(resized,[(i-1)*xsize+1,(j-1)*ysize+1,xsize-1,ysize+(y-(ysec*ysize))-1]);

                        %x=10;
                        cropped = padarray(cropped,[pad_size pad_size],pad_color,'both');
                        filename = sprintf('%s_section%d_%d.png', image(1:end-4), j, i);
                        imwrite(cropped, filename);
                        %subplot(ysec, xsec, k);
                        %I2 = imread(strcat('section',num2str(j), '_', num2str(i),'.png'));
                        %imshow(I2);
                        k = k + 1;
                    end

                end
            else
                for i = 1:xsec
                    %message = strcat('ysec: ', num2str(j), 'xsec: ', num2str(i))
                    if i == xsec % for the last horizonal section:
                        %resized = imresize(I,resize_ratio); %0.7
                        cropped = imcrop(resized,[(i-1)*xsize,(j-1)*ysize+1,xsize+(x-(xsec*xsize))-1,ysize-1]);

                        %x=10;
                        cropped = padarray(cropped,[pad_size pad_size],pad_color,'both');
                        filename = sprintf('%s_section%d_%d.png', image(1:end-4), j, i);
                        imwrite(cropped, filename);
                        %subplot(ysec, xsec, k);
                        %I2 = imread(strcat('section',num2str(j), '_', num2str(i),'.png'));
                        %imshow(I2);
                        k = k + 1;
                        break
                        % the last section will be a few pixels larger because initailly, the sections
                        % were created with floor division (rounded down) to avoid exceeding the image borders
                    else
                        %resized = imresize(I,resize_ratio); %0.7
                        cropped = imcrop(resized,[(i-1)*xsize+1,(j-1)*ysize+1,xsize-1,ysize-1]);

                        %x=10;
                        cropped = padarray(cropped,[pad_size pad_size],pad_color,'both');
                        filename = sprintf('%s_section%d_%d.png', image(1:end-4), j, i);
                        imwrite(cropped, filename);
                        %subplot(ysec, xsec, k);
                        %I2 = imread(strcat('section',num2str(j), '_', num2str(i),'.png'));
                        %imshow(I2);
                        k = k + 1;
                    end


                    %Plotting

                end
            end
        end
        disp('Sections created:');
        disp(sections);
    end
end
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
function varargout = SimpleGUI(varargin)
% SIMPLEGUI MATLAB code for SimpleGUI.fig
%      SIMPLEGUI, by itself, creates a new SIMPLEGUI or raises the existing
%      singleton*.
%
%      H = SIMPLEGUI returns the handle to a new SIMPLEGUI or the handle to
%      the existing singleton*.
%
%      SIMPLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLEGUI.M with the given input arguments.
%
%      SIMPLEGUI('Property','Value',...) creates a new SIMPLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SimpleGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimpleGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimpleGUI

% Last Modified by GUIDE v2.5 06-Dec-2017 23:43:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimpleGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SimpleGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SimpleGUI is made visible.
function SimpleGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimpleGUI (see VARARGIN)

% Choose default command line output for SimpleGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

load('training.mat')

if ~ispc
    path = pwd;
%     filter = {'*.png'; '*.jpg'};
    [selectedFile, selectedPath] = uigetfile({'*.png'; '*.jpg'}, fullfile(path));%, filter));
    imagesInFolder = imageSet(selectedPath);
    parts = strsplit(selectedPath, '/');
    relevantPath = strcat(parts(end-1),'/', selectedFile);
else  
    path = pwd;
    %     filter = {'*.png'; '*.jpg'};
    [selectedFile, selectedPath] = uigetfile({'*.png'; '*.jpg'}, fullfile(path));%, filter));
    imagesInFolder = imageSet(selectedPath);
    parts = strsplit(selectedPath, '\');
    relevantPath = strcat(parts(end-1),'\', selectedFile);
    relevantPath = regexprep(relevantPath, '\', '/');
end

axes(handles.axes1)
set(hObject,'toolbar','figure');
set(hObject,'menubar','figure');

I = imread(char(strcat('dataset/', relevantPath)));
% image(I);

% currentIndex = 1;

for i = 1:size(training,1)
    condition = strfind(char(training{i,1}), char(relevantPath));
    if condition
        currentIndex = i;
        break;
    else
        continue;
    end
end

I = insertShape(I, 'Rectangle', training{currentIndex,2});
image(I)
set(handles.text5, 'String', string(training{currentIndex,1}));
axis off
axis image

% if occurencesWindows == []
%     save('training_OSX.mat', 'training', 'currentIndex', 'imagesInFolder')
% else
    save('training.mat', 'training', 'currentIndex', 'imagesInFolder')
% end


% UIWAIT makes SimpleGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SimpleGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in drawBound.
function drawBound_Callback(hObject, eventdata, handles)
% hObject    handle to drawBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% if occurencesWindows == []
%     load('training_OSX.mat')
% else
    load('training.mat')
% end

lim = axis;
rect = getrect;
[box_index,box_size] = size(training{currentIndex,2});
training{currentIndex,2}(box_index+1,1) = rect(1);
training{currentIndex,2}(box_index+1,2) = rect(2);
training{currentIndex,2}(box_index+1,3) = rect(3);
training{currentIndex,2}(box_index+1,4) = rect(4);
axes(handles.axes1)
I = imread(training{currentIndex,1});
I = insertShape(I, 'Rectangle', training{currentIndex,2});
image(I)
axis off
axis image
axis(lim)

% if occurencesWindows == []
%     save('training_OSX.mat', 'training', 'currentIndex', 'imagesInFolder')
% else
    save('training.mat', 'training', 'currentIndex', 'imagesInFolder')
% end

% --- Executes on button press in removeBound.
function removeBound_Callback(hObject, eventdata, handles)
% hObject    handle to removeBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% if occurencesWindows == []
%     load('training_OSX.mat')
% else
    load('training.mat')
% end

lim = axis;
toRemove = [];
rect = getrect;
for i = 1:size(training{currentIndex,2},1)
    condition = (rect(1) <= training{currentIndex,2}(i,1) & ...
        rect(2) <= training{currentIndex,2}(i,2) & ...
        rect(1)+rect(3) >= training{currentIndex,2}(i,1)+training{currentIndex,2}(i,3) & ...
        rect(2)+rect(4) >= training{currentIndex,2}(i,2)+training{currentIndex,2}(i,4));
    if condition
       toRemove = [toRemove i];
    else
        continue;
    end
end
 training{currentIndex,2}(toRemove,:) = [];
 axes(handles.axes1)
 I = imread(training{currentIndex,1});
 I = insertShape(I, 'Rectangle', training{currentIndex,2});
 image(I)
 axis off
 axis image
 axis(lim)
 
%  if occurencesWindows == []
%     save('training_OSX.mat', 'training', 'currentIndex', 'imagesInFolder')
% else
    save('training.mat', 'training', 'currentIndex', 'imagesInFolder')
%  end

 


% --- Executes on button press in previousImage.
function previousImage_Callback(hObject, eventdata, handles)
% hObject    handle to previousImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% if occurencesWindows == []
%     load('training_OSX.mat')
% else
    load('training.mat')
% end

imageCount = imagesInFolder.Count;

for index = 1:imageCount
    condition = strfind(training{currentIndex,1}, imagesInFolder.ImageLocation(1, index));
    if ~condition
        continue;
    else
%          if index == 1
%             Message = 'This is the firstt image in your current folder!';
%             msgbox(Message)
%             break;
%         else
            currentIndex = currentIndex-1;
            axes(handles.axes1)
            I = imread(training{currentIndex,1});
            I = insertShape(I, 'Rectangle', training{currentIndex,2});
            image(I)
            set(handles.text5, 'String', string(training{currentIndex,1}));
            axis off
            axis image

%             if occurencesWindows == []
%                 save('training_OSX.mat', 'training', 'currentIndex', 'imagesInFolder')
%             else
                save('training.mat', 'training', 'currentIndex', 'imagesInFolder')
%             end
            break;
        end
    end




% --- Executes on button press in nextImage.
function nextImage_Callback(hObject, eventdata, handles)
% hObject    handle to nextImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% os = getenv('os');
% occurencesWindows = findstr(os, 'Windows');
% 
% if occurencesWindows == []
%     load('training_OSX.mat')
% else
    load('training.mat')
% end

imageCount = imagesInFolder.Count;

for index = 1:imageCount
    condition = strfind(training{currentIndex,1}, imagesInFolder.ImageLocation(1, index));
    if ~condition
        continue;
    else
        if index == imageCount
            Message = 'This is the last image in your current folder!';
            break;
        else
            currentIndex = currentIndex+1;
            axes(handles.axes1)
            I = imread(training{currentIndex,1});
            I = insertShape(I, 'Rectangle', training{currentIndex,2});
            image(I)
            set(handles.text5, 'String', string(training{currentIndex,1}));
            axis off
            axis image

%             if occurencesWindows == []
%                 save('training_OSX.mat', 'training', 'currentIndex', 'imagesInFolder')
%             else
                save('training.mat', 'training', 'currentIndex', 'imagesInFolder')
%             end
            break;
        end
    end
end



% --- Executes on button press in changeImage.
function changeImage_Callback(hObject, eventdata, handles)
% hObject    handle to changeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('training.mat')

if ~ispc
    path = pwd;
%     filter = '*.png';
    [selectedFile, selectedPath] = uigetfile({'*.png'; '*.jpg'}, fullfile(path));%, filter));
    imagesInFolder = imageSet(selectedPath);
    parts = strsplit(selectedPath, '/');
    relevantPath = strcat(parts(end-1),'/', selectedFile);
else
    path = pwd;
%     filter = '*.png';
    [selectedFile, selectedPath] = uigetfile({'*.png'; '*.jpg'}, fullfile(path));%, filter));
    imagesInFolder = imageSet(selectedPath);
    parts = strsplit(selectedPath, '\');
    relevantPath = strcat(parts(end-1),'\', selectedFile);
    relevantPath = regexprep(relevantPath, '\', '/');
end


% image(I);

% currentIndex = 1;

for i = 1:size(training,1)
    currentImage = char(strcat('dataset/', string(relevantPath)));
    trainingFileLocation = char(training{i,1});
    if trainingFileLocation(end) == ' ' & size(currentImage) == size(trainingFileLocation(1:end-1))
        condition = (currentImage == trainingFileLocation(1:end-1));
    elseif trainingFileLocation(end) == ' ' & size(currentImage) ~= size(trainingFileLocation(1:end-1))
        continue;
    elseif trainingFileLocation(end) ~= ' ' & size(currentImage) == size(trainingFileLocation)
        condition = (currentImage == trainingFileLocation);
    else
        continue;
    end
    if condition
        currentIndex = i;
        break;
    else
        continue;
    end
end


axes(handles.axes1)
I = imread(char(strcat('dataset/', relevantPath)));
I = insertShape(I, 'Rectangle', training{currentIndex,2});
image(I)
set(handles.text5, 'String', string(training{currentIndex,1}));
axis off
axis image

% if occurencesWindows == []
%     save('training_OSX.mat', 'training', 'currentIndex', 'imagesInFolder')
% else
    save('training.mat', 'training', 'currentIndex', 'imagesInFolder')

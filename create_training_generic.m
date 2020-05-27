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
%% Boundaries using Local Maximum

tot_brain_sects=1;
for k=1:tot_brain_sects
    disp('first loop')
%    list=string(ls('dataset')); %get list of images in training folder
    list=string(ls('dataset')); %get list of images in training folder
    
    
    list(1:2)=[]; % delete first two entries because they are . and .. (???)
    list = sort_nat(list);
    list(:,1)=strcat('dataset/', list(:,1));
    
    trainingdata=list;
    trainingdata=array2table(trainingdata);
    trainingdata=table2cell(trainingdata);
    
    for j=1:size(list,1)
        disp('second loop')
%         [num, location]=count_localmax(char(list(j,1)));
        
%         bounds = zeros(num,4);
%         stats = regionprops('table',BW,'BoundingBox','MajorAxisLength','MinorAxisLength');
        
%         for i=1:num
%             close 
% %            bounds(i,:) = [location(i,1)-9,location(i,2)-9,18,18];
% %             bounds(i,:) = [location(i,1)-4,location(i,2)-4,8,8]; %6,6,12,12
% %             bounds(i,:)=stats.BoundingBox(i,:);
%             %disp('end of second loop')
%         end
        bounds = [1, 1, 10, 10]; % here a bouinding box is drawn in the top left corner of your image
        bounds3{j,1}=bounds;
        
        %disp('end of first loop')
    end
    
    s1 = horzcat(trainingdata,bounds3);
    s2{k,1}=s1;
    clear bounds3
%     s1 = horzcat(trainingdata,bounds3);
%     s2{k,1}=trainingdata;
%     clear bounds3
end

training = vertcat(s2{1:k,1});
training = cell2table(training);
training.training1=char(training.training1);
training = table2cell(training);

%training = vertcat(s2{1:1,1});
% training = vertcat(s2{1:k,1});
% training = cell2table(training);
% training.training=char(training.training);
% training = table2cell(training);

%save('training.mat', 'training');
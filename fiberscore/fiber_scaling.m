clc; clear; close all; %clearing up the workspace and desktop
TYPE = 'SVR'; 
mkdir(['output_data/' TYPE])

%% Load Data
disp('Reading input files...')
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
[datapath scale] = textread(TRAIN_INPUT,'%s %d');

    %% Load the image
% Loading the image. It can be a colored image or not, but right now you
% need to change the code to use the one you want
len = zeros(length(datapath),1);
for imgid=1:length(datapath)
disp('Reading image...')
%image_name = 'test.jpg'; % name of the file you want to use
image_name = datapath{imgid}; % name of the file you want to us

IMAGE = imread(image_name); %Use this if you have grayscale image
[x,y,D] = size(IMAGE); % get size of image

if D==1
    original = IMAGE;
elseif D >=3
RGB = IMAGE; %Use these lines if you have colored image

original = RGB(:,:,2); % green Channel 

BW = (original>200);
[L num_seg] = bwlabel(BW,8);

for i=1:num_seg
    num_pixels(i) = sum(sum(L==i));
end

[c id] = max(num_pixels);

len(imgid) = length(find(sum(L==id,1)>0));
% width(imgid) = length(find(sum(L==id,2)>0))
end
end

if (len<4)
    error('AHHHHH')
end
scalingFactor = scale./len;
%% Saving
disp('Saving...')
 save (['output_data/' TYPE '/scalingFactor.mat'], 'scalingFactor')
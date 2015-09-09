%% Fiber Histogram Visual
%--------------------------------------------------------------------------
% 
% Description:
%   Reads in angles and lengths from fiber_quantify output and produces
%   histograms for each set
%
% Author: 
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data: 
%   Mar 2012
%
% Notes: 
%   This program needs outputs from fiber_quantify.m
% 
% Input: 
%   key____.txt [file] classses for images in input____.txt 
%   lengths.mat [Cell Array] fiber lengths for all images in imput___.txt 
%   angles.mat [Cell Array] fiber angles for all images in imput___.txt 
%
% Output:
%   [Figures] Histogram of length and angles
%  
% Revision History:
%
%--------------------------------------------------------------------------


%% Load
clc;clear;close all;
TYPE = 'synth';
LENGTH = ['output_data/' TYPE '/lengths.mat'];
ANGLE = ['output_data/' TYPE '/angles.mat'];
PARAM = ['output_data/' TYPE '/param.mat'];

load(LENGTH)
load(ANGLE)
load(PARAM)

%% Displaying
i = 1% 3 9 14 18
% figure;
% map = colormap(hsv(max(lengths{i})));
% RGB = label2rgb(length_label,map); % color the segmented section
% title('Threshold with Labeled segment');
% h = imshow(RGB); % show the segment


TRAIN_INPUT = ['include/input_' TYPE '.txt'];
datapath = textread(TRAIN_INPUT,'%s');
image_name = datapath{i}; % name of the file you want to us
original= imread(image_name);
% original = rgb2gray(original(:,:,1:3));
figure; imagesc(original);colormap gray(256);


%% Histogram of Fiber Length
figure;
len_dist = lengths{i};
% len_dist(len_dist>100) = [];
hist(len_dist, length(len_dist)/5)
title('Histogram of Fiber Length')
%% Histogram of Fiber Orientation
figure;
hist(angles{i},2*param.K);
title(['Histogram of Fiber Orientation'])
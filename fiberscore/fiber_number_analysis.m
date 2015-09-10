%% Analysis on Fiber Threshold levels
%--------------------------------------------------------------------------
% 
% Description:
%   Reads outputs from fiber_detect and varys the intensity threshold to 
%   find the optimal threshold for removing fibers. Also varying the 
%   minimum fiber length to find the optimal thrshold for removing fibers.
%
% Author: 
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data: 
%   5 June 2012
%
% Notes: 
%   This program needs outputs from fiber_detect.m and function clean.m.
% 
% Input: 
%   index_cell [Cell Array] Correlation images for all images 
%   orientation_cell [Cell Array] orientation_cell images for all images
%   mean_cell [Cell Array] Mean intensity images for all images
%
% Output:
%   [Figure] Plot of # of fibers vs threshold values
%   [Figure] Plot of # of fibers vs min fiber length values
%  
% Revision History:
%
%--------------------------------------------------------------------------
clc; clear; close all; %clearing up the workspace and desktop

%% Location of files
TYPE = 'synth'; cell_id = 1;
% mkdir(['output_data/' TYPE])
INDEX_CLEAN = ['output_data/' TYPE '/index_clean.mat'];
ORIEN_CLEAN = ['output_data/' TYPE '/orient_clean.mat'];
MEAN_CLEAN = ['output_data/' TYPE '/mean_clean.mat'];
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
PARAM = ['output_data/' TYPE '/param.mat'];


%% Load files
load(INDEX_CLEAN)
load(ORIEN_CLEAN)
load(MEAN_CLEAN)
load(PARAM)
datapath = textread(TRAIN_INPUT,'%s');
tic;


[num_fibers min_length] = length_analysis(index_clean{cell_id});

image_name = ['Varying Min Fiber Length:' datapath{cell_id}];

figure;loglog(min_length,num_fibers);
axis([10 1000 1 500])
title(image_name,'Interpreter','none')
ylabel('# of fibers')
xlabel('Min fiber length values')
 slope = diff(num_fibers);
idxfiber = find(slope > -60,1, 'first');
fiber_length(cell_id) = min_length(idxfiber);

save(['output_data/' TYPE '/fiber_length.mat'], 'fiber_length');
save(['output_data/' TYPE '/num_fibers.mat'], 'num_fibers');
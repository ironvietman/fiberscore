%% Fiber Cleaning
%--------------------------------------------------------------------------
%
% Description:
%   Uses the result images from fiber_detect and removes unneeded fibers and crops
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   4 June 2012
%
% Notes:
%   This program needs outputs from fiber_detect.m and create_scripts.
%
% Input:
%   TYPE [in-code variable] Dataset type
%   input____.txt [file] Paths to images
%   index_cell [Cell Array] Correlation images for all images
%   orientation_cell [Cell Array] orientation_cell images for all images
%   mean_cell [Cell Array] Mean intensity images for all images
%
% Output:
%   index_clean [Cell Array] Correlation images for all images
%   orientation_clean [Cell Array] orientation_cell images for all images
%   mean_clean [Cell Array] Mean intensity images for all images
%
% Revision History:
%
%--------------------------------------------------------------------------
clc;clear;close all

%% Location of files
TYPE = 'synth_noise';
% Type List
%-----------
% CA
% IH
% shape_large
% shape_medium
% shape_small
%-----------

INDEX_MODEL = ['output_data/' TYPE '/index_cell.mat'];
ORIEN_MODEL = ['output_data/' TYPE '/orientation_cell.mat'];
MEAN_MODEL = ['output_data/' TYPE '/mean_cell.mat'];
MIN_FIBER = ['output_data/' TYPE '/fiber_length.mat'];
INTENSITY = ['output_data/' TYPE '/intensity.mat'];
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
datapath = textread(TRAIN_INPUT,'%s');

load(INDEX_MODEL)
load(ORIEN_MODEL)
load(MEAN_MODEL)


T = 00;
min_length = 10;

for cell_id = 1:size(index_cell)
    fprintf('On Cell: %d\n',cell_id);
    
indexfs = index_cell{cell_id};
meanfs = mean_cell{cell_id};
orientfs = orientation_cell{cell_id};

[MM NN] = size(indexfs);
BW = indexfs >0;
indexfs(BW==0) = 0;
    
    [BW_final] = directional_morph_clean(indexfs, 10,0, 25);



  %% Mask the real image
orientfs(BW_final==0) = -100; % set rejected pixels to -100
meanfs(BW_final==0) = 0;   % set rejected pixels to 0
indexfs(BW_final==0) = 0;  % set rejected pixels to 0

%  [BW] = length_clean(indexfs,min_length) ;
  BW = bwareaopen(indexfs > 0, min_length); % replace length_clean!!!
   %% Mask the real image
orientfs(BW==0) = -100; % set rejected pixels to -100
meanfs(BW==0) = 0;   % set rejected pixels to 0
indexfs(BW==0) = 0;  % set rejected pixels to 0

    %% Put in cell
    figure; imshow(indexfs);

    index_clean{cell_id} = indexfs;
    mean_clean{cell_id} = meanfs;
    orient_clean{cell_id} = orientfs;
    
end
%% Saving Clean favor
save (['output_data/' TYPE '/index_clean.mat'], 'index_clean')
save (['output_data/' TYPE '/mean_clean.mat'], 'mean_clean')
save (['output_data/' TYPE '/orient_clean.mat'], 'orient_clean')
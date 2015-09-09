%% Quantification
%--------------------------------------------------------------------------
% 
% Description:
%  Program uses isolated fiber images to calculate the length and angles
%
% Author: 
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data: 
%   20 Feb 2012
%
% Notes: 
%   This program uses outputs from fiber_detect
% 
% Input: 
%   index_cell [Cell Array] Correlation images for all images 
%   orientation_cell [Cell Array] orientation_cell images for all images
%   mean_cell [Cell Array] Mean intensity images for all images
%
% Output:
%   lengths.mat [Cell Array] fiber lengths for all images in imput___.txt 
%   angles.mat [Cell Array] fiber angles for all images in imput___.txt 
%  
%  
% Revision History:
%
%--------------------------------------------------------------------------
clc; clear; close all; %clearing up the workspace and desktop

%% Location of files
TYPE = 'synth_noise';
mkdir(['output_data/' TYPE])
INDEX_MODEL = ['output_data/' TYPE '/index_clean.mat'];
ORIEN_MODEL = ['output_data/' TYPE '/orient_clean.mat'];
MEAN_MODEL = ['output_data/' TYPE '/mean_clean.mat'];
TRAIN_INPUT = ['include/input_' TYPE '.txt'];


%% Load files
load(INDEX_MODEL)
load(ORIEN_MODEL)
load(MEAN_MODEL)
datapath = textread(TRAIN_INPUT,'%s');
lengths = cell(1,length(datapath));
angles = cell(1,length(datapath));
tic;
for cell_id=1:size(index_clean,2)
fprintf('on cell number: %d\n',cell_id)
[fiber_length orient] = angle_length_extract(orient_clean{cell_id}, mean_clean{cell_id});

%% Saving the fiber extractions
lengths{cell_id} = fiber_length;
angles{cell_id} = orient;

end

%% Save
save (['output_data/' TYPE '/lengths.mat'], 'lengths')
save (['output_data/' TYPE '/angles.mat'], 'angles')
fprintf('Took %g minutes to quantify the fibers and find the orientation\n',toc/60);


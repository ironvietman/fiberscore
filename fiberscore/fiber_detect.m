%% FiberScore
%--------------------------------------------------------------------------
% 
% Description:
%   Reads in paths to images from input text file and implements fiberscore.  
%
% Author: 
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data: 
%   20 Feb 2012
%
% Notes: 
%   This program uses the functions fiber_corr.m and pix_displace.m.
% 
% Input: 
%   TYPE [in-code variable] Dataset type   
%   input____.txt [file] Paths to images 
%
% Output:
%   index_cell [Cell Array] Correlation images for all images 
%   orientation_cell [Cell Array] orientation_cell images for all images
%   mean_cell [Cell Array] Mean intensity images for all images
%  
% Revision History:
%
%--------------------------------------------------------------------------
clc; clear; close all; %clearing up the workspace and desktop

%% Set the type you want to analyze

% Type List
%-----------
% CA
% IH
% shape_large
% shape_medium
% shape_small
%-----------

TYPE = 'test'; 
mkdir(['output_data/' TYPE])
tic;
%% Typical parameter values
% The thresholds will need to bee adjusted need to find a way get get these
% automatically.

K=6;        % Angular resolution
L = 6;      % Kernal size. Needs to be an even number so that there will be a center when building
w = 1;      % one pixel value
TC = .2;    % threshold for correlation coefficient with a Gaussian profile
M = .01;    % threshold for NSD
N = 1.1;     % threshold for ratio of NSD between the perpendicular rods


%% Load Data
disp('Reading input files...')
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
datapath = textread(TRAIN_INPUT,'%s');
%KEY = 'include/key_CA.txt'; %0 to 9
%label = textread(KEY);            

%% Initialize
index_cell = cell(size(datapath));
orientation_cell =cell(size(datapath));
mean_cell =cell(size(datapath)) ; 

for imgid=1:length(datapath)

    %% Load the image
% Loading the image. It can be a colored image or not, but right now you
% need to change the code to use the one you want

disp('Reading image...')
%image_name = 'test.jpg'; % name of the file you want to use
image_name = datapath{imgid}; % name of the file you want to us
% %% Load the image

IMAGE = imread(image_name); %Use this if you have grayscale image
[x,y,D] = size(IMAGE); % get size of image

if D==1
    original = IMAGE;
elseif D >=3
RGB = IMAGE; %Use these lines if you have colored image
% original = rgb2gray(RGB(:,:,1:3)); % all channels
original = RGB(:,:,1); % red Channel 

end

% T = max(max(original))*.30 ; 
 T = .3;
% T = max(max(original))*.1 ;     % threshold for background-subracted intensity value for a 
              % fiber in the acquired image. This values depends on the 
              % image and is about 100 for a 12-bit sturated image

%% Enhancement
   orig_eq = adapthisteq(original);
% orig_eq = original; % This is for Coronal 
              
%% FiberScore
[index orientation mean_fs] = fiberscore_conv(image_name,orig_eq,K,L,TC,M,N,T);


%% Add to Cell Struct
index_cell{imgid} = index;
orientation_cell{imgid} = orientation;
mean_cell{imgid} = mean_fs;
 imshow(index)
end
%%Make Param Struct
param.K=K;
param.L=L;
param.w=w;
param.TC=TC;
param.M=M;
param.N=N;
param.T=T;

%% Saving the fiber extractions
save (['output_data/' TYPE '/index_cell.mat'], 'index_cell')
save (['output_data/' TYPE '/orientation_cell.mat'], 'orientation_cell')
save (['output_data/' TYPE '/mean_cell.mat'], 'mean_cell')
save (['output_data/' TYPE '/param.mat'], 'param')

 fprintf('Took %g minutes to extract the fibers and find the orientation\n',toc/60);

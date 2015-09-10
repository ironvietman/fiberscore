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
[N M] = size(mean_clean{cell_id});

    %% Threshold 
    BW = mean_clean{cell_id} ~=0; 
% %% Threshold with graythresh method image.
% 
% level = graythresh(index_cell{cell_id});
% BW = im2bw(index_cell{cell_id}, level);
% 
% BW = bwmorph(BW,'open',inf);
% BW = bwmorph(BW,'close',inf);
% BW = bwmorph(BW, 'skel', inf);

%% Label filiments
[L,num_fibers] = bwlabel(BW, 8); %Label the white stuff
length_label = zeros(N,M);

ii=1;
max_num_fiber = 0;
fiber_length = [];
for i=1:num_fibers
len = sum(sum(L==i)); % measure the length
id = find(L ==i); % pixels with label L
length_label(id) = len;
if len>=0
    fiber_length(ii) = len;
    ii=ii+1;
end
if len> max_num_fiber
    max_num_fiber = len;
end
end

%% Orientation
% num_orient = numel(orientation_cell{cell_id});
% orient = reshape(orientation_cell{cell_id},1,num_orient);
orient = orient_clean{cell_id}(BW==1);
orient = orient(orient~=-100)*180/pi;

%%Stardard Deviation of Intensity
SD_density = std(mean_clean{cell_id});

%% Saving the fiber extractions
lengths{cell_id} = fiber_length;
angles{cell_id} = orient;
sd_density{cell_id} = SD_density;


% % %% Displaying
% % close all;
% % figure;
% % map = colormap(hsv(max_num_fiber));
% % RGB = label2rgb(length_label,map); % color the segmented section
% % imshow(I_graythresh);
% % title(['Threshold with Labeled segment:' datapath{cell_id}],'Interpreter','none');
% % hold on
% % h = imshow(RGB); % show the segment
% % set(h,'AlphaData', 0.6) % make it transparent
% % hold off
% % %% Histogram of Fiber Length
% % figure;
% % hist(fiber_length, length(fiber_length)/5)
% % title(['Histogram of Fiber Length: ' datapath{cell_id}],'Interpreter','none')
% % %% Histogram of Fiber Orientation
% % figure;
% % hist(orient);
% % title(['Histogram of Fiber Orientation: ' datapath{cell_id}],'Interpreter','none')
end

%% Save
save (['output_data/' TYPE '/lengths.mat'], 'lengths')
save (['output_data/' TYPE '/angles.mat'], 'angles')
save (['output_data/' TYPE '/sd_density.mat'], 'sd_density')
fprintf('Took %g minutes to quantify the fibers and find the orientation\n',toc/60);
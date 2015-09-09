%% Do some Statistics
clc;clear;close all

%% Location of files
TYPE = 'test';

INDEX_MODEL = ['output_data/' TYPE '/index_clean.mat'];
ORIEN_MODEL = ['output_data/' TYPE '/orient_clean.mat'];
MEAN_MODEL = ['output_data/' TYPE '/mean_clean.mat'];
FIBER = ['output_data/' TYPE '/lengths.mat'];
ORIENT = ['output_data/' TYPE '/angles.mat'];
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
datapath = textread(TRAIN_INPUT,'%s');

%% Load
load(FIBER);
load(ORIENT);
load(INDEX_MODEL);
load(ORIEN_MODEL);
load(MEAN_MODEL);

%% Get Stats
for i=1:size(lengths,2)
    
    image_name = datapath{i}; % name of the file you want to us
    original= imread(image_name);

%     original = rgb2gray(original(:,:,1:3));
    
    %% Enhancement
    orig_eq = adapthisteq(original);
    
     %% Threshold with graythresh method image.


     BW = mean_clean{i} ~=0;     
%     level = graythresh(index_cell{i});
%     BW = im2bw(index_cell{i}, level);
% %     figure
% %     imagesc(BW)
%     
%     BW = bwmorph(BW,'open',inf);
% %     figure
% %     imagesc(BW)
%     BW = bwmorph(BW,'close',inf);
% %     figure
% %     imagesc(BW)
%    BW = bwmorph(BW, 'skel', inf);
% %       figure
%     imagesc(BW)

    %% Getting the totals
    clc
    fprintf('Totals for image: %s',image_name)
    total_fiber_length(i) = sum(lengths{i})/length(lengths{i})
    total_fiberscore = sum(sum(orig_eq(BW==1)))
    
    total_mean = sum(mean_clean{i}(BW==1));
    
    Dx=sum(mean_clean{i}(BW==1).*cos(2*orient_clean{i}(BW==1)))/total_mean;
    Dy=sum(mean_clean{i}(BW==1).*sin(2*orient_clean{i}(BW==1)))/total_mean;
    
    polarity = sqrt(Dx^2+Dy^2)
    
    mean_angle = 1/2*atan(Dy/Dx)*180/pi
    
    int_over_len = total_fiberscore/total_fiber_length(i)
    
    
%     S = stdfilt(mean_cell{i}, ones(51));
%     figure
%     imagesc(S)
%         figure
%     imagesc(mean_cell{i})
% figure
%     plot(std(mean_cell{i}))
%     axis([0 700 0 60])
end

%     fold_reduce = mean(total_fiber_length(11:20))/mean(total_fiber_length(1:10))
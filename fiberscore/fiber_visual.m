%% Display Fibers
%--------------------------------------------------------------------------
% 
% Description:
%  Display the output from fiber_detect and fiber_clean
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
%   index_clean [Cell Array] Correlation images for all images
%   orientation_clean [Cell Array] orientation_cell images for all images
%   mean_clean [Cell Array] Mean intensity images for all images
%
% Output:
%   [Figures] images of correlation, orientation, and mean insensity 
%  
%  
% Revision History:
%
%--------------------------------------------------------------------------

clc;clear;close all
%% Location of files
TYPE = 'test';
INDEX_MODEL = ['output_data/' TYPE '/index_cell.mat'];
ORIEN_MODEL = ['output_data/' TYPE '/orientation_cell.mat'];
MEAN_MODEL = ['output_data/' TYPE '/mean_cell.mat'];
INDEX_CLEAN = ['output_data/' TYPE '/index_clean.mat'];
ORIEN_CLEAN = ['output_data/' TYPE '/orient_clean.mat'];
MEAN_CLEAN = ['output_data/' TYPE '/mean_clean.mat'];
TRAIN_INPUT = ['include/input_' TYPE '.txt'];
datapath = textread(TRAIN_INPUT,'%s');

load(INDEX_MODEL)
load(ORIEN_MODEL)
load(MEAN_MODEL)
load(INDEX_CLEAN)
load(ORIEN_CLEAN)
load(MEAN_CLEAN)

%fig_num= input('Enter the figure number: ');

for fig_num = 1%[11 15 28 45]; % 3 9 14 18

image_name = datapath{fig_num}; % name of the file you want to us
original= imread(image_name);


%% Enhancement
[x1,y1,D] = size(original); % get size of image

if x1 >2700
y = 1300:1900;
x = 2050:2700;
original = original(y,x);
original =  double(original)/max(max(double(original)));
end

if D >=3
    original = rgb2gray(original(:,:,1:3));
end
 orig_eq = adapthisteq(original);
    orig_eq = double(orig_eq)/max(max(double(orig_eq)));
    modi = enhance_image(orig_eq);
   orig_eq = orig_eq+modi;

%% Display
close all;
figure; imshow(original); colormap gray;
figure; imagesc(modi);
figure; imshow(orig_eq); colormap gray;
figure; imshow(index_cell{fig_num}); colormap gray;
figure; imshow(orientation_cell{fig_num}*180/pi); colormap jet; caxis([-100 180]); colorbar; 
figure; imshow(mean_cell{fig_num}); colormap jet;  %caxis([1 256]);% colorbar;
% figure; imshow(index_clean{fig_num}); colormap gray(256);
% figure; imshow(orient_clean{fig_num}*180/pi); colormap jet; caxis([-100 180]); colorbar; 
% figure; imshow(mean_clean{fig_num}); colormap jet; % caxis([1 256]);% colorbar;

%% overlay
figure;
imshow(original, 'InitialMag', 'fit')
green = cat(3, zeros(size(original)), ones(size(original)), zeros(size(original)));
hold on
h = imshow(green);
hold off
set(h, 'AlphaData', index_clean{fig_num})

%% Angle stuff

 HSI_image= zeros(x1,y1,3);
    HSI_image(:,:,1) = (orientation_cell{fig_num})/(pi);
    HSI_image(:,:,2) = 1;
    HSI_image(:,:,3) = mean_cell{fig_num}/max(max(mean_cell{fig_num}));
    
    HSI_image(:,:,1) = abs(HSI_image(:,:,1)-1);
    
    RGB_image = hsv2rgb(HSI_image); % Flip the angles so the colors match
   
    fig = figure; image(RGB_image,'CDataMapping','scaled'); colormap(hsv); caxis([0 180]);
    colorbar; mycmap = get(fig,'Colormap'); set(fig,'Colormap',flipud(mycmap)); axis off;

end
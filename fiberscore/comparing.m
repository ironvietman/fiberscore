%% Comparing version so fiberscore
clc; clear;close all

%% Location of files
TYPE = 'test';
% Type List
%-----------
% CA
% IH
% shape_large
% shape_medium
% shape_small
%-----------

INDEX_MODEL = ['output_data/' TYPE '/index_cell.mat'];
INDEX_MODEL2 = ['output_data/' TYPE '/index_cell_conv.mat'];

X1=load(INDEX_MODEL);
X2=load(INDEX_MODEL2);



type_1 = X1.index_cell{1};
type_2 = X2.index_cell{1};

imshow(type_1); title('Conv');
figure; imshow(type_2); title('Version 12')

MSE1 = sum(sum((abs(double(type_1))-abs(double(type_2))).^2)/(numel(type_2)))


%%
% Y1 = load('orientation_cell3_5');
% Y2 = load('orientation_cell');
% 
% L=6;
% orient_1 = Y1.orientation_cell{1}(L:end-L,L:end-L);
% orient_2 = Y2.orientation_cell{1}(L:end-L,L:end-L);
% MSE2 = sum(sum((abs(double(orient_1))-abs(double(orient_2))).^2)/(numel(orient_2)))
% 
% figure;imagesc(orient_1*180/pi); colormap jet; caxis([-100 180]); colorbar;  title('Conv');
% 
% figure; imagesc(orient_2*180/pi); colormap jet; caxis([-100 180]); colorbar;  title('Version 12')
%===============================================================================
% Creates training input list and associated key for hadnwriting recognition
% project.
%-------------------------------------------------------------------------------
% References:
%-------------------------------------------------------------------------------
% Notes: 
%-------------------------------------------------------------------------------
% Author: Robert Pham
%
% Creation Date: 12 April 2012
%-------------------------------------------------------------------------------

%===============================================================================
clear;clc;

size = {'large' 'medium' 'small'};
cd ../

TRAIN_INPUT = ['include/input_shape.txt'];
KEY = ['include/key_shape.txt'];
fid_test = fopen(TRAIN_INPUT,'w');
fid_key = fopen(KEY,'w');

for i=1:length(size)


shape = {'Crossbow';'Disks';'H-cells';'Y-cells'};
classes = 4;


for k = 1:classes
    listing=ls(['../images/CYTOO/' shape{k} '/' shape{k} '-' size{i} '/*']);
    names = textscan(listing,'%s');
%     path = what(['../images/CYTOO/' shape{k} '/' shape{k} '-' size{i}]);
    
    for l = 1:length(names{1})
    fprintf(fid_test,'%s\n', names{1}{l});
    fprintf(fid_key,'%d\n',k);
    end
end

end


fclose(fid_test);
fclose(fid_key);

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
% Creation Date: 4 Sept 2012
%-------------------------------------------------------------------------------

%===============================================================================
clear;clc;

NAME = {'Emma', 'Frog', 'SB', 'SVR'};
cd ../
for i=1:length(NAME)

TRAIN_INPUT = ['include/input_' NAME{i} '.txt'];
KEY = ['include/key_' NAME{i} '.txt'];
fid = fopen(TRAIN_INPUT,'w');
fid_key = fopen(KEY,'w');

%shape = {'Crossbow';'Disks';'H-cells';'Y-cells'};
% classes = 4;

    listing=ls(['../images/' NAME{i} '/p*']);
    names = textscan(listing,'%s');
%     path = what(['../images/' NAME{i}]);
    
    for l = 1:length(names{1})
    fprintf(fid,'%s\n', names{1}{l});
     fprintf(fid_key,'1\n');
    end
    
    listing=ls(['../images/' NAME{i} '/s*']);
    names = textscan(listing,'%s');
%     path = what(['../images/' NAME{i}]);
    
    for l = 1:length(names{1})
    fprintf(fid,'%s\n',names{1}{l});
     fprintf(fid_key,'2\n');
    end


fclose(fid);
% fclose(fid_key);

end
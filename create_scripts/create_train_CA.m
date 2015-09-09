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

N_tests = 5; % number of tests (digits and example picked at random)

TRAIN_INPUT = '../include/input_CA_train.txt';
KEY = '../include/key_CA_train.txt';
fid_test = fopen(TRAIN_INPUT,'w');
fid_key = fopen(KEY,'w');


drug={'prop', 'sham'} ;
classes=2;

for k=1:classes
for n = 1:N_tests
    fprintf(fid_test,'../images/IH_and_CA/CA_%s_%d_actin.jpg\n',drug{k},n);
    fprintf(fid_key,'%d\n',k);
end
end

fclose(fid_test);
fclose(fid_key);


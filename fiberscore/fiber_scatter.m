%% Do some Statistics
clc;clear;close all

%% Location of files
TYPE = 'Emma';

INDEX_MODEL = ['output_data/' TYPE '/index_clean.mat'];
ORIEN_MODEL = ['output_data/' TYPE '/orient_clean.mat'];
MEAN_MODEL = ['output_data/' TYPE '/mean_clean.mat'];
FIBER = ['output_data/' TYPE '/lengths.mat'];
ORIENT = ['output_data/' TYPE '/angles.mat'];
KEY_INPUT = ['include/key_' TYPE '.txt'];
key = textread(KEY_INPUT,'%d');

%% Load
load(FIBER);
load(ORIENT);
% load(INDEX_MODEL);
% load(ORIEN_MODEL);
% load(MEAN_MODEL);
X =[];
prop = [];
sham = [];

%% Sort Data
for i=1:size(lengths,2)
    

    clc
    fprintf('Totals for image: %d\n',i)
    fiber_mean(i) = mean(lengths{i});
    fiber_error(i) = std(lengths{i});
    
    
if key(i) ==1;
    name = 'propranolol';
    prop = [prop ; repmat(name,length(lengths{i}),1)];
elseif key(i) == 2;
    name = 'sham';
    sham = [sham ; repmat(name,length(lengths{i}),1)];
end
Group{i} = name;
X = [X ; lengths{i}'];

end

G = cellstr(prop);
for cell_id = length(G)+1:length(G)+length(sham)
    G{cell_id} = 'sham';
end


%% Display
figure;
boxplot(X,G)
title('Individual fiber length')
ylabel('Fiber Length')

figure;
boxplot(fiber_mean,Group)
title('Mean fiber length')
ylabel('Mean Fiber Length')
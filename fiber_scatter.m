%% Do some Statistics
clc;clear;close all

%% Location of files

%TYPE = {'Emma' 'Frog' 'SB' 'SVR'};
TYPE = {'Emma'};
for kk=1:length(TYPE);
% INDEX_MODEL = ['output_data/' TYPE '/index_clean.mat'];
% ORIEN_MODEL = ['output_data/' TYPE '/orient_clean.mat'];
% MEAN_MODEL = ['output_data/' TYPE '/mean_clean.mat'];
FIBER = ['output_data/' TYPE{kk} '/lengths.mat'];
ORIENT = ['output_data/' TYPE{kk} '/angles.mat'];
SCALING = ['output_data/' TYPE{kk} '/scalingFactor.mat'];
KEY_INPUT = ['include/key_' TYPE{kk} '.txt'];
key = textread(KEY_INPUT,'%d');

%% Load
load(FIBER);
load(ORIENT);
load(SCALING);
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
    fiber_mean(i) = mean(lengths{i}*scalingFactor(i));
    fiber_error(i) = std(lengths{i}*scalingFactor(i));
    
% ***** This is for invividual *****   
if key(i) ==1;
    name = 'propranolol';
    prop = [prop ; repmat(name,length(lengths{i}),1)]; %repeat name for each of the length data points
elseif key(i) == 2;
    name = 'sham';
    sham = [sham ; repmat(name,length(lengths{i}),1)];
end
% **********************************

Group{i} = name; % mean data group using the key
X = [X ; (lengths{i}*scalingFactor(i))']; %individual

end


G = cellstr(prop); % individual data group

for cell_id = length(G)+1:length(G)+length(sham)
    G{cell_id} = 'sham';
end

[h p]=kstest2(fiber_mean(1:10),fiber_mean(11:22))
[h p]=kstest2(X(1:144),X(145:end))

%% Display
figure;
boxplot(X,G);
h1 = findobj(gcf,'tag','Outliers');
title(['Individual fiber length(' TYPE{kk} ')'])
ylabel('Fiber Length (um)')

figure;
boxplot(fiber_mean,Group);
h2 = findobj(gcf,'tag','Outliers');
title(['Mean fiber length(' TYPE{kk} ')'])
ylabel('Mean Fiber Length (um)')

%% Get rid outliers for mean

yc1 = get(h1,'YData');
yc2 = get(h2,'YData');

id_prop = find(key==1);
id_sham = find(key==2);
prop_dataset_mean = fiber_mean(id_prop);
sham_dataset_mean = fiber_mean(id_sham);
prop_dataset_mean(prop_dataset_mean>=min(yc2{2})) = [];
sham_dataset_mean(sham_dataset_mean>=min(yc2{1})) = [];

median_prop = median(prop_dataset_mean);
sem_prop = std(prop_dataset_mean)/sqrt(length(prop_dataset_mean));

median_sham = median(sham_dataset_mean);
sem_sham = std(sham_dataset_mean)/sqrt(length(sham_dataset_mean));

fprintf('\nFor Mean length dataset (%s)\n',TYPE{kk});
fprintf('--------------------------\n');
fprintf('Median \t\t|\t SEM\n');
fprintf('--------------------------\n');
fprintf('%.4f \t|\t %.4f \t (prop)\n', median_prop,sem_prop);
fprintf('%.4f \t|\t %.4f \t (sham)\n', median_sham,sem_sham);
%% Get rid outliers for individual

prop_dataset = X(1:length(prop));
sham_dataset = X(length(prop)+1:length(prop)+length(sham));
prop_dataset(prop_dataset>=min(yc1{2})) = [];
sham_dataset(sham_dataset>=min(yc1{1})) = [];


median_prop = median(prop_dataset);
sem_prop = std(prop_dataset)/sqrt(length(prop_dataset));

median_sham = median(sham_dataset);
sem_sham = std(sham_dataset)/sqrt(length(sham_dataset));

fprintf('\nFor individual length dataset (%s)\n',TYPE{kk});
fprintf('--------------------------\n');
fprintf('Median \t\t|\t SEM\n');
fprintf('--------------------------\n');
fprintf('%.4f \t|\t %.4f \t (prop)\n', median_prop,sem_prop);
fprintf('%.4f \t|\t %.4f \t (sham)\n', median_sham,sem_sham);

%% Replot the data for mean
name = 'propranolol';
prop = repmat(name,length(prop_dataset_mean),1);
name = 'sham';
sham = repmat(name,length(sham_dataset_mean),1);

G = cellstr(prop);
for cell_id = length(G)+1:length(G)+length(sham_dataset_mean)
    G{cell_id} = 'sham';
end

X = [prop_dataset_mean sham_dataset_mean];

figure;
boxplot(X,G);
title(['Mean fiber length(' TYPE{kk} ')'])
ylabel('Fiber Length (um)')


%% Replot the data for Individual
name = 'propranolol';
prop = repmat(name,length(prop_dataset),1);
name = 'sham';
sham = repmat(name,length(sham_dataset),1);

G = cellstr(prop);
for cell_id = length(G)+1:length(G)+length(sham_dataset)
    G{cell_id} = 'sham';
end

X = [prop_dataset; sham_dataset];

figure;
boxplot(X,G);
title(['Individual fiber length(' TYPE{kk} ')'])
ylabel('Fiber Length (um)')

%% Some Kstest for this


[h1,p1] = kstest2(prop_dataset,sham_dataset) %h is 1 if the test rejects the null hypothesis
[h2,p2] = kstest2(prop_dataset_mean,sham_dataset_mean)
end
function [indexfs meanfs orientfs] =...
    clean(index, mean2,orient, T,min_length)
%% Fiber Cleaning
%--------------------------------------------------------------------------
%
% Description:
%   Uses the result images from fiber_detect and removes unneeded fibers
%   and crops.
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   4 June 2012
%
% Notes:
%
%
% Input:
%   index [MxN uint8] Correlation image
%   mean2 [MxN uint8] Mean intensity image
%   orient [MxN uint8] Orientation image
%   T [Scaler] Intensity threshold level
%   min_length [Scaler] Minimum fiber length threshold
%
% Output:
%   indexfs [MxN uint8] Clean and cropped Correlation image
%   meanfs [MxN uint8] Clean and cropped Mean intensity image
%   orientfs [MxN uint8] Clean and cropped Orientation image
%
% Revision History:
%
%--------------------------------------------------------------------------

%% Remove Scale Bar
[M N] = size(index);
pixels = index(:,floor(N/2));
id_bar = find(pixels~=0,1,'last');

indexfs = index(1:id_bar-20,:);
meanfs = mean2(1:id_bar-20,:);
orientfs = orient(1:id_bar-20,:);
%     figure; imagesc(indexfs)
%% Clean up with Lengths
[MM NN] = size(indexfs);
BW2 = indexfs >.5;
%     figure; imagesc(BW2)
BW2 = bwmorph(BW2, 'shrink', inf);
BW2 = bwmorph(BW2, 'hbreak', inf);
BW2 = bwmorph(BW2, 'spur', inf);

%% Remove Short Fiberts
[L,num_fibers] = bwlabel(BW2, 8); %Label the white stuff
length_label = zeros(MM,NN);

ii=1;
max_num_fiber = 0;
for i=1:num_fibers
    len = sum(sum(L==i)); % measure the length
    id = find(L ==i); % pixels with label L
    length_label(id) = len;
end


idxthin = find(BW2 == 0);
orientfs(idxthin) = -100; % set rejected pixels to -100
meanfs(idxthin) = 0;   % set rejected pixels to 0
indexfs(idxthin) = 0;  % set rejected pixels to 0

idxsmall = find(length_label<min_length); 
% find fibers that are smaller than min_length
orientfs(idxsmall) = -100; % set rejected pixels to -100
meanfs(idxsmall) = 0;   % set rejected pixels to 0
indexfs(idxsmall) = 0;  % set rejected pixels to 0

%% Clean up with intensity
BW = meanfs >= T;   % mask to keep pixels with threshold greater than T

idx0 = find(BW==0);
orientfs(idx0) = -100; % set rejected pixels to -100
meanfs(idx0) = 0;   % set rejected pixels to 0
indexfs(idx0) = 0;  % set rejected pixels to 0


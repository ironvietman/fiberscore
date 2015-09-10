function [indexfs meanfs orientfs] = clean2(index, mean2,orient, T,min_length)
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
% [M N] = size(index);
% pixels = index(:,floor(N/2));
% id_bar = find(pixels~=0,1,'last');
%
% indexfs = index(1:id_bar-20,:);
% meanfs = mean2(1:id_bar-20,:);
% orientfs = orient(1:id_bar-20,:);
% %figure; imshow(indexfs)
%% Clean up with Morphology
indexfs = index;
meanfs = mean2;
orientfs = orient;

[MM NN] = size(indexfs);
BW = indexfs ~=0 ;

%% Initial cleaning
%   BW = bwmorph(BW, 'open', 1);
%   BW = bwmorph(BW, 'close', inf);
% figure; imshow(BW)

%% Directional cleaning
% %figure; imshow(BW)
BW_final = zeros(size(BW));
for ang=0:10:180%[0 90];
    se = strel('line',25,ang);
    IM = imopen(BW,se); %Remove things that are not in 15 or longer.
    BW_final = BW_final + IM;
    figure; imshow(BW_final);
end


%% Make thinner
% BW_final = bwmorph(BW_final, 'open', 1);
%figure; imshow(BW_final)
% BW_final = bwmorph(BW_final, 'close', 1);
%figure; imshow(BW_final)
 BW_final = bwmorph(BW_final, 'skel',inf);
%figure; imshow(BW_final)
% BW_final = bwmorph(BW_final, 'branchpoints', 1);
BW_final = bwmorph(BW_final, 'hbreak', inf);
 BW_final = bwmorph(BW_final, 'spur', 5);
% figure; imshow(BW_final)
%% Threshold
% idxweak = find(meanfs<.10);
% orientfs(idxweak) = -100; % set rejected pixels to -100
% meanfs(idxweak) = 0;   % set rejected pixels to 0
% indexfs(idxweak) = 0;  % set rejected pixels to 0
% BW_final(idxweak) = 0;

%% Mask the real image
orientfs(BW_final==0) = -100; % set rejected pixels to -100
meanfs(BW_final==0) = 0;   % set rejected pixels to 0
indexfs(BW_final==0) = 0;  % set rejected pixels to 0

BW_new= indexfs > 0;
%% Clean up with Lengths
[L,num_fibers] = bwlabel(BW_new, 8); %Label the white stuff
length_label = zeros(MM,NN);
%figure; imagesc(L)
ii=1;
max_num_fiber = 0;
for i=1:num_fibers
    len = sum(sum(L==i)); % measure the length
    id = find(L ==i); % pixels with label L
    length_label(id) = len;
end

idxsmall = find(length_label<=min_length); % find fibers that are smaller than min_length
BW_new(idxsmall) = 0;
%figure; imshow(BW_new)


%% Mask the real image
orientfs(BW_new==0) = -100; % set rejected pixels to -100
meanfs(BW_new==0) = 0;   % set rejected pixels to 0
indexfs(BW_new==0) = 0;  % set rejected pixels to 0



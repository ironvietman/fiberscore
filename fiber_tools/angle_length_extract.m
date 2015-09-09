function [fiber_length orient] = angle_length_extract(orient_clean, mean_clean)

%% Quantification
%--------------------------------------------------------------------------
%
% Description:
%  Program uses isolated fiber images to calculate the length and angles
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   5 June 2012
%
% Notes:
%
%
% Input:
%   orient_clean [MxN] orientation image from FS
%   mean_cell [MxN] Mean intensity image from FS
%
% Output:
%   fiber_length [Array] fiber lengths for input image
%   orient [Array] fiber angles for input image
%
%
% Revision History:
%
%--------------------------------------------------------------------------

[N M] = size(mean_clean);

%% Threshold
BW = mean_clean ~=0;

%% Label filiments
[L,num_fibers] = bwlabel(BW, 8); %Label the white stuff
length_label = zeros(N,M);

ii=1;
max_num_fiber = 0;
fiber_length = [];
for i=1:num_fibers
    len = sum(sum(L==i)); % measure the length
    id = find(L ==i); % pixels with label L
    length_label(id) = len;
    if len>=0
        fiber_length(ii) = len;
        ii=ii+1;
    end
    if len> max_num_fiber
        max_num_fiber = len;
    end
end

%% Orientation
orient = orient_clean(BW==1);
orient = orient(orient~=-100)*180/pi;


function [BW] = length_clean(indexfs,min_length)
%% Length Filtering (Method 5) 
%--------------------------------------------------------------------------
%
% Description:
%   Removes objects that are smaller than min_length
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   5 Oct 2012
%
% Notes:
%
%
% Input:
%   indexfs [MxN double] Correlation images for all images
%   min_length [Scalar] Minimum length for objects
%
% Output:
%   BW [MxN logical] Mask of objects greater than min_length
%
% Revision History:
%
%--------------------------------------------------------------------------

BW= indexfs > 0;
[MM NN] = size(BW);

%% Clean up with Lengths
[L,num_fibers] = bwlabel(BW, 8); %Label the white stuff
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
BW(idxsmall) = 0;
%figure; imshow(BW_new)
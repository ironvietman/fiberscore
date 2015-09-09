function [BW_final] = directional_morph_clean(index,LEN,gdir_thresh, ang_res)
%% Fiber Cleaning
%--------------------------------------------------------------------------
%
% Description:
%   Uses the input image to perform directional rank-max opening from
%   Soille to remove objects.
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
%   LEN [Scalar] Max length of template
%   gdir_thresh [Scalar] Threshold for final image
%   ang_res [Scalar] Number of points between 0 to 180
%
% Output:
%   BW_final [MxN logical] Mask of segmented objects
%
% Revision History:
%
%--------------------------------------------------------------------------

%% Clean up with Morphology
img = index;
[x y] = size(img);

ang=linspace(0,180,ang_res); % Get the angle resolution
D = length(ang);
union_set= zeros(x,y,D);

%% Perform Filtering
for i = 1:D
    se = strel('line',LEN,ang(i)); % line structuring element
    lambda = length(se.getneighbors);
    r = lambda;
    if r ==lambda
        IMG = imopen(img,se); % if r = lambda
    else
        IMG = ordfilt2(  ordfilt2(img,lambda-r+1,se.getnhood)  ,lambda,se.getnhood);
    end
    union_set(:,:,i) = min(img,IMG);
    figure(1); imagesc(union_set(:,:,i));
end

gdir = max(union_set,[],3) - min(union_set,[],3);
BW_final = gdir>gdir_thresh;
%% Make thinner
figure(1); imshow(BW_final);
BW_final = bwmorph(BW_final, 'skel',inf);
BW_final = bwmorph(BW_final, 'hbreak', inf);
BW_final = bwmorph(BW_final, 'spur', 5);
figure(1); imshow(BW_final)




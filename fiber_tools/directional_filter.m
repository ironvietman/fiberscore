function  [union_set ang] = directional_filter(img,ang_res,LEN)
%% Directional Morphological Filter
%--------------------------------------------------------------------------
%
% Description:
%   Uses the input image to perform directional rank-max opening from
%   Soille to get union image.
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   19 Nov 2012
%
% Notes:
%
%
% Input:
%   img [MxN double] input image
%   ang_res [Scalar] Number of points between 0 to 180
%   LEN [Scalar] Length of the structuring element
%
% Output:
%   union_set [Cell Array] Output image after rank-max filtering at each
%                           angle
%   ang [Array] Array of ang_res angles from 0 to 180
%
% Revision History:
%
%--------------------------------------------------------------------------
[x,y] = size(img); % get size of image

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
        IMG = ordfilt2(  ordfilt2(img,lambda-r+1,se.getnhood)...
            ,lambda,se.getnhood);
    end
    union_set(:,:,i) = min(img,IMG);
    
    figure(1); imagesc(union_set(:,:,i));
end

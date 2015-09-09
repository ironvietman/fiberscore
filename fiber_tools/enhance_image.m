function enhance = enhance_image(img)
%% Fiber Cleaning
%--------------------------------------------------------------------------
%
% Description:
%   Uses the input image to perform directional rank-max opening from
%   Soille to segment objects in an image image.
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   4 June 2012
%
% Notes:
%   Calls direction_filter
%
% Input:
%   img [MxN double] input image
%
% Output:
%   enhance [MxN double] Image of segmented objects
%
% Revision History:
%
%--------------------------------------------------------------------------
%% Parameters
LEN = 10;   % length of the structuring element (even only)
LEN2 =200;
angle_res = 10;


[x,y,Dim] = size(img); % get size of image


if Dim >=3
    RGB = img; %Use these lines if you have colored image
    img = rgb2gray(RGB(:,:,1:3));
end


img = double(img)/max(max(double(img)));

[union_set ang] = directional_filter(img,angle_res,LEN);
[union_set2 ang] = directional_filter(img,angle_res,LEN2);

C = imreconstruct(max(union_set,[],3), img);
D = imreconstruct(max(union_set2,[],3), img);

% figure(1);imshow(C);
% figure(2);imshow(D);
% figure(3);imagesc(C-D); title('Subtracted Image'); axis image; colorbar

enhance = C-D;

enhance(enhance==0) = 0;
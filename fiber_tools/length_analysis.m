function [num_fibers min_length] = length_analysis(indexfs,min_length)
%% Analysis on object length
%--------------------------------------------------------------------------
%
% Description:
%   Uses an array of lengths and finds the number of objects greater than
%   the lengths
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
%   min_length [Array] Array of lengths
%
% Output:
%   min_length [Array] Array of lengths
%   num_fibers [Array] Array of number of objects greater than length(i)
%
% Revision History:
%
%--------------------------------------------------------------------------

count=1;

% min_length = linspace(10,1000,20); % min length range

disp('Length calculations')
%% Hold threshold vary length
for  k= 1:length(min_length)%size(index_cell,1)
    % fprintf('Iteration: %d\n',k)
    
    
    % [BW] = length_clean(indexfs,min_length(k));
    BW_length = bwareaopen((indexfs > 0), round(min_length(k)));
    
    [L,num_fibers(count)] = bwlabel(BW_length,8); % find number of fibers
    count=count+1;
end



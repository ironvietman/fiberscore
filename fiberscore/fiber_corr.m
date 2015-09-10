function [mean_intensity standd norm_standd Corr] = fiber_corr(Pic,st_i,st_j,d_i,d_j,y_int,weight,rod_length)
%% Fiber Correlation
%--------------------------------------------------------------------------
%
% Description: 
%   Finds the Correlation coefficient, Standard deviation, normalized
%   standard deviation, and average pixel intensity of pixel i,j with the
%   rest of the rod
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   20 Feb 2012
%
% Notes:
%
%
% Input:
%   Pic [MxN uint8] padded image
%   st_i [Scaler] location of image pixel in padded image
%   st_j [Scaler] location of image pixel in padded image
%   d_i [1xL] shift in the horzontal direction within rod
%   d_j [1xL] shift in the vertical direction within rod
%   y_int [1xL] intensity of weighting along rod
%   weight [Scaler] Mean of intensity along rod
%   rod_length [Scaler] length of rod
%   
% Output:
%   mean_intensity [Scaler] Average intensity along rod
%   standd [Scaler] Standard Deviation of pixel i,j to the rod
%   norm_standd [Scaler] Normalized Standard Deviation of pixel i,j to the rod
%   Corr [Scaler] Correlation of pixel i,j to the rod
%
% Revision History:
%
%--------------------------------------------------------------------------

for x_id=1:length(d_i)
    x_I(x_id) =[Pic(st_i+d_i(x_id),st_j+d_j(x_id))]; %Intensity along rod
end




mean_intensity = sum(x_I/(rod_length+1)); % mean Image intensity % no need for Sqrt?
standd = sqrt(sum((x_I-mean_intensity).^2/(rod_length+1))); % Standard Deviation
norm_standd = standd/mean_intensity; %Normalized Standard Deviation

Corr = sum((x_I-mean_intensity).*(y_int-weight))/sqrt(sum((x_I-mean_intensity).^2).*sum((y_int-weight).^2)); % Correlation coefficient
function [shift_i shift_j] = pix_displace(theta,I)
%% Pixel displacement values
%--------------------------------------------------------------------------
% 
% Description:
%   Given Kernal parameters, this function finds the shifts to build the
%   rod kernel.
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
%   theta [scaler] Angle of the rod in radians
%   I [1xL] Map of points on rod
%
% Output:
%   shift_i [1xL] shift in the horzontal direction
%   shift_j [1xL] shift in the vertical direction
%  
% Revision History:
%
%--------------------------------------------------------------------------


if (theta <=  45*pi/180) || (theta >=  135*pi/180)
    shift_i = I; % Horizontal displacement 
    shift_j = I*(tan(theta)); % Vertical displacement along the angle
elseif (theta >  45*pi/180) && (theta <  135*pi/180)
    shift_i = I*(cot(theta)); % Horizontal displacement along the angle
    shift_j = I; % Vertical displacement
end


shift_j = round(shift_j); %make integer
shift_i = round(shift_i); %make integer


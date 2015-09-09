function range = remove_scalebar(index)
%% Find Scalebar
%--------------------------------------------------------------------------
%
% Description: 
%   Given a correlation image of an image with a scale bar. This will find
%   the scale bar and gives the location of the bar
%
% Author:
%   Robert Pham (rpham@nmsu.edu)
%
% Creation Data:
%   21 Nov 2012
%
% Notes:
%
%
% Input:
%   index [MxN double] Correlation image   
%   
% Output:
%   range [Array] Location of scalebar
%
% Revision History:
%
%--------------------------------------------------------------------------

id_final = 0;
[N M] = size(index);

for col = 1:M
pixels = index(:,col);
id_bar = find(pixels~=0,1,'last');

if id_bar > id_final
    id_final = id_bar;
end

end
range = 1:(id_final-20);

function [index orientation mean_intensity] = ...
fiberscore_conv(image_name,f,K,L,TC,M,N,T)
%% FiberScore
%--------------------------------------------------------------------------
%
% Description:
%  Program detects and segments fibers from the rest of the image. This is
%  done using a rod kernal(mask)
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
%   image_name [string] Name if the file you want to evaluate
%   RGB [MxNx3 or MxNx3] Colored image
%      or
%   f [MxN uint8] Grayscale image (prefered)
%   K       Angular resolution
%   L       Kernal size
%   w       one pixel value
%   TC      threshold for correlation coefficient with a Gaussian profile
%   M       threshold for NSD
%   N       threshold for ratio of NSD between the perpendicular rods
%   T       threshold for background-subracted intensity value for a
%                fiber in the acquired image. This values depends on the
%                image and is about 100 for a 12-bit sturated image
%
% Typical parameter values
% % The thresholds will need to bee adjusted need to find a way get these
% % automatically.
%
% K=3;        % Angular resolution
% L = 6;      % Kernal size
% w = 1;      % one pixel value
% TC = .2;    % threshold for correlation coefficient with a Gaussian 
%               profile
% M = .01;    % threshold for NSD
% N = .8;     % threshold for ratio of NSD between the perpendicular rods
% T = 50;     % threshold for background-subracted intensity value for a
%               % fiber in the acquired image. This values depends on the
%               % image and is about 100 for a 12-bit sturated image
%
%
% Output:
%   index [MxN] Image of the isolated fibers
%   orientation [MxN] Image of the fibers with values corresponding to the
%                     orientation
%   mean_fs [MxN] Image of something I dont know
%
%
% Revision History:Using Conv2 for calculations
%
%--------------------------------------------------------------------------

%% Initialize

disp('Initializing image matrix and typical parameters...')
[x,y,D] = size(f); % get size of image
% Fiber index at i,j equals the highest correlation with the rotated rod
% kernal, and is zeroed if all fiber values do not exceed preset
% thresholds, creathing a fiber mask
index = zeros(x,y);

% Orientation of the best correlated rod rotated about i,j
orientation = ones(x,y)*-100;

%Local average intensity along the rod at i,j
mean_intensity = ones(x,y)*-1;

CMP = zeros(x,y);
CM = zeros(x,y);

f=double(f)/max(max(double(f))); 
% the image convert to double instead of uint8

%% Pad the image
% The rods are diagonal so need to pad alot more than just the kernal
% length

pad = L+L/2+2; % Pad to the size of the kernel and then extra
P=zeros(x+pad,y+pad); % fill new sized image with zeros

for i=1:x
    for j=1:y
        P(i+round(pad/2),j+round(pad/2))=f(i,j); 
        % Center image in new Sized
    end
end

%% Make rotation angles
% Equally spaced rotation angles theta_k

min_angle = 0; % smallest angle
max_angle = pi/(2*K)*((K-1)); % Biggest angle
theta_k = (min_angle:pi/(2*K):max_angle)'; 
% Col vector of angles with spacing pi/(2*K)
theta_k_perp = theta_k +pi/2;

mean_fs = cell(size(theta_k));
nstd_fs = cell(size(theta_k));
corr_fs = cell(size(theta_k));

mean_fs_perp = cell(size(theta_k_perp));
nstd_fs_perp = cell(size(theta_k_perp));
corr_fs_perp = cell(size(theta_k_perp));

%% Pixel Displacements for Kernel
% del_i and del_l are L+1 two Dimensional pixel displacements, which
% represnt one-dimensional nonzero pixilated line of elements in the
% (L+1)x(L+1) rod kernal for each theta_k

I = ((-L/2):(L/2))'; % displacement values for making del_i and del_j

%-----------------------------------------------------

%% Template to compare to
std_dev = 2; % how narrow do you want it
mean_profile = 0;
xx = linspace(-6+mean_profile,6+mean_profile,L+1); % center at zero
y_I = exp(-.5*((xx-mean_profile)/std_dev).^2); % gausian profile

%% Build Kernel for Convolution
% This is a matrix of size L+1xL+1 that has a linear line of elements with
% a one
% (ex)
% [ 0 0 0 0 0 0 0
%   1 1 1 1 1 1 1
%   0 0 0 0 0 0 0]
% This gives a matrix that will be convolved with an image to get
% correlation. It is kinda like an averaging filter but just for one line
% and for different angle. The one above is for angle= 0 but we will have 
% a different pattern of ones for angle = 30 for example.


% tic % Timing the whole process
for l=1:length(theta_k) % Loop through every rotation angle
    
    % Status update of evaluation
    %---------------------------------------------------------
    clc
    fprintf('Reading image: %s\n', image_name);
    fprintf('Evaluating the image with theta_k = %.2f degrees\n',...
        theta_k(l)*180/pi);
    fprintf('Angles left to evaluate: %d\n',length(theta_k)-l);
    %---------------------------------------------------------
    
    [col row] = pix_displace(theta_k(l),I); 
    % Find displacement values in x and y direction
    [col_perp row_perp] = pix_displace(theta_k_perp(l),I); 
    % Find displacement values in x and y direction
    
    kernel = zeros(L+1); % intialize the kernel
    kernel_perp = zeros(L+1); % intialize for perp kernel
    kernel_y = zeros(L+1);
    kernel_y_perp = zeros(L+1);
    shift_center = round(length(col)/2); 
    % Converts to 0,0 point from center to left upper corner
    
    for i=1:length(col) % from center build out to get the linear template
        kernel(row(i)+shift_center,col(i)*(-1)...
            +shift_center)=1;  %make row of 1's for specified angle
        kernel_perp(row_perp(i)+shift_center,col_perp(i)*...
            (-1)+shift_center)=1; % perp angle
        kernel_y(row(i)+shift_center,col(i)*(-1)+...
            shift_center) = y_I(i); 
        % make it a weighted with gausian profile for specified angle
        kernel_y_perp(row_perp(i)+shift_center,...
            col_perp(i)*(-1)+shift_center) = y_I(i); % perp angle
    end
    
    %% Conv kernel with image for theta_k   
    term1 = imfilter(f, kernel_y,'conv'); % term 1 for corr
    term2 = imfilter(f, kernel,'conv')*sum(y_I)/(L+1); % term 2 for corr
    term3 =  ((L+1)/L)*(imfilter(f.^2, kernel,'conv')/(L+1)-...
        (imfilter(f, kernel,'conv')/(L+1)).^2);
    term4 = std(y_I);
    std_fs =  stdfilt(f, kernel);    
    mean_fs{l} = imfilter(f, kernel,'conv')*1/(L+1);    
    nstd_fs{l} = std_fs./mean_fs{l};    
    corr_fs{l} = (term1-term2)./(sqrt(term3).*term4*L);
    
    %% Conv kernel with image for theta_k_perp
    term11 = imfilter(f, kernel_y_perp,'conv'); 
    term22 = imfilter(f, kernel_perp,'conv')*sum(y_I)/(L+1); 
    term33 =  ((L+1)/L)*(imfilter(f.^2, kernel_perp,'conv')/...
        (L+1)- (imfilter(f, kernel_perp,'conv')/(L+1)).^2);
    std_fs_perp =  stdfilt(f, kernel_perp);
    
    mean_fs_perp{l} = imfilter(f, kernel_perp,'conv')*1/(L+1);
    nstd_fs_perp{l} = std_fs_perp./mean_fs_perp{l};
    corr_fs_perp{l} = (term11-term22)./(sqrt(term33).*term4*L);
    
    %% Discard things below thresholds
    idxgood = find( corr_fs{l} > TC...
        & nstd_fs{l} > M...
        & nstd_fs{l}./nstd_fs_perp{l} > N...
        & mean_fs_perp{l} > T);% Find pixels that are good for theta_k
    
    idxgoodperp = find( corr_fs_perp{l} > TC...
        & nstd_fs_perp{l} > M...
        & nstd_fs_perp{l}./nstd_fs{l} > N...
        & mean_fs{l} > T);% Find pixels that are good for theta_k_perp
    
    CMP(idxgood) = corr_fs{l}(idxgood); 
    % get values into an image
    CM(idxgoodperp) = corr_fs_perp{l}(idxgoodperp); 
    % get values into an image
    
    idxfinal = find(CM > CMP  &  CM > index); 
    % find highest corr for theta_k or theta_k_perp
    idxfinal_perp = find(CMP > CM  &  CMP > index);
    
    index(idxfinal) = CM(idxfinal); % fill in image for output
    orientation(idxfinal) = theta_k(l);
    mean_intensity(idxfinal) = mean_fs{l}(idxfinal);
    
    index(idxfinal_perp) = CMP(idxfinal_perp);
    orientation(idxfinal_perp) = theta_k_perp(l);
    mean_intensity(idxfinal_perp) = mean_fs_perp{l}(idxfinal_perp);
    
end %theta_k loop
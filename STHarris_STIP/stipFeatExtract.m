% ------------------------------------------------------------ %
% @func - NEED TO DEFINE
% @info - detect and adapt space-time interest points as well
%         as compute their descriptors.
% @var - 	videoName: Name of the video with directory
%			format: Type of the video
%					Supported to '.avi' and '.mp4'
% @output - fileDataStip: STIP database file.
%						  File type of the output is '.hdf5'
% ------------------------------------------------------------ %
function [fileDataStip] = stipFeatExtract(videoName, format);

% ------------------------------------------------------------ %
% Framing the Video
% ------------------------------------------------------------ %

if strcmp(format, 'avi')
    videoInfo = VideoReader(sprintf('%s.avi',name_prefix));
elseif strcmp(format, 'mp4')
    videoInfo = VideoReader(sprintf('%s.mp4',name_prefix));
else
    warning('Unsupported Video file format..');
    return;
end

% Number of frames for a video to be broken
numFrames = videoInfo.NumberOfFrames;

% To create the result matrix
f0 = il_rgb2gray(double(read(videoInfo, 1)));
f1 = zeros([size(f0), floor(numFrames/2)]);

for iFrame = 1:2:numFrames
    f1(:,:,(iFrame+1)/2) = il_rgb2gray(double(read(videoInfo, iFrame)));
end

% ------------------------------------------------------------ %
% For debug purpose only. Remove after verifying the code.
show_xyt(f1);
fprintf('press a key...\n'), pause
% ------------------------------------------------------------ %

% ------------------------------------------------------------ %
% Compute Harris Points
% ------------------------------------------------------------ %

% ----------------------------------------- %
% @brief - Define Spatial and Temporal scales
S = 2;
sxl2 = 4;       % Image Smoothing variance
sxi2 = S*sxl2;  % Smooth the Second Moment Matrix 
stl2 = 2;       % Video Smoothing variance in time
sti2 = S*stl2;  % Smooth the Second Moment Matrix
% ----------------------------------------- %

% ----------------------------------------- %
% @brief - Detect all points
% @var - pos: STIP points of the Video
% 		 val: Value for corresponding positions
% 		      selected by 'pos' matrix.
% 		 cimg: Corners of the images
% 		 L: Images after smoothing operation
[pos, val, cimg, L] = harris_xyt(f1, 0.01, sxl2, stl2, sxi2, sti2);
% ----------------------------------------- %

% ----------------------------------------- %
% @brief - Sort the points and select the strongest ones
% @var - sval: Sorted values in ascending order
% 		 sposind: Original positions of the sorted values
[sval, sposind] = sort(-val);
% ----------------------------------------- %

npts = min(size(pos, 1), 40);       % Number of points

% ----------------------------------------- %
% @brief - possel - This is the matrix(npts x 13(default))
%          and shows the best STIP harris points 
possel = pos(sposind(1:npts), :);   
% ----------------------------------------- %

% ------------------------------------------------------------ %
% For debug purpose only. Remove after verifying the code.
% Display detected points
showcirclefeatures_xyt(f1, possel(:, 1:5), [1 1 0]);
fprintf('press a key...\n'), pause
% ------------------------------------------------------------ %

% ------------------------------------------------------------ %
% Adapt Interest Points To The Scales And Velocity
% ------------------------------------------------------------ % 

posadaptall = [];
valadaptall = [];
for i = 1 : size(possel, 1)
    % Assign a row of STIP points at a time upto size of 
    % the matrix 'possel'. 
    posinit = possel(i, :);         

    fprintf('point %d of %d\n', i, size(possel, 1))
    [pos, posevol, val] = adaptharris2_xyt(f1, posinit, 0.25, 0.25,...
                                           20, [1 1 1], 64, 64);
    if size(pos, 1) > 0
        posadaptall = [posadaptall; pos];
        valadaptall = [valadaptall; val];
    end
end

% ------------------------------------------------------------ %
% For debug purpose only. Remove after verifying the code.
showcirclefeatures_xyt(f1, posadaptall(:, 1 : 5), [1 1 0]);
fprintf('press a key...\n'), pause
% ------------------------------------------------------------ %

% ------------------------------------------------------------ %
% Create the Database File for Keep Computed Adapt STIPs
% ------------------------------------------------------------ % 
% TODO: Have a look on h5create, h5write, etc.

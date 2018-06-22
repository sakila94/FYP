% ------------------------------------------------------------ %
% @func - frameAVideo(name_prefix, format, i1, i2)
% @info - read a video, frame it, and converts their values to
%         (double)grey and returns a 3D x-y-t image array.
% @var - name_prefix: Name of the video
%        format: Video supported formats
%                   '.avi', '.mp4'
% @output - 3D matrix with pixel values of the defined images
% ------------------------------------------------------------ %
function result = frameAVideo(name_prefix, format)

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
numFrames = videoInfo.NumberOfFrames; % TODO: Need to find the framing parameter and algorithm

% To create the result matrix
f0 = il_rgb2gray(double(read(videoInfo, 1)));
result = zeros([size(f0), floor(numFrames/2)]);

for iFrame=1:2:numFrames
    result(:,:,(iFrame+1)/2) = il_rgb2gray(double(read(videoInfo, iFrame)));
end



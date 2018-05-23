% ------------------------------------------------------------ %
% @func - il_rgb2gray(rgb)
% @info - converts n-channel image into a one channel
% @var - rgb: Input image. This may be either color image or
%             a gray image.
% @output - matrix of pixel values within 0 -255 scale
% ------------------------------------------------------------ %
function gray = il_rgb2gray(rgb)

if ismatrix(rgb)
  gray = rgb;
else
  gray = sum(rgb,3)/size(rgb,3);
end

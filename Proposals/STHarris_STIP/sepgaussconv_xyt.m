% ------------------------------------------------------------ %
% @func - sepgaussconv_xyt(f, sx2, st2)
% @info - Separable convolution of 3D signal f with a Spatial
%         Gaussian kernel of variance sx2 and temporal Gaussian
%         kernel of variance st2.
%         Makes Gauss convolution using multiplication in the
%         3D Fourier domain. Requires meomory = 4*size(f)
% @var - f: Set of images
%		 sx2: Variance of Spatial domain
%		 st2: Variance of Temporal domain
% @output - res: Response of the smoothing video
% ------------------------------------------------------------ %
function res = sepgaussconv_xyt(f, sx2, st2)

res = f;

% Spatial convolution
for i = 1:size(res, 3)
	res(:, :, i) = mydiscgaussfft(res(:, :, i), sx2);
end

% Temporal convolution
for i = 1:size(res, 1)
  	for j = 1:size(res, 2)
  	  	ftrans = fft(squeeze(res(i, j, :)));
  	  	tsize = length(ftrans);
  	  	t = transpose(0:tsize - 1);
  	  	res(i, j, :) = real(ifft(exp(st2*(cos(2*pi*(t/tsize)) - 1)).*ftrans));
  	end
end

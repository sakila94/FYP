% ------------------------------------------------------------ %
% @func - sepgaussconvfast_xyt(f,sx2,st2)
% @info - Separable convolution of 3D signal f with a Spatial
%         Gaussian kernel of variance sx2 and temporal Gaussian
%         kernel of variance st2.
%         Makes Gauss convolution using multiplicatuin in the
%         3D Fourier domain. Requires meomory = 4*size(f)
% @var - NEED TO DEFINE
% @output - NEED TO DEFINE
% ------------------------------------------------------------ %
function res = sepgaussconvfast_xyt(f,sx2,st2)


%ftrans = fft2(f);
ftrans = fft(f,[],1);
ftrans = fft(ftrans,[],2);
ftrans = fft(ftrans,[],3);

[ysize, xsize, tsize] = size(ftrans);
[y, x, t] = meshgrid(0:ysize-1,0:xsize-1,0:tsize-1);

%res = ifft(transpose(exp(sx2*(cos(2*pi*(y/ysize))+cos(2*pi*(x/xsize))- 2)+...
%                       st2*(cos(2*pi*(t/tsize))))) .* ftrans,[],1);

res = ifft(permute(exp(sx2*(cos(2*pi*(y/ysize))+cos(2*pi*(x/xsize))-2)+...
                     st2*(cos(2*pi*(t/tsize))-1)),[2 1 3]).*ftrans,[],1);
res = ifft(res,[],2);
res = real(ifft(res,[],3));

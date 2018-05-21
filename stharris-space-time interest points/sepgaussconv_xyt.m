function res=sepgaussconv_xyt(f,sx2,st2)

%
% res=sepgaussconv_xyt(f,sx,st)
%
%   separable convolution of 3D signal f with a spatial
%   Gaussian kernel of variance sx2 and temporal Gaussian
%   kernel of variance st2
%

res=f;

% spatial convolution
for i=1:size(res,3)
  res(:,:,i)=mydiscgaussfft(res(:,:,i),sx2);
end

% temporal convolution
for i=1:size(res,1)
  for j=1:size(res,2)
    ftrans=fft(squeeze(res(i,j,:)));
    tsize=length(ftrans);
    t=transpose(0:tsize-1);
    res(i,j,:)=real(ifft(exp(st2*(cos(2*pi*(t/tsize))-1)).*ftrans));
  end
end

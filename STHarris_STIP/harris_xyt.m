% ------------------------------------------------------------ %
% @func - harris_xyt(f, kparam, sxl2, stl2, sxi2, sti2, vx, vy)
% @info - Computes spatio-temporal interest points based on
%         Harris corner function.
% @var - NEED TO DEFINE
% @output - NEED TO DEFINE
% ------------------------------------------------------------ %
function [pos,val,cimg,L] = harris_xyt(f,kparam,sxl2,stl2,sxi2,sti2,vx,vy)

if nargin < 7
    vx = 0;
    vy = 0;
end

fastflag = 1;

% ----------------------------------------- %
% @brief - L is a matrix which returns the 
%          smoothing images after convoluting
%          with gaussian kernel
if fastflag
    L = sepgaussconvfast_xyt(f,sxl2,stl2);
    Lx = finitedifffast_xyt(L, dxmask3)*sqrt(sxl2);
    Ly = finitedifffast_xyt(L, dymask3)*sqrt(sxl2);
    Lt = finitedifffast_xyt(L, dtmask3)*sqrt(stl2);
else
    L = sepgaussconv_xyt(f,sxl2,stl2);
    Lx = crop3(filter3(extend3(L, 4, 4, 4), dxmask3, 'same'), 4, 4, 4)*sqrt(sxl2);
    Ly = crop3(filter3(extend3(L, 4, 4, 4), dymask3, 'same'), 4, 4, 4)*sqrt(sxl2);
    Lt = crop3(filter3(extend3(L, 4, 4, 4), dtmask3, 'same'), 4, 4, 4)*sqrt(stl2);
end
% ----------------------------------------- %

a11 = Lx.*Lx; 
a12 = Lx.*Ly; 
a13 = Lx.*Lt;
              
a22 = Ly.*Ly; 
a23 = Ly.*Lt;
a33 = Lt.*Lt;

clear Lx Ly Lt

% ----------------------------------------- %
% @brief - In this section, calculate mu
if fastflag
    a11 = sepgaussconvfast_xyt(a11,sxi2,sti2);
    a12 = sepgaussconvfast_xyt(a12,sxi2,sti2);
    a13 = sepgaussconvfast_xyt(a13,sxi2,sti2);
    a22 = sepgaussconvfast_xyt(a22,sxi2,sti2);
    a23 = sepgaussconvfast_xyt(a23,sxi2,sti2);
    a33 = sepgaussconvfast_xyt(a33,sxi2,sti2);
else
    a11 = sepgaussconv_xyt(a11,sxi2,sti2);
    a12 = sepgaussconv_xyt(a12,sxi2,sti2);
    a13 = sepgaussconv_xyt(a13,sxi2,sti2);
    a22 = sepgaussconv_xyt(a22,sxi2,sti2);
    a23 = sepgaussconv_xyt(a23,sxi2,sti2);
    a33 = sepgaussconv_xyt(a33,sxi2,sti2);
end
% ----------------------------------------- %

detC =  a11.*a22.*a33 + a12.*a23.*a13 + a13.*a12.*a23...
     - a11.*a23.*a23 - a12.*a12.*a33 - a13.*a22.*a13;

%trace2C = (a11 + a22 + a33).^2;
trace3C = (a11 + a22 + a33).^3;
  
% Harris function in 3D
%cimg=detC-0.04*trace2C;
cimg = detC - kparam*trace3C;

% local spatio-temporal maxima
[pos, val] = locmax26(cimg);

if size(pos,1)>0
    % velocity estimates
    [ysz,xsz,tsz] = size(f);
    ind = sub2ind([ysz xsz tsz],pos(:,1),pos(:,2),pos(:,3));

    %vx=-a13(ind)./(a33(ind));
    %vy=-a23(ind)./(a33(ind));

    vxa = (a12(ind).*a23(ind)-a22(ind).*a13(ind))./(a11(ind).*a22(ind)-a12(ind).*a12(ind));
    vya = (a12(ind).*a13(ind)-a11(ind).*a23(ind))./(a11(ind).*a22(ind)-a12(ind).*a12(ind));

    %vxb=zeros(size(ind));
    %vyb=zeros(size(ind));
    %indlen=length(ind);
    %for i=1:indlen
    %  ii=ind(i);
    %  [u,s,v]=svd([a11(ii) a12(ii) a13(ii); a12(ii) a22(ii) a23(ii); a13(ii) a23(ii) a33(ii)]);
    %  vxb(i)=u(1,3)/u(3,3);
    %  vyb(i)=u(2,3)/u(3,3);
    %end

    npts = size(pos, 1);
    pos = [pos sxl2*ones(npts, 1) stl2*ones(npts, 1) vxa vya ... %vx*ones(npts, 1) vy*ones(npts, 1) ...
       a11(ind) a12(ind) a13(ind) a22(ind) a23(ind) a33(ind)];
end

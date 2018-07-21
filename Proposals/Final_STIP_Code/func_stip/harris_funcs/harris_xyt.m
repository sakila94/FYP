% ------------------------------------------------------------ %
% @func - harris_xyt(f, kparam, sxl2, stl2, sxi2, sti2, vx, vy)
% @info - Computes spatio-temporal interest points based on
%         Harris corner function.
% @var - f: Video sequence
%        kparam: Constant for calculate MU
%        sxl2: Image smoothing variance (var)
%        stl2: Video smoothing variance
%        sxi2: Image smoothing var for second moment matrix
%        sti2: Video smoothing var for second moment matrix
% @output - pos: Matrix with positions, variances of spatial and 
%             temporal, corresponding velocities along x and y,
%             and relevant Lx, Ly, and Lt values
%           val: Values for positions
%           cimg: Harris function
%           L: Smoothing images matrix
% ------------------------------------------------------------ %
function [pos, val, cimg, L] = harris_xyt(f, kparam, sxl2, stl2, sxi2, sti2)

% ----------------------------------------- %
% @brief - L is a matrix which returns the 
%          smoothing images after convoluting
%          with gaussian kernel
L = sepgaussconvfast_xyt(f,sxl2,stl2);
Lx = finitedifffast_xyt(L, dxmask3)*sqrt(sxl2);
Ly = finitedifffast_xyt(L, dymask3)*sqrt(sxl2);
Lt = finitedifffast_xyt(L, dtmask3)*sqrt(stl2);
% ----------------------------------------- %

a11 = Lx.*Lx; 
a12 = Lx.*Ly; 
a13 = Lx.*Lt;
              
a22 = Ly.*Ly; 
a23 = Ly.*Lt;
a33 = Lt.*Lt;

clear Lx Ly Lt

% ----------------------------------------- %
% @brief - In this section, calculate MU
% @note - Calculation of the matrix values
%         given in EQUATION 7 in the paper
a11 = sepgaussconvfast_xyt(a11,sxi2,sti2);
a12 = sepgaussconvfast_xyt(a12,sxi2,sti2);
a13 = sepgaussconvfast_xyt(a13,sxi2,sti2);
a22 = sepgaussconvfast_xyt(a22,sxi2,sti2);
a23 = sepgaussconvfast_xyt(a23,sxi2,sti2);
a33 = sepgaussconvfast_xyt(a33,sxi2,sti2);
% ----------------------------------------- %

detC =  a11.*a22.*a33 + a12.*a23.*a13 + a13.*a12.*a23...
     - a11.*a23.*a23 - a12.*a12.*a33 - a13.*a22.*a13;

trace3C = (a11 + a22 + a33).^3;
  
% ----------------------------------------- %
% @brief - Harris function in 3D
% @note - In paper, it is denoted letter H
% @equation - H = det(MU) - k*trace^3(MU)
cimg = detC - kparam*trace3C;

% Local spatio-temporal maxima
[pos, val] = locmax26(cimg);

if size(pos, 1) > 0
    % velocity estimates
    [ysz, xsz, tsz] = size(f);
    ind = sub2ind([ysz xsz tsz], pos(:, 1), pos(:, 2), pos(:, 3));

    vxa = (a12(ind).*a23(ind)-a22(ind).*a13(ind))./(a11(ind).*a22(ind)-a12(ind).*a12(ind));
    vya = (a12(ind).*a13(ind)-a11(ind).*a23(ind))./(a11(ind).*a22(ind)-a12(ind).*a12(ind));

    npts = size(pos, 1);
    pos = [pos sxl2*ones(npts, 1) stl2*ones(npts, 1) vxa vya ...
       a11(ind) a12(ind) a13(ind) a22(ind) a23(ind) a33(ind)];
end

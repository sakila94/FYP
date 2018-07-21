% ------------------------------------------------------------ %
% @func - warpvelfloat_xyt(f, vx, vy, t0)
% @info - 
% @var - 	f: Video sequence
%			vx: velocity in spatial domain
%			vy: velocity in temporal domain
%			t0: 
% @output - fwarp:
% ------------------------------------------------------------ %
function fwarp = warpvelfloat_xyt(f, vx, vy, t0)

[ysz, xsz, tsz] = size(f);
[X, Y, T] = meshgrid(1:xsz, 1:ysz, 1:tsz);

vx = -vx; 
vy = -vy;

X = X + (T - t0)*vx; 
Xfloor = floor(X); 
Xplus = X - Xfloor;

Y = Y + (T - t0)*vy; 
Yfloor = floor(Y); 
Yplus = Y - Yfloor;

clear X Y
W{1} = abs((1 - Xplus).*(1 - Yplus)); 
X{1} = Xfloor;   
Y{1} = Yfloor;

W{2} = abs(  (Xplus).*(1 - Yplus)); 
X{2} = Xfloor + 1; 
Y{2} = Yfloor;

W{3} = abs((1 - Xplus).*  (Yplus)); 
X{3} = Xfloor;   
Y{3} = Yfloor + 1;

W{4} = abs(  (Xplus).*  (Yplus)); 
X{4} = Xfloor + 1; 
Y{4} = Yfloor + 1;

fwarp = zeros(size(f(:)));

for i=1:4
  X{i}(find(X{i}(:) < 1)) = 1; 
  X{i}(find(X{i}(:) > xsz)) = xsz;
  Y{i}(find(Y{i}(:) < 1)) = 1; 
  Y{i}(find(Y{i}(:) > ysz)) = ysz;
  
  ind = sub2ind([ysz xsz tsz], Y{i}(:), X{i}(:), T(:));
  fwarp = fwarp + f(ind).*(W{i}(:));
  
end

fwarp = reshape(fwarp, [ysz xsz tsz]);

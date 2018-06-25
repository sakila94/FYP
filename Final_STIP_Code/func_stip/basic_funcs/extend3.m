% ------------------------------------------------------------ %
% @func - extend3(data, ny, nx, nz)
% @info - Extend the 3D Matrix by given number of rows, columns 
%		  and heights.
% @var - data: 3D matrix
%		 ny, nx, nz: number of rows, columns, and heights
% @output - result: Extended 3D matrix
% ------------------------------------------------------------ %
function result = extend3(data, ny, nx, nz)

[ysize, xsize, zsize] = size(data);
newxsize = xsize + 2*nx;
newysize = ysize + 2*ny;
newzsize = zsize + 2*nz;
result = zeros(newysize, newxsize, newzsize);
result(ny + 1:ysize + ny, nx + 1:xsize + nx, nz + 1:zsize + nz) = data;

for y = 1:ny 
	result(y, :, :) = result(ny + 1, :, :); 
end
for y = ysize + ny + 1:newysize 
	result(y, :, :) = result(ysize + ny, :, :); 
end

for x = 1:nx 
	result(:, x, :) = result(:, nx + 1, :); 
end
for x = xsize + nx + 1:newxsize 
	result(:, x, :) = result(:, xsize + nx, :); 
end

for z = 1:nz 
	result(:, :, z) = result(:, :, nz + 1); 
end
for z = zsize + nz + 1:newzsize 
	result(:, :, z) = result(:, :, zsize + nz); 
end

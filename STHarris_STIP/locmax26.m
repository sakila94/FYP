% ------------------------------------------------------------ %
% @func - [pos, val] = locmax26(f)
% @info - Finds local maxima in 3D data array f
% @var - f: Matrix to find positive local maxima
% @output - pos: Matrix positions 
%			val: Value of the positions selected in 'pos'
% ------------------------------------------------------------ %
function [pos, val] = locmax26(f)

fext = extend3(f, 1, 1, 1);
res = ones(size(f));

for i = -1:1
	for j = -1:1
		for k = -1:1
		  	if i|j|k
		  	  	res = res.*(f > fext(2 + i:end-1 + i,...
		  	  		  2 + j:end-1 + j, 2 + k:end-1 + k));
		  	end
		end
	end
end

ind = find(res);
[x, y, z] = ind2sub(size(res), ind);
pos = [x y z];
val = f(ind);

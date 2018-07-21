% ------------------------------------------------------------ %
% @func - finitedifffast_xyt(L,dmask3)
% @info - The result is as filter3(L,dmask3,'same')
%         with faster computations due to the sparsness
%         of derivative masks 'dmask3'
% @var - NEED TO DEFINE
% @output - DL: Derivative of L 
% ------------------------------------------------------------ %
function DL = finitedifffast_xyt(L, dmask3)

mc = round(size(dmask3)/2);
nonzeroelemind = find(dmask3 ~= 0); %dmask3(:)
% Identifies Indexes to Subscripts as 3D axis
[y, x, t] = ind2sub(size(dmask3), nonzeroelemind);

DL = zeros(size(L));
for i = 1:length(nonzeroelemind)
  DL = DL + dmask3(nonzeroelemind(i))*...
  	   shiftsub_xyt(L,-(x(i)-mc(2)),-(y(i)-mc(1)),-(t(i)-mc(3)),1);
end
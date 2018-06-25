% ------------------------------------------------------------ %
% @func - dxmask3
% @info - This function is used to get the gradient
%         of the still image along X-axis
% @output - result: 
% ------------------------------------------------------------ %
function result = dxmask3

result=zeros(5,5,5);
result(3,2,3)=-.5;
result(3,4,3)= .5;

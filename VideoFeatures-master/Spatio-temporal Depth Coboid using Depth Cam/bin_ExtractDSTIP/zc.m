% calclcuate the number of flip of the signal x.
% output: n --number of flip
% r--ratio of flip
% ad--average duration of the flip
function [n,ad] = zc(x)
s=sign(x);

t=filter([1 1],1,s);
n=(length(s)-length(find(t)));

positive=sum(s>0);
negative=sum(s<1);

if(positive>negative)
    s=-s;
end;
duration=sum(s>-1);
ad=duration/(n+1e-9);
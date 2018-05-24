function DL=finitedifffast_xyt(L,dmask3)

%
% DL=finitedifffast_xyt(L,dmask3)
%
%   the result is as filter3(L,dmask3,'same')
%   with faster computations due to the sparsness
%   of derivative masks 'dmask3'
%


mc=round(size(dmask3)/2);
nonzeroelemind=find(dmask3(:)~=0);
[y,x,t]=ind2sub(size(dmask3),nonzeroelemind);

DL=zeros(size(L));
for i=1:length(nonzeroelemind)
  DL=DL+dmask3(nonzeroelemind(i))*shiftsub_xyt(L,-(x(i)-mc(2)),-(y(i)-mc(1)),-(t(i)-mc(3)),1);
end
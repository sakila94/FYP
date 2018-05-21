function f=syntseq01(sz)

%
% a corner moving up and down
%

img=256*ones(2*sz,sz);
for i=1:floor(sz/2)
  img(i,i:end-i)=0;
end

f=ones(sz,sz,sz);
ind=1+abs(-floor(sz/2):floor(sz/2));
for i=1:sz
  f(:,:,i)=img(ind(i):(ind(i)+sz-1),:);
end

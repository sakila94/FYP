function f=syntseq02(sz)

%
% two circles meet each other
%

[x,y]=meshgrid(1:2*sz,1:sz);
r=floor(sz/12);
img=256*(((y-floor(sz/2)).^2+(x-sz).^2)>(r^2));

f=256*ones(sz,sz,sz);
for i=1:sz
  f(:,:,i)=(img(:,sz+1-i:2*sz-i)&img(:,i:i+sz-1))*256;
end

function f=syntseq03(sz)

%
% a circle moving against the wall
%

[x,y]=meshgrid(1:2*sz,1:sz);
r=floor(sz/12);
img1=((y-floor(sz/2)).^2+(x-sz).^2)>(r^2);
img2=ones(sz,sz);
img2(:,floor(2*sz/3):sz)=0;

f=256*ones(sz,sz,sz);
for i=1:sz
  f(:,:,i)=(img1(:,sz+1-i:2*sz-i)&img2)*256;
end

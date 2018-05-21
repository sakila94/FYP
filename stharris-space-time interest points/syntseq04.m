function f=syntseq01(sz)

%
% spatio-temporal oscilations with increasing frequence
% both in spavce and time.
%

%[x,y]=meshgrid(linspace(0.5,1.25*pi,sz),linspace(0.5,1.25*pi,sz));
%img=sin(x.^2).*sin(y.^2);
%showgrey(img)

[x,y]=meshgrid(linspace(0.8,0.6*pi,sz),linspace(0.8,0.6*pi,sz));
img=sin(x.^4).*sin(y.^4);
%showgrey(img)

f=ones(sz,sz,sz);
for i=1:sz
  f(i,:,:)=256*(img>(-1.5+3*i/sz));
  %showgrey(squeeze(f(i,:,:)))
  %pause(0.1)
end

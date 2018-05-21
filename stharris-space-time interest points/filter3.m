function res=filter3(f,filt,shape)

if nargin<3
  shape='valid';
end

%filtrot=filt;
filtrot=filt(end:-1:1,end:-1:1,end:-1:1);
res=convn(f,filtrot,shape);

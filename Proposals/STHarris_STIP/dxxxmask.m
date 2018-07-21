function result=dxxxmask
%result=conv(dxmask,dxxmask)
%tmp=[0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0]
%tmp(2,:)=result;
%result=tmp;

result=conv2(dxmask,dxxmask,'same');
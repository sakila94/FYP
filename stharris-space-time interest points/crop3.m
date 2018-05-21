function result=crop3(data,ny,nx,nz)

[ysize,xsize,zsize]=size(data);
result=data(ny+1:ysize-ny,nx+1:xsize-nx,nz+1:zsize-nz);

function showisosurface(data, thresh)

[ysize,xsize,zsize]=size(data);

%clf
p1=patch(isosurface(data, thresh));
set(p1, 'FaceColor', 'red', 'EdgeColor', 'none');
p2=patch(isosurface(data,-thresh));
set(p2, 'FaceColor', 'green', 'EdgeColor', 'none');
axis([1 ysize 1 xsize 1 zsize])
daspect([1 1 1])
view(3)
camlight
lighting phong
xlabel('x')
ylabel('y')
zlabel('t')
grid

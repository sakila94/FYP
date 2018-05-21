function h=drawellipse(x,y,a,b,angle)


points=linspace(0,2*pi,20);   
T=[sin(angle) cos(angle); -cos(angle) sin(angle)];
ell=(T*[cos(points)'/a sin(points)'/b]')';
ell(:,1)=ell(:,1)+x;
ell(:,2)=ell(:,2)+y;

h=plot(ell(:,1),ell(:,2));

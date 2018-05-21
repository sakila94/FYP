function showcirclefeaturesframe_xyt(tmoment,features,fcol)

%
% M=showcirclefeaturesframe_xyt(tmoment,features,fcol)
%
%   displays spatio-temporal features=[x,y,t,sx,st] corresponding to
%   a moment 'tmoment' drawn by circles with colours fcol=[r,g,b];
%

hold on
for j=1:size(features,1)
  t=features(j,3);
  st2=features(j,5);
  if st2==0 st2=1; end
  t0=abs(tmoment-t);
  if t0<(sqrt(st2)*2)
    x=features(j,2);
    y=features(j,1);
    sx2=features(j,4);
    h=drawellipse(x,y,1/(sqrt(sx2)*2),1/(sqrt(sx2)*2),0);
    %ht=text(x,y,sprintf('%d',j));
    %set(ht,'Color',[1 0 0]);
    set(h,'LineWidth',4)
    if size(fcol,1)>1
      set(h,'Color',fcol(j,:))
    else
      set(h,'Color',fcol)
    end
  end
end
hold off

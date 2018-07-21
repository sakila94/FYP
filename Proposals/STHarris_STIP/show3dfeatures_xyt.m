function show3dfeatures_xyt(features,fcol)

col=fcol;
[xsph,ysph,zsph]=sphere(20);
for i=1:size(features,1)
  rxsph=2*sqrt(features(i,4));
  rtsph=2*sqrt(features(i,5));
  if size(features,2)>5
    vx=features(i,6);
    vy=features(i,7);
  else
    vx=0; vy=0;
  end
  
  if size(fcol)>1
    col=fcol(i,:);
  end
  surf(rtsph*xsph+features(i,3), ...
       rxsph*ysph+features(i,2)+vx*rtsph*xsph, ...
       rxsph*zsph+features(i,1)+vy*rtsph*xsph,...
       'EdgeColor', 'none', 'FaceColor', col);
end


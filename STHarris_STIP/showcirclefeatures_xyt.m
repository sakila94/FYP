function showcirclefeatures_xyt(f0,features,fcol,stepflag,i1,i2)

%
% M=showcirclefeatures_xyt(f0,features,fcol,stepflag,i1,i2)
%
%   displays image sequence f0 with spatio-temporal
%   features=[x,y,t,sx,st] drawn by circles with colours
%   fcol=[r,g,b];
%


if (ndims(f0)>2)

  if nargin<4 stepflag=0; end
  if nargin<6 i1=1; i2=size(f0,3); end

  for i=i1:i2
    i
    clf
    showgrey(f0(:,:,i));
    hold on
    showcirclefeaturesframe_xyt(i,features,fcol)
    title(sprintf('frame %d of %d',i,size(f0,3)))
    pause(0.01)
    if stepflag
      pause;
    end
  end
end

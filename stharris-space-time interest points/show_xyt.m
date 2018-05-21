function show_xyt(f0,step_flag)

if (ndims(f0)>2)
  clf
  maxv=max(f0(:));
  minv=min(f0(:));
  for i=1:size(f0,3)
    showgrey(f0(:,:,i),128,minv,maxv)
    title(sprintf('frame %d of %d',i,size(f0,3)))
    if (nargin>1)
      pause
    else
      pause(0.1)
    end
  end
end

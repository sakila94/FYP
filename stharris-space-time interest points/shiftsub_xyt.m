function result=shiftsub_xyt(seq,xshift,yshift,tshift,copyval)

result=seq;
[ysize,xsize,tsize]=size(seq);

if yshift>0
  result(min(ysize,1+round(yshift)):ysize,:,:)=seq(1:max(1,ysize-round(yshift)),:,:);
  for y=1:min(ysize,round(yshift))
    if copyval result(y,:,:)=seq(1,:,:);
    else result(y,:,:)=0;
    end
  end
elseif yshift<0
  result(1:max(1,ysize+round(yshift)),:,:)=seq(min(ysize,1-round(yshift)):ysize,:,:);
  for y=max(1,ysize+round(yshift)+1):ysize
    if copyval result(y,:,:)=seq(ysize,:,:);
    else result(y,:,:)=0;
    end
  end
end

seq=result;

if xshift>0
  result(:,min(xsize,1+round(xshift)):xsize,:)=seq(:,1:max(1,xsize-round(xshift)),:);
  for x=1:min(xsize,round(xshift))
    if copyval result(:,x,:)=seq(:,1,:);
    else result(:,x,:)=0;
    end
  end
elseif xshift<0
  result(:,1:max(1,xsize+round(xshift)),:)=seq(:,min(xsize,1-round(xshift)):xsize,:);
  for x=max(1,xsize+round(xshift)+1):xsize
    if copyval result(:,x,:)=seq(:,xsize,:);
    else result(:,x,:)=0;
    end
  end
end

seq=result;

if tshift>0
  result(:,:,min(tsize,1+round(tshift)):tsize)=seq(:,:,1:max(1,tsize-round(tshift)));
  for t=1:min(tsize,round(tshift))
    if copyval result(:,:,t)=seq(:,:,1);
    else result(:,:,t)=0;
    end
  end
elseif tshift<0
  result(:,:,1:max(1,tsize+round(tshift)))=seq(:,:,min(tsize,1-round(tshift)):tsize);
  for t=max(1,tsize+round(tshift)+1):tsize
    if copyval result(:,:,t)=seq(:,:,tsize);
    else result(:,:,t)=0;
    end
  end
end

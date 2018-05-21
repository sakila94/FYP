
%
% scale selection for interest points in space-time
%


if 0 % initialisation

  f0=read_image_sequence('d:\video\sequences\gait09','avi',1,75);
  tind=[1 1 1]'*(1:50); tind=tind(:)';
  f1=f0(end-75+1:end,41:115,35+tind);
  %f1=f1(end-32+1-10:end-10,25:56,6:37);
  %f1=f1(end-32+1-20:end,15:66,16:67);
  clear f0;

  %f1=syntseq01(64);
  %f1=syntseq02(64);
  %f1=syntseq03(64);
  %f1=syntseqgauss01(32,8,2);

  nptsmax=20;
  sx2arr=[4 8];
  st2arr=[2 4];
  
end

if 1 % detect harris points at given scales
  hvalinit=[];
  hposinit=[];
  for i=1:length(sx2arr)
    for j=1:length(st2arr)
      sxl2=sx2arr(i); sxi2=2*sxl2;
      stl2=st2arr(j); sti2=2*stl2;
      [sxl2 stl2]
      [pos,val,cimg,L]=harris_xyt(f1,0.001,sxl2,stl2,sxi2,sti2);
      [sval, sposind]=sort(-val);
      npts=min(nptsmax,size(pos,1));
      hposinit=[hposinit; pos(sposind(1:npts),:) sxl2*ones(npts,1) stl2*ones(npts,1)];
      hvalinit=[hvalinit; -sval(1:npts)];
    end
  end
  
  % display all detected points
  figure(1), clf
  Ldisp=sepgaussconv_xyt(f1,sx2arr(1),st2arr(1));
  thresh=max(Ldisp(:))/2;
  subplot(2,1,1), showisosurface(shiftdim(Ldisp(:,:,:),1),thresh), hold on
  subplot(2,1,2), showisosurface(shiftdim(Ldisp(:,:,:),1),thresh), hold on

  subplot(2,1,1)
  [xsph,ysph,zsph]=sphere(20);
  for i=1:size(hposinit,1)
    rxsph=2*sqrt(hposinit(i,4));
    rtsph=2*sqrt(hposinit(i,5));
    surf(rtsph*xsph+hposinit(i,3),rxsph*ysph+hposinit(i,2),rxsph*zsph+hposinit(i,1),...
	 'EdgeColor', 'none', 'FaceColor', 'blue');
  end
  pause(0.1)

  Mharrisorig=showfeatures_xyt(f1,hposinit,0);
end



if 1 % adapt harris points to scale
  
  posall={};
  valall={};
  posevolall={};

  for i=1:size(hposinit,1)
    %figure(2)
    disp(sprintf('point %d of %d',i,size(hposinit,1)))
    [pos, posevol, val]=adaptharris_xyt(f1,hposinit(i,:),0.25,0.25,20);
    posall{i}=pos;
    valall{i}=val;
    posevolall{i}=posevol;
    
    if size(pos)>0
      rxsph=2*sqrt(pos(1,4));
      rtsph=2*sqrt(pos(1,5));
      figure(1), hold on,subplot(2,1,2)
      surf(rtsph*xsph+pos(1,3),rxsph*ysph+pos(1,2),rxsph*zsph+pos(1,1),...
	   'EdgeColor', 'none', 'FaceColor', 'blue');
    end
  end
  %print('-depsc',sprintf('/disk2/laptev3/spattemp/dat/results/harris/harris_xyt_gait_adapt01a.ps'))

  posallarray=[];
  valallarray=[];
  for i=1:length(posall)
    if length(posall{i})>0
      posallarray=[posallarray; posall{i}];
      valallarray=[valallarray; valall{i}];
    end
  end

  if 1 % display adapted features
    figure(1)
    subplot(2,1,2)
    [xsph,ysph,zsph]=sphere(20);
    for i=1:size(posallarray,1)
      rxsph=2*sqrt(posallarray(i,4));
      rtsph=2*sqrt(posallarray(i,5));
      surf(rtsph*xsph+posallarray(i,3),rxsph*ysph+posallarray(i,2),rxsph*zsph+posallarray(i,1),...
	   'EdgeColor', 'none', 'FaceColor', 'blue');
    end
    pause(0.1)
  end

  Mharrisadapt=showfeatures_xyt(f1,posallarray);
end



if 1 % make a movie with Harris s-t points
  %movie2avi(Mharrisorig,'/home/laptev/harrismovie1.avi');
  %movie2avi(Mharrisadapt,'/home/laptev/harrismovie2.avi');
  %movie(Mharrisorig)
  %movie(Mharrisadapt)
end

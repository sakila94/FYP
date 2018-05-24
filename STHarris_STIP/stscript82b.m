
%
% scale selection for interest points in space-time
%




if 1 % adapt harris points to scale
  
  posall={};
  valall={};
  posevolall={};

  for i=1:size(hposinit,1)
    %figure(2)
    disp(sprintf('point %d of %d',i,size(hposinit,1)))
    %[pos, posevol, val]=adaptharris_xyt(f1,hposinit(i,:),0.25,0.25,20,kparam);
    %[pos, posevol, val]=adaptharris_xyt(f1,hposinit(i,:),0.25,0.25,20);
    %[pos, posevol, val]=adaptharris2_xyt(f1,hposinit(i,:),0.15,0.15,30,[1 1 1],64,64);
    %[pos, posevol, val]=adaptharris2_xyt(f1,hposinit(i,:),0.25,0.25,20,[1 1 1],64,64);
    [pos, posevol, val]=adaptharris2_xyt(f1,hposinit(i,:),0.25,0.25,20,[1 0 1],64,64);
    %[pos, posevol, val]=adaptharris_xyt_bak2(f1,hposinit(i,:),0.25,0.25,20);
    posall{i}=pos;
    valall{i}=val;
    posevolall{i}=posevol;
   
    if 0 % display
      if size(pos)>0
        rxsph=2*sqrt(pos(1,4));
        rtsph=2*sqrt(pos(1,5));
        figure(1), hold on,subplot(2,1,2)
        surf(rtsph*xsph+pos(1,3),rxsph*ysph+pos(1,2),rxsph*zsph+pos(1,1),...
            'EdgeColor', 'none', 'FaceColor', 'blue');
      end
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

  if 0 % display adapted features
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

  %Mharrisadapt=showfeatures_xyt(f1,posallarray);
end



if 1 % make a movie with Harris s-t points
  %movie2avi(Mharrisorig,'/home/laptev/harrismovie1.avi');
  %movie2avi(Mharrisadapt,'/home/laptev/harrismovie2.avi');
  %movie(Mharrisorig)
  %movie(Mharrisadapt)
end

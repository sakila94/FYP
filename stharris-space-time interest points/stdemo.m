
%
% detect and adapt space-time interest points as well
% as compute their descriptors.
% (edit this script and change the variable datapath
%  to an appropriate path containing avi-video sources)
%

datapath='C:\Users\Administrator\Desktop\stharris-space-time interest points\stharris-space-time interest points\';

if 1 % initialize
  % read source video
  f1=read_image_sequence(sprintf('%s/walk',datapath),'avi',1,50);
  %tind=[1 1 1]'*(1:25); tind=tind(:)';
  %f1=f1(end-75+1:end,41:115,35+tind);

  % generate synthetic sequences
  %f1=syntseq01(64); % sxl2=8; stl2=8;
  %f1=syntseq02(64); % sxl2=8; stl2=10;
  %f1=syntseq03(64);
  %f1=syntseq04(64);
  %vx=-0.8; vy=0.0;
  %f1=warpvelfloat_xyt(f1,vx,vy,32);
  
  % play the sequence
  show_xyt(f1);
  fprintf('press a key...\n'), pause
end

if 1 % compute harris points
  % define spatial and temporal scales
  sxl2=4; sxi2=2*sxl2;
  stl2=2; sti2=2*stl2;

  % detect all points
  fprintf('detecting interest points...\n')  
  [pos,val,cimg,L]=harris_xyt(f1,0.001 ,sxl2,stl2,sxi2,sti2);

  % sort the points and select the strongest ones
  [sval, sposind]=sort(-val);
  hthresh=max(val(:))/10;
  npts=min(size(pos,1),25);
  possel=pos(sposind(1:npts),:);
  
  % display detected points
  showcirclefeatures_xyt(f1,possel(:,1:5),[1 1 0]);
  fprintf('press a key...\n'), pause
end


if 1 % adapt interest points to the scales and velocity
  fprintf('adapting interest points...\n')  
  posadaptall=[];
  valadaptall=[];
  for i=1:size(possel,1)
    posinit=possel(i,:);
    disp(sprintf('point %d of %d',i,size(possel,1)))
    [pos, posevol, val]=adaptharris2_xyt(f1,posinit,0.25,0.25,20,[1 1 1],64,64);
    if size(pos,1)>0
      posadaptall=[posadaptall; pos];
      valadaptall=[valadaptall; val];
    end
  end

  showcirclefeatures_xyt(f1,posadaptall(:,1:5),[1 1 0]);
  fprintf('press a key...\n'), pause
end

if 1 % compute jet-responses (can be computed for adapted/non-adapted points)
  fprintf('computing local jet responses...\n')  

  %features=possel(:,1:7);
  features=posadaptall(:,1:7);
  features(:,4)=2*features(:,4);
  features(:,5)=2*features(:,5);
  harrisjets=localjet_xyt(f1,features);
end

if 1 % show results as 3D-plots
  fprintf('\ndisplaying adapted interest points in a 3D plot...\n') 
  [ysz,xsz,tsz]=size(f1);
  %dL=sepgaussconvfast_xyt(f1,4,4);
  dL=L;

  clf
  thresh=max(dL(:))/2;
  showisosurface(shiftdim(dL(:,:,:),1),thresh)
  xlabel('time','FontSize',18); ylabel('x','FontSize',18); zlabel('y','FontSize',18);
  axis([1 tsz 50 130 40 ysz])
  camlight right
  camlight left

  hold on 
  show3dfeatures_xyt(posadaptall,[0 0 1])
  view(72,76)
end




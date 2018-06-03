function [pos, posevol, val] = adaptharris2_xyt(f,posinit,sxstep,ststep,maxiter,adaptflag,sxmax,stmax)

%
% [pos, posevol, val]=adaptharris2_xyt(f,posinit,sxstep,ststep,maxiter,adaptflag,sxmax,stmax)
%
%   given an initial point parameters (y,x,t,sx2,st2,vx,vy) in spatio-temporal
%   scale-space, iteratively searches for point in f in the neighbourhood
%   of the initial point that is i) max of a Harris function over (x,y,t)
%   ii) extrema of a normalised Laplace operator over scales (sx2,st2)
%   and computed in the velocity-adapted neighbourhood.
%   The result is reported in pos. The trajectory from posinit
%   to pos is returned in posevol. pos is an empty vector if
%   convergency could not be reached.
%   Optional input parameters sxstep, ststep (=0.25 default) set the
%   scale increment between iteration steps. maxiter (=20 default)
%   gives the max number of iterations.
%   adaptflag = [a1 a2 a3]: a1~=0 => scale adaption
%                           a2~=0 => velocity adaption
%                           a3~=0 => x-y-t position adaption
%               []: (default) adapt over all parameters
%

if size(posinit,1)>1
  posinit=transpose(posinit);
end

valsel = 0;
possel = posinit;
posprev = possel;
posevol(1,:) = posinit;

% default values
if nargin<3 
    sxstep=0.25; 
end
if nargin<4 
    ststep=0.25; 
end
if nargin<5 
    maxiter=20; 
end
if nargin<7 
    sxmax=100; 
end
if nargin<8 
    stmax=100; 
end
if nargin<6 
    adaptflag=[1 1 1]; 
end
if size(adaptflag)==0 
    adaptflag=[1 1 1]; 
end

scalesteporig = 1*sqrt(sxstep^2+ststep^2);
%scalesteporig = sqrt(2)*sqrt(sxstep^2+ststep^2);
scalestep = scalesteporig;

iter=0;
velconvflag=0;
loopconvflag=0;
scaleconvflag=0;
divergenceflag=0;
[ysize,xsize,tsize]=size(f);
%while ((iter==0)|( ((posprev-possel)*transpose(posprev-possel))>0 )) & ...
%      ((~adaptflag(1) | ~(adaptflag(1)&scaleconvflag)) &...
%       (~adaptflag(2) | ~(adaptflag(2)&velconvflag))) &...
%      ~loopconvflag & ~divergenceflag & ...
%      (iter<maxiter)

while ~((  (~(iter==0) | (((posprev(1:3)-possel(1:3))*transpose(posprev(1:3)-possel(1:3)))==0))...
         & ~xor(adaptflag(1), scaleconvflag)...
         & ~xor(adaptflag(2), velconvflag))...
        | loopconvflag ...
        | divergenceflag ...
        | (iter>=maxiter))

  iter=iter+1;
  
  % cut out a part of f
  px=possel(1,2);
  py=possel(1,1);
  pt=possel(1,3);
  sxl2=possel(1,4);
  stl2=possel(1,5);
  vx=possel(1,6);
  vy=possel(1,7);

  % increase the spatial extent of a window according to the velocity 
  if adaptflag(2) 
      xszf = 1 + max(abs(vx),abs(vy)); 
  else
      xszf = 1;
  end
  %xszf=1;
  
  brx = max(5,round(xszf*4*sqrt(sxl2)));
  brt = max(5,round(4*sqrt(stl2)));

  fcut=f(max(1,py-brx):min(ysize,py+brx),...
	 max(1,px-brx):min(xsize,px+brx),...
	 max(1,pt-brt):min(tsize,pt+brt));
  cy=min(brx+1,py);
  cx=min(brx+1,px);
  ct=min(brt+1,pt);
  
  if adaptflag(2) % if adapting velocity
    fcut=warpvelfloat_xyt(fcut,-vx,-vy,ct);
    brx=max(5,round(4*sqrt(sxl2)));
    fcut=fcut(max(1,cy-brx):min(size(fcut,1),cy+brx),...
	      max(1,cx-brx):min(size(fcut,2),cx+brx),:);
    cy=min(brx+1,cy);
    cx=min(brx+1,cx);
  end
  
  st=2*stl2;
  sx=2*sxl2;
     
  msz=(size(dxmask3,1)-1)/2;
  L=sepgaussconvfast_xyt(fcut,sx,st);
  Lext=extend3(L,msz,msz,msz);
  Lcut=Lext(cy:cy+2*msz,cx:cx+2*msz,ct:ct+2*msz);
 
  % adapt scales
  if adaptflag(1)
    %Lxxval=filter3(Lcut,dxxmask3,'valid');  
    %Lyyval=filter3(Lcut,dyymask3,'valid');
    %Lttval=filter3(Lcut,dttmask3,'valid');
    %Lxxxxval=filter3(Lcut,dxxxxmask3,'valid');
    %Lxxyyval=filter3(Lcut,dxxyymask3,'valid');
    %Lyyyyval=filter3(Lcut,dyyyymask3,'valid');
    %Lxxttval=filter3(Lcut,dxxttmask3,'valid');
    %Lyyttval=filter3(Lcut,dyyttmask3,'valid');
    %Lttttval=filter3(Lcut,dttttmask3,'valid');
  
    prodmsize=prod(size(dxmask3));
    Lxxval=sum(Lcut(:).*reshape(dxxmask3,[prodmsize,1]));
    Lyyval=sum(Lcut(:).*reshape(dyymask3,[prodmsize,1]));
    Lttval=sum(Lcut(:).*reshape(dttmask3,[prodmsize,1]));
    Lxxxxval=sum(Lcut(:).*reshape(dxxxxmask3,[prodmsize,1]));
    Lxxyyval=sum(Lcut(:).*reshape(dxxyymask3,[prodmsize,1]));
    Lyyyyval=sum(Lcut(:).*reshape(dyyyymask3,[prodmsize,1]));
    Lxxttval=sum(Lcut(:).*reshape(dxxttmask3,[prodmsize,1]));
    Lyyttval=sum(Lcut(:).*reshape(dyyttmask3,[prodmsize,1]));
    Lttttval=sum(Lcut(:).*reshape(dttttmask3,[prodmsize,1]));
  
    % normalized Laplacian and its derivatives w.r.t. scales
    nfx=(sx^(3/4))*(st^(1/4));
    nfxx=sx*(st^(1/4));
    nftt=(st^(3/4))*(sx^(2/4));
    
    lapval=Lxxval*nfxx + Lyyval*nfxx + Lttval*nftt;
    
    lapsxval=st^(1/4)*(Lxxval+Lyyval)+...
	     sx*st^(1/4)*(Lxxxxval+Lyyyyval+2*Lxxyyval)/2+...
	     (1/2)*sx^(-1/2)*st^(3/4)*Lttval+...
	     sx^(1/2)*st^(3/4)*(Lxxttval+Lyyttval)/2;
    
    lapstval=(1/4)*st^(-3/4)*sx*(Lxxval+Lyyval)+...
	     sx*st^(1/4)*(Lxxttval+Lyyttval)/2+...
	     (3/4)*st^(-1/4)*sx^(1/2)*Lttval+...
	     sx^(1/2)*st^(3/4)*Lttttval/2;
    
    v=[lapsxval lapstval]*sign(lapval)/sqrt(lapsxval^2+lapstval^2);

    % check if the new scale is better otherwise reduce the step
    sxl2new=sxl2*2^(scalestep*v(1)); sxi2new=2*sxl2;
    stl2new=stl2*2^(scalestep*v(2)); sti2new=2*stl2;
    st=2*stl2new;
    sx=2*sxl2new;
    L=sepgaussconvfast_xyt(fcut,sx,st);
    Lext=extend3(L,msz,msz,msz);
    Lcut=Lext(cy:cy+2*msz,cx:cx+2*msz,ct:ct+2*msz);
    Lxxval=filter3(Lcut,dxxmask3,'valid');
    Lyyval=filter3(Lcut,dyymask3,'valid');
    Lttval=filter3(Lcut,dttmask3,'valid');
    nfx=(sx^(3/4))*(st^(1/4));
    nfxx=sx*(st^(1/4));
    nftt=(st^(3/4))*(sx^(2/4));
    lapvalnew=Lxxval*nfxx + Lyyval*nfxx + Lttval*nftt;
    if (lapval^2)>(lapvalnew^2)
      scaleconvflag=1;
    else
      % update scales
      sxl2=sxl2*2^(scalestep*v(1));
      stl2=stl2*2^(scalestep*v(2));
      scaleconvflag=0;
      %disp(sprintf('     update scales, no scale converegnce yet'))
    end
  else
    lapval=0;
  end
  
  if sx>sxmax | st>stmax
    divergenceflag=1;
  end
  
  if ~(scaleconvflag & velconvflag)
    
    % re-detect harris points
    kparam=0.001;
    sxi2=2*sxl2; sti2=2*stl2;
    [pos,val,cimg,L]=harris_xyt(fcut,kparam,sxl2,stl2,sxi2,sti2);

    % update position vector
    if size(pos,1)>0 % if any harris point is found
      
      % update posiotion according to the velocity warp
      if adaptflag(2)
	%[(ct-pos(:,3))*vy (ct-pos(:,3))*vx]
	pos(:,1:2)=pos(:,1:2)+round([(ct-pos(:,3))*vy (ct-pos(:,3))*vx]);
	%pos(:,1:2)
      end
      
      % convert positions to f-coordinates
      pos(:,1:3)=pos(:,1:3)+(ones(size(pos,1),1)*[max(0,py-brx-1) max(0,px-brx-1) max(0,pt-brt-1)]);

      % update velocity
      if adaptflag(2)
	pos(:,6)=0.9*pos(:,6)+vx;
	pos(:,7)=0.9*pos(:,7)+vy;
      end
      
      % select the closest point
      dvec=pos(:,1:3)-(ones(size(pos,1),1)*posinit(1:3));
      [dmin, dminind]=min(sum(dvec.*dvec,2));
      
      posprev=possel;
      possel=[pos(dminind,:)];
      valsel=[val(dminind,:)];
      posevol(iter+1,:)=possel;
       
      if adaptflag(2)
	dvxmax=0.01; dvymax=0.01;
	if abs(posprev(6)-possel(6))<dvxmax & abs(posprev(7)-possel(7))<dvymax
	  velconvflag=1;
	else
	  velconvflag=0;
	end
      end
      
    else % if no harris point is found
	divergenceflag=1;
    end
  end
  
  if possel(2)<1 | possel(1)<1 | possel(2)>xsize | possel(1)>ysize | iter>=maxiter
    divergenceflag=1;
  end
  
  disp(sprintf('   iter: %d, x=%d, y=%d, t=%d, sx=%1.5f, st=%1.5f, vx=%1.2f, vy=%1.2f, Lapval=%2.1f',...
	       iter,possel(2),possel(1),possel(3),2*sxl2,2*stl2,possel(6),possel(7),lapval))

  %disp([((iter==0)|( ((posprev-possel)*transpose(posprev-possel))>0 )) ...
  %(~adaptflag(1) | ~(adaptflag(1)&scaleconvflag)) ...
  %(~adaptflag(2) | ~(adaptflag(2)&velconvflag)) ...
  %~loopconvflag ...
  %(iter<maxiter)])
end
  

pos=[];
val=[];

% in case of convergence
%if ((posprev-possel)*(posprev-possel)')==0 | loopconvflag | ...
%   (scaleconvflag & adaptflag(1)) | (velconvflag & adaptflag(2))

if ~divergenceflag
  pos=possel;
  val=valsel;
  if loopconvflag
    disp('Loop-convergence')
  end
  if adaptflag(1)&scaleconvflag
    disp('Scale convergence')
  end
  if adaptflag(2)&velconvflag
    disp('Velocity convergence')
  end
else
  disp('Divergence')
end



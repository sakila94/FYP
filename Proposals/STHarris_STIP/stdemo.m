% ------------------------------------------------------------ %
% @func - NEED TO DEFINE
% @info - detect and adapt space-time interest points as well
%         as compute their descriptors.
% @var - NEED TO DEFINE
% @output - NEED TO DEFINE
% ------------------------------------------------------------ %
datapath=pwd;

% ------------------------------------------------------------ %
% Get the Video Frames and Show
% ------------------------------------------------------------ %
if 1
    % Get frames of the video
    f1 = frameAVideo(sprintf('%s/v_ApplyEyeMakeup_g01_c01',datapath),'avi');
    %tind=[1 1 1]'*(1:25); tind=tind(:)';
    %f1=f1(end-75+1:end,41:115,35+tind);

    % Generate synthetic sequences
    %f1=syntseq01(64); % sxl2=8; stl2=8;
    %f1=syntseq02(64); % sxl2=8; stl2=10;
    %f1=syntseq03(64);
    %f1=syntseq04(64);
    %vx=-0.8; vy=0.0;
    %f1=warpvelfloat_xyt(f1,vx,vy,32);
  
    % Play the sequence
    show_xyt(f1);
    fprintf('press a key...\n'), pause
end

% ------------------------------------------------------------ %
% Compute Harris Points
% ------------------------------------------------------------ %
if 1
    % ----------------------------------------- %
    % Define Spatial and Temporal scales
    % @brief - Read the Section 2.1 and 2.2 in On Space-Time
    %          Interest Points
    S = 2;
    sxl2 = 4; % Image Smoothing variance
    sxi2 = S*sxl2; % Smooth the Second Moment Matrix 
    stl2 = 2; % Video Smoothing variance in time
    sti2 = S*stl2; % Smooth the Second Moment Matrix
    % ----------------------------------------- %

    % Detect all points
    fprintf('Detecting interest points...\n')  
    [pos,val,cimg,L] = harris_xyt(f1,0.01,sxl2,stl2,sxi2,sti2);

    % Sort the points and select the strongest ones
    [sval, sposind] = sort(-val);
    hthresh = max(val(:))/10;
    npts = min(size(pos,1),40); % Number of points
    possel = pos(sposind(1:npts),:); % This is the matrix(npts x 13(default))

    % Display detected points
    showcirclefeatures_xyt(f1,possel(:,1:5),[1 1 0]);
    fprintf('press a key...\n'), pause
end

% ------------------------------------------------------------ %
% Adapt interest points to the scales and velocity
% ------------------------------------------------------------ %
if 1 
    fprintf('Adapting interest points...\n')  
    posadaptall = [];
    valadaptall = [];
    for i = 1:size(possel,1)
        posinit = possel(i,:); % Every detected Interest Points 
        fprintf('point %d of %d\n',i,size(possel,1))
        [pos, posevol, val] = adaptharris2_xyt(f1,posinit,0.25,0.25,...
                                               20,[1 1 1],64,64);
        if size(pos,1) > 0
            posadaptall = [posadaptall; pos];
            valadaptall = [valadaptall; val];
        end
    end

    showcirclefeatures_xyt(f1,posadaptall(:,1:5),[1 1 0]);
    fprintf('press a key...\n'), pause
end

% ------------------------------------------------------------ %
% Compute jet-responses 
% @brief - Can be computed for adapted/non-adapted points
% ------------------------------------------------------------ %
if 1 
    fprintf('computing local jet responses...\n')  

    %features = possel(:,1:7);
    features = posadaptall(:,1:7);
    features(:,4) = 2*features(:,4);
    features(:,5) = 2*features(:,5);
    harrisjets = localjet_xyt(f1,features);
end

% ------------------------------------------------------------ %
% Show results as 3D-plots
% ------------------------------------------------------------ %
if 1 
    fprintf('\ndisplaying adapted interest points in a 3D plot...\n') 
    [ysz,xsz,tsz] = size(f1);
    %dL=sepgaussconvfast_xyt(f1,4,4);
    dL = L;

    clf
    thresh = max(dL(:))/2;
    showisosurface(shiftdim(dL(:,:,:),1),thresh)
    xlabel('time','FontSize',18); ylabel('x','FontSize',18); zlabel('y','FontSize',18);
    axis([1 tsz 50 130 40 ysz])
    camlight right
    camlight left

    hold on 
    show3dfeatures_xyt(posadaptall,[0 0 1])
    view(72,76)
end




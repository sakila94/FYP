%% Function: extract DSTIP described in CVPR13 Lu Xia and J.K. Aggarwal
%% Code by Lu Xia
%% input:
% 1.inputFile: the path+name of the input depth video, MSR '.bin' format
% 2.outputFile: the path+name of the output result file. '.txt' format
% parameters:
% nPoints --No of Points to extract per video
% HSIZE-- window size of Gaussian filter
% SIGMA --  spatio scale, Gauss variance
% TAO -- temproal scale of Gabor filter, (should be smaller than video
% duration/2)
% boarder -- leave enough space to extract a cuboid around the DSTIPs
% noise suppressor --  set to 0 when there is no backgroud for faster process.
% noise_thresh -- larger value removes more noise (too large value may hurt fast movement)
% display -- 1: display the result, 0: no display

% call by matlab: e.g. ExtractDSTIP('C:\data\MSRDailyActivity3D\MSRDailyAct3D\a01_s01_e01_depth.bin','try.txt');

function []=ExtractDSTIP(inputFile,outputFile,varargin)
display('input File:')
inputFile
display('output File:')
outputFile
%% check for optional inputs
 % Get the properties in either direct or P-V format
[parent, pvPairs] = parseparams(varargin);

% Now process the optional P-V params
try
    % Initialize with default values
    paramName = [];
    paramsStruct.nPoints=350;
    paramsStruct.HSIZE=5;%Gaussian lowpass filter  of size HSIZE with standard deviation SIGMA (positive). 
    paramsStruct.SIGMA=1;%% spatio scale, Gauss variance
    paramsStruct.TAO=10; %[20; 30; 40]; %%temproal scale of Gabor filter
    paramsStruct.boarder=15;  %% leave enough space to extract a cuboid around the DSTIPs
    paramsStruct.noiseSuppressor=1; %%if apply the noise suppressor: set to 0 when there is no backgroud for faster process.
    paramsStruct.noise_thresh=4;  %% larger value removes more noise (too large value may hurt fast movement)
    paramsStruct.display=1;
    % other default params can be specified here

    supportedArgs = {'nPoints','HSIZE','SIGMA','TAO',...
                     'boarder','noiseSuppressor','noise_thresh','display'};

    while ~isempty(pvPairs)

        % Ensure basic format is valid
        paramName = '';
        if ~ischar(pvPairs{1})
            error('invalidProperty','Invalid property');
        elseif length(pvPairs) == 1
            error('noPropertyValue',['No value specified for property ''' pvPairs{1} '''']);
        end

        % Process parameter values
        paramName  = pvPairs{1};
        paramValue = pvPairs{2};
        if(ischar(paramValue)) %convert the input "char" into "double"
            paramValue = str2double(paramValue); 
        end;
        %paramsStruct.(lower(paramName)) = paramValue;  % good on Matlab7, no good on Matlab6...
        paramsStruct = setfield(paramsStruct, paramName, paramValue);  %#ok Matlab6
        pvPairs(1:2) = [];
        if ~any(strcmpi(paramName,supportedArgs))
            url = ['matlab:help ' mfilename];
            urlStr = getHtmlText(['' strrep(url,'matlab:','') '']);
            error('invalidProperty',...
             ['Unsupported property - type "' urlStr ...
              '" for a list of supported properties']);
        end
    end  % loop pvPairs

catch
    if ~isempty(paramName)
        paramName = [' ''' paramName ''''];
    end
    error('invalidProperty',['Error setting uisplitpane property' paramName ':' char(10) lasterr]);
end
paramsStruct
if paramsStruct.display==0, set(0,'DefaultFigureVisible', 'off');
    else set(0,'DefaultFigureVisible', 'on');
end;
%% read depth video
fid=fopen(inputFile);
Duration=fread(fid,1,'int');
if(Duration<2*paramsStruct.TAO+1)
    error('TAO is too large');
end;
ncols=fread(fid,1,'int');
nrows=fread(fid,1,'int');
depthImg=zeros(nrows,ncols);
Volum=zeros(nrows,ncols,Duration);
for frameNumber=1:Duration
    for i=1:nrows
        depthImg(i,:)= fread(fid,ncols,'int32');
        ID=fread(fid,ncols,'int8');
    end;
    Volum(:,:,frameNumber)=depthImg;
end;
fclose(fid);
figure,imagesc(depthImg), hold on,
clear depthImg;
%% cut boarder
Volum(1:paramsStruct.boarder,:,:)=0;
Volum(nrows-paramsStruct.boarder:nrows,:,:)=0;
Volum(:,1:paramsStruct.boarder,:)=0;
Volum(:,ncols-paramsStruct.boarder:ncols,:)=0;
Volum_ori=Volum;
tic
%% build filter
% TAO=[round((Duration-1)./paramsStruct.TAODIV)];
TAO=paramsStruct.TAO;
filtered=zeros(nrows,ncols,Duration,length(paramsStruct.SIGMA),length(TAO),'single');
for i=1:length(paramsStruct.SIGMA)
    sigma=paramsStruct.SIGMA(i);
    h=fspecial('gaussian',[paramsStruct.HSIZE,paramsStruct.HSIZE],sigma);
    % step 1: apply gassian filter along(x,y): I*g
    for k=1:size(Volum,3)
        Volum(:,:,k)=conv2(Volum(:,:,k),h,'same');
%         Volum(:,:,k)=medfilt2(Volum(:,:,k),[SIGMA SIGMA]);
    end;
    Rev=[];Rod=[];
    for j=1:length(TAO)
        tao=TAO(j);
        hev=zeros(1,2*tao+1);
        hod=zeros(1,2*tao+1);
        w=0.6/tao;
        t=[-tao:tao];
        hev(tao+t+1)=-cos(2*pi*t*w).*exp(-t.^2/tao^2);
        hod(tao+t+1)=-sin(2*pi*t*w).*exp(-t.^2/tao^2);
        hev=hev-mean(hev);
        hod=hod-mean(hev);

        % step 2: apply gabor filter along t
        Rev=convn(Volum,shiftdim(hev,-1),'same');
        Rod=convn(Volum,shiftdim(hod,-1),'same');
        filtered(:,:,:,i,j)=Rev+Rod;
        clear Rev;
        clear Rod;
    end;
end;
% figure,surf(double(filtered(:,:,60,1,1)))
% figure,imagesc(filtered(:,:,60,1,1))
% figure,imagesc(filtered(:,:,10,1,2))
% figure,imagesc(filtered(:,:,10,1,3))
% figure, surf(abs(filtered(:,:,10,1,1)));
% figure, surf(abs(filtered(:,:,10,1,3)));

%% Noise suppressor: calculate the zero-crossing of every pixel of the scene, to reduce the noise from the depthing sensing: 
if (paramsStruct.noiseSuppressor==1)
    % %%***************** option1: use the whole video: much faster
    Volum_zc=zeros(nrows,ncols);
    for i=1:nrows
        for j=1:ncols
            signal=Volum_ori(i,j,:);
            signal=signal(:);
            signal=signal-mean(signal);
            [n,ad]=zc(signal);
            Volum_zc(i,j)=ad;
        end;
    end;
    Volum_zc(Volum_zc<paramsStruct.noise_thresh)=0;%paramsStruct.noise_thresh;
    % apply the noise suppressor
    filtered=filtered.*repmat(Volum_zc,[1 1 Duration length(paramsStruct.SIGMA) length(TAO)]);
    % %%*********** option2: use short segments.
    % Volum_zc=zeros(nrows,ncols,Duration);
    % for i=1:nrows
    %     for j=1:ncols
    %         for t=tao+1:Duration-tao-1
    %             signal=Volum_ori(i,j,t-tao:t+tao);
    %             signal=signal(:);
    %             signal=signal-mean(signal);
    %             [n,ad]=zc(signal);
    %             Volum_zc(i,j,t)=ad;
    %         end;
    %     end;
    % end;
    % Volum_zc(Volum_zc>paramsStruct.noise_thresh)=0;
    % % apply the noise suppressor
    % filtered=filtered.*repmat(Volum_zc,[1 1 1 length(paramsStruct.SIGMA) length(TAO)]);
end;

%% extract local maximum of filtered result
% only from the valid values.
V=filtered;
for i=1:length(paramsStruct.SIGMA)
    for j=1:length(TAO)
        % smooth the data
        V(:,:,:,i,j)=abs(smooth3(V(:,:,:,i,j),'gaussian',[7 7 3],1));
%                 figure,surf(double(V(:,:,35)));
%           wipe off the invalid values
        tao=TAO(j);
        V(:,:,1:tao,i,j)=0;
        V(:,:,end-tao:end,i,j)=0;
    end;
end;
% find local maximum
M=imregionalmax(V);
% take the largest nPoints
S=sort(V(M));
if length(S) > paramsStruct.nPoints
    thresh=S(end-paramsStruct.nPoints+1);
    M(V<thresh)=0;
end
clear V;
% figure, imagesc(M(:,:,35));

LinearIndex=find(M==1);
[I1,I2,I3,I4,I5]=ind2sub(size(M),LinearIndex);
plot(I2,I1,'r*');  %plot(I2,nrows-I1,'*');
axis([0 ncols 0 nrows]);
clear LinearIndex;
clear M;
%% write the locations to .txt files
fid = fopen(outputFile,'w');
fprintf(fid,'%d  %d  %d  %d  %d\n',[I1';I2';I3';paramsStruct.SIGMA(I4)';TAO(I5)']);
fclose(fid);

toc


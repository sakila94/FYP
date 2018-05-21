
%% Function: Extract CDSF descriptor described in CVPR13 Lu Xia and J.K. Aggarwal
%% Code by Lu Xia
%% input:
% 1. depthFile:  the path+name of the input depth video, MSR '.bin' format
% 2. DSTIPFile: the path+name of the input DSTIP location file. '.txt' format
% 3. outputFile: the path+name of the output file. '.txt' format
% optional parameters:
% LengthXY -- the size of the cuboid on x,y,dimension = 2*LengthXY*sigma;
% LengthT-- the size of the cuboid on t dimension = 2*LengthT*tao;
% DepthMin -- the cutoff value for the minimum depth (Kinect depth has closest distance limit)
% NoCellX -- divide the cuboid into 2*NoCellX blocks in x dimension 
% NoCellY -- divide the cuboid into 2*NoCellY blocks in y dimension 
% NoCellT -- divide the cuboid into 2*NoCellT blocks in t dimension
% NoBin -- the number of bins of the depth histogram  (denote by M in the paper)


% call by matlab: ExtractDCSF('C:\data\MSRDailyActivity3D\MSRDailyAct3D\a01_s01_e01_depth.bin','..\DSTIP_result\a01_s01_e01_depth.txt','..\DCSF_result\DCSF.txt','DepthMin',70);
function []=ExtractDCSF(depthFile,DSTIPFile,outputFile,varargin)
tic
display('depth File:')
depthFile
display('DSTIP file:')
DSTIPFile
display('output File:')
outputFile
%% check for optional inputs
 % Get the properties in either direct or P-V format
[parent, pvPairs] = parseparams(varargin);

% Now process the optional P-V params
try
    % Initialize with default values
    paramName = [];
    paramsStruct.LengthXY=15;
    paramsStruct.LengthT=1;
    paramsStruct.DepthMin=70;
    paramsStruct.NoCellX=4; %
    paramsStruct.NoCellY=4; %%
    paramsStruct.NoCellT=2; %% 
    paramsStruct.NoBin=35;
    % other default params can be specified here

    supportedArgs = {'LengthXY' 'LengthT' 'DepthMin','NoCellX',...
                     'NoCellY','NoCellT','NoBin'};

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
%% read depth video
fid=fopen(depthFile);
Duration=fread(fid,1,'int');
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
% calculate statistics
Min=paramsStruct.DepthMin;
minValue= min(min(min(Volum(Volum>Min))));
maxValue= max(max(max(Volum)));


%% read DSTIP file
Data=importdata(DSTIPFile);
I1=Data(:,1);
I2=Data(:,2);
I3=Data(:,3);
SIGMA=Data(:,4);
TAO=Data(:,5);
clear Data;

%% extracting features
display('extracting...')
display('total number of points')
length(I1)
for k=1:length(I1)
    sigma=SIGMA(k);
    tao=TAO(k);
%%  extract the cuboids from the data Volum around each interest points           
    CLength_xy=paramsStruct.LengthXY*sigma;
    CLength_t=paramsStruct.LengthT*tao;
    % adaptable size
%     Z=max(Volum(I1(k),I2(k),I3(k)-tao:I3(k)+tao));
    Z=min(99999*(Volum(I1(k),I2(k),I3(k)-tao:I3(k)+tao)<20)+Volum(I1(k),I2(k),I3(k)-tao:I3(k)+tao));
    CLength_xy_this=round(CLength_xy*3000/Z);
    cuboid=Volum(max(1,I1(k)-CLength_xy_this):min(nrows,I1(k)+CLength_xy_this),max(1,I2(k)-CLength_xy_this):min(ncols,I2(k)+CLength_xy_this),max(1,I3(k)-CLength_t):min(size(Volum,3),(I3(k)+CLength_t)));
    descriptor=ExtractDescriptor(cuboid,minValue,maxValue,paramsStruct.NoCellX,paramsStruct.NoCellY,paramsStruct.NoCellT,paramsStruct.NoBin);
     % write to Feature cell
%     eval(['Features_' files(fileCount).name(1:end-10) '(' num2str(count) ')=struct(''x'',I1(k),''y'',I2(k), ''z'',Z, ''t'',I3(k), ''cuboid'',descriptor);']);
%     %% save features
%     eval(['save(''Features_' files(fileCount).name(1:end-10) '.mat'', ''Features_' files(fileCount).name(1:end-10) ''', ''-v6''' ')' ;]);
%     eval(['clear(''Features_' files(fileCount).name(1:end-10) ''');' ]);
    dlmwrite(outputFile, [I1(k) I2(k) Z  I3(k) sigma tao descriptor],'-append');
end;
toc


% %% display as a video:
clear all
clc
fileName=[{'a13_s01_e01'}];%,{'a10_s01_e01'},{'a14_s02_e01'},{'a16_s01_e01'}];
for f=1:length(fileName)
    I=importdata('try.txt');  
    savePath='DSTIP_show\';
    y=I(:,1);
    x=I(:,2);
    t=I(:,3);
    sigma=5*ones(length(x),1);

    % load bin file
    binName=['C:\data\MSRDailyActivity3D\MSRDailyAct3D\' fileName{f} '_depth.bin'];
    fid=fopen(binName);
    Duration=fread(fid,1,'int');
    ncols=fread(fid,1,'int');
    nrows=fread(fid,1,'int');
    depthImg=zeros(nrows,ncols);
    Volum=zeros(nrows,ncols,3,Duration);
    for frameNumber=1:Duration
        for i=1:nrows
            depthImg(i,:)= fread(fid,ncols,'int32');
            ID=fread(fid,ncols,'int8');
        end;
        Volum(:,:,1,frameNumber)=depthImg;
        Volum(:,:,2,frameNumber)=depthImg;
        Volum(:,:,3,frameNumber)=depthImg;
    end;
    %% Plot the points
    for i=1:length(x)
        Volum(max(1,y(i)-sigma(i)):min(y(i)+sigma(i),240),max(1,x(i)-sigma(i)):min(320,x(i)+sigma(i)),1,t(i))=1;
        Volum(max(1,y(i)-sigma(i)):min(y(i)+sigma(i),240),max(1,x(i)-sigma(i)):min(320,x(i)+sigma(i)),2,t(i))=0;
        Volum(max(1,y(i)-sigma(i)):min(y(i)+sigma(i),240),max(1,x(i)-sigma(i)):min(320,x(i)+sigma(i)),3,t(i))=0;
    end;
    figure,imshow(Volum(:,:,:,50));

    for frameNumber=1:Duration
        saveName=num2str(frameNumber);
        imwrite(Volum(:,:,:,frameNumber),[savePath,saveName,'.jpg'],'JPEG');
    end;
end;

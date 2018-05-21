%     NoCellX=3;
%     NoCellY=3;  
%     NoCellT=2;
%     NoBin=35;
function [descriptor]=ExtractDescriptor(cuboid,minValue,maxValue,NoCellX,NoCellY,NoCellT,NoBin)
%% function: build the descriptor of the given coboid.
% input:
% cuboid: the 3D cuboid
% minValue, maxValue: for the depth histogram boundaries.

% DCSF
% divide the spatio in to 6*6 cells, divide the temporal into 4 cells.
cell_x=floor(size(cuboid,1)/NoCellX); 
cell_y=floor(size(cuboid,2)/NoCellY);
cell_t=floor(size(cuboid,3)/NoCellT);

bin=(minValue:(maxValue-minValue)/NoBin:maxValue);
H=zeros(NoCellT*(NoCellT+1)*NoCellX*(NoCellX+1)*(2*NoCellX+1)/12,NoBin+1); 
count=0;
for k=1:NoCellX
    block_x=cell_x*k;
    block_y=cell_y*k;

    for s=1:NoCellT
        block_t=cell_t*s;

        for i=0:NoCellX-k
            for j=0:NoCellY-k
                for l=0:NoCellT-s
                    count=count+1;
                    B=cuboid(i*cell_x+1:i*cell_x+block_x,j*cell_y+1:j*cell_y+block_y,l*cell_t+1:l*cell_t+block_t);
                    H(count,:)=histc(B(:),bin)';
                end;
            end;
        end;
    end;
end;
% normalize each row to sum to 1;
HSum=sum(H,2);
H=H./(repmat(HSum,1,NoBin+1)+1e-9);
% calculate similarity scores
SM=sqrt(H*H');
S=reshape(SM,1,length(SM)^2);
TuC=reshape(triu(ones(length(SM),length(SM)),1),1,length(SM)^2);
S(TuC==0)=[];

descriptor=S;


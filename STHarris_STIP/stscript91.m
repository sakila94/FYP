
%
% computing local jets at space-time point

if 0 % initialisation
  
  %f0=read_image_sequence('d:\video\sequences\gait09','avi',1,75);
  %seqname=sprintf('%s/%s','/disk1/laptev2/sequences','walk01uncomp')
  %f1=read_image_sequence(seqname,'avi',245,370);
  seqname=sprintf('%s/%s','d:/video/vcapdata','walk07uncomp')
  f1=read_image_sequence(seqname,'avi',1,200);
  
  %load('/net/santer/disk2/spattemp/dat/harris/harris_walk01uncomp_245_370_scadapt.mat');
  %load('d:/work/dat/spatiotemporal/harris/harris_walk07uncomp_1_200_scadapt.mat');
  load('d:/work/dat/spatiotemporal/harris/harris_walk07uncomp_228_400_scorig_all.mat');

  ftrs=posallarray;
  %ftrs=reduce_mult_features(posallarray,1);
  
end

if 1 % compute spat-temp. local jets
  
  if 0 % display features
    %M=overlayfeatures_xyt(f1,posallarray,[1 0 0],1);
    %showcirclefeatures_xyt(f1,ftrs,[1 1 0],1)
  end
  
  ftrsjet=ftrs;
  ftrsjet(:,4)=2*ftrs(:,4);
  ftrsjet(:,5)=2*ftrs(:,5);
  ljets=localjet_xyt(f1,ftrsjet);
  harrisjets=ljets;
  harrispos=ftrs;
end

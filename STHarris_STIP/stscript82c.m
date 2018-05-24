
%
% view result of interst point detection / jet computations
%

% set the path
datapath='d:/work/stharris';
harrispath='d:/work/stharris';
jetpath='d:/work/stharris';

offsets={};
seqnames={};

seqnames{length(seqnames)+1}='walk';
offsets{length(offsets)+1}=[1 50];

%seqnames{length(seqnames)+1}='xxx';
%offsets{length(offsets)+1}=[1 200];

%seqnames{length(seqnames)+1}='xxx';
%offsets{length(offsets)+1}=[201 400];

%...

method='';
compression='';
%compression='uncomp';


for iii=1:length(seqnames)
  ii1=offsets{iii}(1);
  ii2=offsets{iii}(2);
  seqname=sprintf('%s/%s%s',datapath,char(seqnames(iii)),compression)
  f1=read_image_sequence(seqname,'avi',ii1,ii2);

  if 1 % view interest points
    jname=sprintf('%s/harrisjets_%s%s_%d_%d_scvel2adapt',...
                  jetpath,method,char(seqnames(iii)),ii1,ii2)

    load(jname);
    showcirclefeatures_xyt(f1,harrispos(:,1:5),[1 1 0],1);
  end
end


%
%  stscript82batch
%
%  computes adapted interest points and their jet descriptors
%  for series of sequences; saves results in specified
%  directions (editing needed); initial scale values and
%  the max number of points at each scale level can be
%  specified as well.
%  This is a slow version. It has been tried on sequences
%  160x120x200 pixels. Higher resolution may imply memory
%  problems and high computational costs. If larger sequences
%  sould be processed, copute results separately for their
%  subparts.
%

% set the path
datapath='D:\FYP\Github Repository Local\FYP-activityNet\stharris-space-time interest points';
harrispath='D:\FYP\Github Repository Local\FYP-activityNet\stharris-space-time interest points';
jetpath='D:\FYP\Github Repository Local\FYP-activityNet\stharris-space-time interest points';

% set initial scales
nptsmax=25;
sx2arr=[4 8];
st2arr=[2 4];
method='';
compression='';
%compression='uncomp';
kparam=0.001;


% define sequences (names and offsets: first/last frames)
offsets={};
seqnames={};

seqnames{length(seqnames)+1}='walk';
offsets{length(offsets)+1}=[1 50];

%seqnames{length(seqnames)+1}='xxx';
%offsets{length(offsets)+1}=[1 200];

%seqnames{length(seqnames)+1}='xxx';
%offsets{length(offsets)+1}=[201 400];

%...

  
for iii=1:length(seqnames)
  ii1=offsets{iii}(1);
  ii2=offsets{iii}(2);
  seqname=sprintf('%s/%s%s',datapath,char(seqnames(iii)),compression)
  f1=read_image_sequence(seqname,'avi',ii1,ii2);


  if 1 % detect initial interest points
    stscript82a

    fname=sprintf('%s/harris_%s%s_%d_%d_scvel2orig',...
                  harrispath,method,char(seqnames(iii)),ii1,ii2)
    save(fname,'sx2arr','st2arr','nptsmax','seqname',...
                 'hposinit','hvalinit');
  end

  
  if 1 % adapt interest points 
    fname=sprintf('%s/harris_%s%s_%d_%d_scvel2orig',...
                  harrispath,method,char(seqnames(iii)),ii1,ii2)
    load(fname);

    stscript82b
  
    fname=sprintf('%s/harris_%s%s_%d_%d_scvel2adapt',...
                  harrispath,method,char(seqnames(iii)),ii1,ii2)
    save(fname,'sx2arr','st2arr','nptsmax','seqname',...
                 'hposinit','posall','posevolall','posallarray','valallarray');
  end


  if 1 % compute adapted descriptors
    fname=sprintf('%s/harris_%s%s_%d_%d_scvel2adapt',...
                  harrispath,method,char(seqnames(iii)),ii1,ii2)
    load(fname);

    ftrs=posallarray(:,1:7);
    size(ftrs)

    stscript91
    jname=sprintf('%s/harrisjets_%s%s_%d_%d_scvel2adapt',...
                  jetpath,method,char(seqnames(iii)),ii1,ii2)
    save(jname,'harrisjets','harrispos');
  end


  if 0 % compute non-adapted descriptors
    fname=sprintf('%s/harris_%s%s_%d_%d_scvel2orig',harrispath,method,char(seqnames(iii)),ii1,ii2)
    load(fname);
    hposinit(:,6)=0;
    hposinit(:,7)=0;

    ftrs=hposinit(:,1:7);
    size(ftrs)

    stscript91
    jname=sprintf('%s/harrisjets_%s%s_%d_%d_scorig',jetpath,method,char(seqnames(iii)),ii1,ii2)
    save(jname,'harrisjets','harrispos');
  end

end

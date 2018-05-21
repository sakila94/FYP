function result=read_image_sequence(name_prefix, format, i1, i2)

%
%  read_mage_sequence(name_prefix, format, i1, i2)
% 
%      reads images from a sequence, converts their values to 
%      (double)grey and returns a 3D x-y-t image array.
%      Names of image frames shall start with 'name_prefix'
%      followed by numbers from 'i1' to 'i2'.
%      Supported formats are 'avi', 'tif', 'jpg'.
%

if strcmp(format,'avi')
  if nargin<4 
    m=VideoReader(sprintf('%s.avi',name_prefix));
  else 

sprintf('%s.avi',name_prefix)
    m=VideoReader(sprintf('%s.avi',name_prefix),i1:i2);
  end
  f0=il_rgb2gray(double(frame2im(m(1))));
  result=zeros([size(f0), length(m)]);
  for i=1:length(m)
    result(:,:,i)=il_rgb2gray(double(frame2im(m(i))));
  end
  
else
  for i=i1:i2
    if strcmp(format,'tif')
      fname=sprintf('%s%03d.tif',name_prefix,i);
      img=double(imread(fname,'tiff'));
    elseif strcmp(format,'jpg')
      fname=sprintf('%s%03d.jpg',name_prefix,i);
      img=double(imread(fname,'jpg'));
    else
      break
    end
    
    % reduce to grey if RGB
    if ndims(img)==3
      img=(img(:,:,1)+img(:,:,2)+img(:,:,3))/3;
    end
    
    [sy,sx]=size(img);  
    
    if i==i1
      result=zeros(sy,sx,i2-i1);
    end
    
    result(:,:,i)=img;
  end
end



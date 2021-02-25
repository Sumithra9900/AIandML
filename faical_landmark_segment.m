  
%D:\datasets\vasavi_school\Aichitha H\1
close all;clc;clear all
C=1;D1=1;
    dr1=dir('10 session_experiment');
    for im1=5:length(dr1)
           dr2=dir(strcat('10 session_experiment\',dr1(im1).name));
           for im2=3:length(dr2)
              dr3=dir(strcat('10 session_experiment\',dr1(im1).name,'\',dr2(im2).name));
                            c=1;    IMAGES=1;
             for im3=3:length(dr3)       
                  dr4=dir(strcat('10 session_experiment\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name));
                 
                 for im4=3:length(dr4)
                        File=strcat(['10 session_experiment\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name,'\',dr4(im4).name]);
                        I=imresize(imread(File),[1000 1000]);
                        fprintf('child number=%d, session=%d and image=%d\n',im1-2,im2-2,im3-2)
          %%
          X=I;
thresholdParts = 1;  thresholdFace = 1; stdsize = 176;
nameDetector = {'LeftEye'; 'RightEye'; 'Mouth'; 'Nose'; };
detector.stdsize = stdsize;
detector.detector = cell(5,1);
for k=1:4
 minSize = int32([stdsize/5 stdsize/5]);
 detector.detector{k} = vision.CascadeObjectDetector(char(nameDetector(k)), 'MergeThreshold', thresholdParts, 'MinSize', minSize);
end
detector.detector{5} = vision.CascadeObjectDetector('FrontalFaceCART', 'MergeThreshold', thresholdFace);
%%%%%%%%%%%%%%%%%%%%%%% detect face %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detect faces
bbox = step(detector.detector{5}, X);
bsize = size(bbox);
partsNum = zeros(size(bbox,1),1);
%%%%%%%%%%%%%%%%%%%%%%% detect parts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stdsize = detector.stdsize;

for k=1:4
 if( k == 1 )
  region = [1,int32(stdsize*2/3); 1, int32(stdsize*2/3)];
 elseif( k == 2 )
  region = [int32(stdsize/3),stdsize; 1, int32(stdsize*2/3)];
 elseif( k == 3 )
  region = [1,stdsize; int32(stdsize/3), stdsize];
 elseif( k == 4 )
  region = [int32(stdsize/5),int32(stdsize*4/5); int32(stdsize/3),stdsize];
 else
  region = [1,stdsize;1,stdsize];
 end
 bb = zeros(bsize);
 for i=1:size(bbox,1)
  XX = X(bbox(i,2):bbox(i,2)+bbox(i,4)-1,bbox(i,1):bbox(i,1)+bbox(i,3)-1,:);
  XX = imresize(XX,[stdsize, stdsize]);
  XX = XX(region(2,1):region(2,2),region(1,1):region(1,2),:);
  b = step(detector.detector{k},XX);
  if( size(b,1) > 0 )
   partsNum(i) = partsNum(i) + 1;
   if( k == 1 )
    b = sortrows(b,1);
   elseif( k == 2 )
    b = flipud(sortrows(b,1));
   elseif( k == 3 )
    b = flipud(sortrows(b,2));
   elseif( k == 4 )
    b = flipud(sortrows(b,3));
   end
   ratio = double(bbox(i,3)) / double(stdsize);
   b(1,1) = ( ( b(1,1)-1 + region(1,1)-1 ) * ratio + 0.5 ) + bbox(i,1);
   b(1,2) = ( ( b(1,2)-1 + region(2,1)-1 ) * ratio + 0.5 ) + bbox(i,2);
   b(1,3) = ( b(1,3) * ratio + 0.5 );
   b(1,4) = ( b(1,4) * ratio + 0.5 );
   bb(i,:) = b(1,:);
  end
 end
 bbox = [bbox,bb];
 p = ( sum(bb') == 0 );
 bb(p,:) = [];
end
%%%%%%%%%%%%%%%%%%%%%%% draw faces %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bbox = [bbox,partsNum];
bbox(partsNum<=2,:)=[];
[M, N, D]=size(X);
%%
d=1;
 %imshow(X,'InitialMagnification',50);  %% imshow(,'InitialMagnification',500); hold on;
% hold on 
for i3=1:4
 
 cc=1;
for k=5:-1:1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if(k==5)
       d=d+1;
mkdir(strcat('D:\facial components parts\','Nose','\',dr1(im1).name,'\',dr2(im2).name));
bb = (bbox(:,(k-1)*4+1:k*4));
 if isempty(bb)
     box1=0;
     box2=0;         
 else 
    box1 = round(bb(1)+ bb(3)/ 2); box2=round(bb(2)+ bb(4)/2);
    %rectangle('Position',[(box1-110) (box2-80) 219 159]);
    rect1=imcrop(X,[(box1-50) (box2-50) 100 100]);
   % rect1=imcrop(X,[(box1-250) (box2-220) 500 400]);
   if( isempty(rect1))
    reslt_img=rand(20,20);
   else
     reslt_img=rect1;
       imwrite(reslt_img,['D:\facial components parts\','Nose','\',dr1(im1).name,'\',dr2(im2).name,'\',num2str(c),'.jpg'],'jpg');
   end
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif(k==3 ) %%%%%%% LEFT EYE %%%%%%%%%%%%%%%
       d=d+1;
       mkdir(strcat('D:\facial components parts\','LEFT_EYE','\',dr1(im1).name,'\',dr2(im2).name));
       bb = (bbox(:,(k-1)*4+1:k*4));
  if isempty(bb)
     box1=0;
     box2=0;    
FM(c,3)=0;
FM(c,4)=0;
  else
    box1 = round(bb(1)+ bb(3)/ 2); box2=round(bb(2)+ bb(4)/2);
    box1_1=round(box2-30);   box2_1=round(box2+30);
     rect3=imcrop(X,[(200) (box2-50) 500 100]);
     %rect3=imcrop(X,[(box1-250) (box2-250) 400 350]);
   % rect3=imcrop(X, [0 (box2-250) 1000 350]);
    if( isempty(rect3))
    reslt_img=rand(20,20);
   else
     reslt_img=rect3;
           imwrite(reslt_img,['D:\facial components parts\','LEFT_EYE','\',dr1(im1).name,'\',dr2(im2).name,'\',num2str(c),'.jpg'],'jpg');
       end
      end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif(k==2)
       d=d+1;
       mkdir(strcat('D:\facial components parts\','RIGHT_EYE','\',dr1(im1).name,'\',dr2(im2).name));
       bb = (bbox(:,(k-1)*4+1:k*4));
  if isempty(bb)
     box1=0;
     box2=0;     
       else
    box1 = (bb(1)+ bb(3)/ 2); box2=(bb(2)+ bb(4)/2);
    box1_1=round(box1-30);box2_1=round(box1+30); 
    rect4=imcrop(X,[(box1-60) (box2-100) 100 150]);
    %rect4=imcrop(X,[(box1-260) (box2-250) 400 350]);
    if( isempty(rect4))
    reslt_img=rand(20,20);
   else
     reslt_img=rect4;
           imwrite(reslt_img,['D:\facial components parts\','RIGHT_EYE','\',dr1(im1).name,'\',dr2(im2).name,'\',num2str(c),'.jpg'],'jpg');
    end
     end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif(k==4)
       d=d+1;
       mkdir(strcat('D:\facial components parts\','MOUTH','\',dr1(im1).name,'\',dr2(im2).name));
      bb = (bbox(:,(k-1)*4+1:k*4));
  if isempty(bb)
     box1=0;
     box2=0;    
  else
    box1 = (bb(1)+ bb(3)/ 2);  box2=(bb(2)+ bb(4)/2);
      rect2=imcrop(X,[(box1-50) (box2-50) 100 80]);
      %rect2=imcrop(X,[(box1-340) (box2-230) 500 650]);
    if( isempty(rect2))
    reslt_img=rand(20,20);
   else
     reslt_img=rect2;
           imwrite(reslt_img,['D:\facial components parts\','MOUTH','\',dr1(im1).name,'\',dr2(im2).name,'\',num2str(c),'.jpg'],'jpg');
    end
    end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(k==1)
    d=d+1;
    bb = (bbox(:,(k-1)*4+1:k*4));
 if isempty(bb)
     box1=0;
     box2=0;   
 else
    box1 = (bb(1)+ bb(3)/ 2);  box2=(bb(2)+ bb(4)/2);
 end
   end
end

end
c=c+1;
%B=B+1;% 2
   
    end
           end
    end
    end    
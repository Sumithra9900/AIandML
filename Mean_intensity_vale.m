clear all;clc;
images=1;combination=1;
dr1=dir(num2str('D:\STABLE AGE 41 COMBINATION'));
for im1=3:length(dr1)
           child=1;
           dr2=dir(strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name));
          % no_of_images=1;
           for im2=3:length(dr2)% number of children in each age
           dr3=dir(strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name));
           session=1;
           for im3=3:4%length(dr3)
           dr4=dir(strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name));
           for im4=4:4%length(dr4)
           File=strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name,'\',dr4(im4).name);
           X=imresize(imread(File),[500 500]);

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
[M N D]=size(X);
%%
% % % % % % % % % % %  imshow(X,'InitialMagnification',50);  %% imshow(,'InitialMagnification',500); hold on;
 % % % % % hold on
for k=5:-1:1
  %%%%%%%%%%%%%%%%%%% NOSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if(k==5)
       bb = (bbox(:,(k-1)*4+1:k*4));
if (isempty(bb)|(bb==0))
    NOSE_FEATURE(session,:)=zeros(1,500);
else
    box1 = (bb(1)+ bb(3)/ 2);  box2=(bb(2)+ bb(4)/2);
    if(isempty(box1)|(box1==0)) 
    NOSE_FEATURE(session,:)=zeros(1,500);
    else
    box1 = round(bb(1)+ bb(3)/ 2); box2=round(bb(2)+ bb(4)/2);
    box1_1=round(box2-50);   box2_1=round(box2+50);
            boox=1;
        for box=box1_1:box2_1
            NOSE(boox,1:500)=X(box,1:500);             
            boox=boox+1;
        end    
    [X1, Y1]=sort(mean(NOSE,1));
     NOSE_FEATURE(session,:)=Y1;
    end
end
  %%%%%%%%%%%%%%%%%%%%%%%% MOUTH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif(k==4)
      bb = (bbox(:,(k-1)*4+1:k*4));
if (isempty(bb)|(bb==0))  
    MOUTH_FEATURE(session,:)=zeros(1,500);
else
    box1 = (bb(1)+ bb(3)/ 2);  box2=(bb(2)+ bb(4)/2);
    if(isempty(box1)|(box1==0)) 
    MOUTH_FEATURE(session,:)=zeros(1,500);
    else
        box1 = (bb(1)+ bb(3)/ 2);  box2=(bb(2)+ bb(4)/2);
        box1_1=round(box1-50);   box2_1=round(box1+50);
            boox=1;
        for box=box1_1:box2_1
            MOUTH(1:500,boox)=X(1:500,box);             
            boox=boox+1;
        end    
    [X1, Y1]=sort(mean(MOUTH,2));
     MOUTH_FEATURE(session,:)=Y1;
    end 
end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EYE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif(k==3 )
      bb = (bbox(:,(k-1)*4+1:k*4));
if (isempty(bb)|(bb==0))  
      EYE_FEATURE(session,:)=zeros(1,500);   
else
    box1 = (bb(1)+ bb(3)/ 2);  box2=(bb(2)+ bb(4)/2);
    if(isempty(box1)|(box1==0)) 
    EYE_FEATURE(session,:)=zeros(1,500);
    else
    box1 = (bb(1)+ bb(3)/ 2); box2=(bb(2)+ bb(4)/2);
    box1_1=round(box2-50);   box2_1=round(box2+50);
            boox=1;
        for box=box1_1:box2_1
            EYE(boox,1:500)=X(box,1:500);             
            boox=boox+1;
        end    
    [X1, Y1]=sort(mean(EYE,1));
    EYE_FEATURE(session,:)=Y1;
    end
end
  %%%%%%%%%%%%%%%%%%%%%%%%  EYE:2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif(k==2)
             bb = (bbox(:,(k-1)*4+1:k*4)) ;
  %%%%%%%%%%%%%%%%%%%%%%%%%%% CENTER FACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(k==1)
       bb = (bbox(:,(k-1)*4+1:k*4)) ;
    end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           end
           session=session+1;
           end
           %% Correlation coefficient %%%
%%                      
           Eye1=pdist2(EYE_FEATURE(1,:),EYE_FEATURE(2,:),'correlation');% CORRELATION
        if( isnan(  Eye1))
           Eye(child)=0;
        else
            Eye(child)=Eye1;
        end
 %%        
           Mouth1=pdist2(MOUTH_FEATURE(1,:),MOUTH_FEATURE(2,:),'correlation');% CORRELATION
          if( isnan(  Mouth1))
           Mouth(child)=0;
        else
            Mouth(child)=Mouth1;
          end
 %%          
           Nose1=pdist2(NOSE_FEATURE(1,:),NOSE_FEATURE(2,:),'correlation');% CORRELATION
         if( isnan(  Nose1))
           Nose(child)=0;
        else
            Nose(child)=Nose1;  
         end
           child=child+1;
           clearvars -except combination child EYE MOUTH NOSE dr1 im1 dr2 im2 Eye Mouth Nose EYE_var MOUTH_var NOSE_var EYE_mean MOUTH_mean NOSE_mean
           end
           EYE_var(combination)=var(Eye);
           MOUTH_var(combination)=var(Mouth);
           NOSE_var(combination)=var(Nose);

           EYE_mean(combination)=mean(Eye);
           MOUTH_mean(combination)=mean(Mouth);
           NOSE_mean(combination)=mean(Nose);
           combination=combination+1;
           clear child
end
eval(['save',' Stable_Age_Identify_Method1_data2', ' Eye Mouth Nose EYE_var MOUTH_var NOSE_var EYE_mean MOUTH_mean NOSE_mean']);
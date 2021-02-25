clear all;clc;
images=1;combination=1; child=1;
dr1=dir(num2str('D:\stableagePrograms\YEAR_DATA'));
for im1=3:length(dr1)       
           dr2=dir(strcat('D:\stableagePrograms\YEAR_DATA\',dr1(im1).name));
           for image=1:(length(dr2)-3)
               imaging=1;
           for session=image:image+1
          File =strcat('D:\stableagePrograms\YEAR_DATA\',dr1(im1).name,'\',num2str(session),'.jpg')
%            session=1;
%            for im3=3:4%length(dr3)
%            dr4=dir(strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name));
%            for im4=4:4%length(dr4)
%            File=strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name,'\',dr4(im4).name);
           X=imresize(imread(File),[500 500]);

thresholdParts = 1;  thresholdFace = 1; stdsize = 176;
nameDetector = {'LeftEye'; 'RightEye'; 'Mouth'; 'Nose'; };
detector.stdsize = stdsize;
detector.detector = cell(5,1);
for k=1:4
 minSize = int32([stdsize/5 stdsize/5]);
 detector.detector{k} = vision.CascadeObjectDetector(char(nameDetector(k)), 'MergeThreshold', thresholdParts, 'MinSize', minSize);
bbox = step(detector.detector{k}, X);
imshow(imcrop(X,bbox(1,:)));
end
  end
           end
end
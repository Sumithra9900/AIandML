clear all;clc;
images=1;combination=1; child=1;
dr1=dir(num2str('D:\stableagePrograms\YEAR_DATA'));
for im1=3:length(dr1)       
           dr2=dir(strcat('D:\stableagePrograms\YEAR_DATA\',dr1(im1).name));
           for image=1:(length(dr2)-3)
               imaging=1;
           for session=image:image+1
           File =strcat('D:\stableagePrograms\YEAR_DATA\',dr1(im1).name,'\',num2str(session),'.jpg');
%            session=1;
%            for im3=3:4%length(dr3)
%            dr4=dir(strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name));
%            for im4=4:4%length(dr4)
%            File=strcat('D:\STABLE AGE 41 COMBINATION\',dr1(im1).name,'\',dr2(im2).name,'\',dr3(im3).name,'\',dr4(im4).name);
            img=imresize(imread(File),[500 500]);
            [M, N, O]=size(img);
            if (O==1)
                X=img;
            elseif(O==3)
                X=rgb2gray(img);
            end
            %HOG_FEATURE(imaging,:)= extractHOGFeatures(X,'CellSize',[16 16],'BlockSize',[16 16]);
            MLBP_FEATURE(imaging,1:59) = extractLBPFeatures(X,'NumNeighbors',8,'Radius',1,'Interpolation','Linear');
            MLBP_FEATURE(imaging,60:118)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',2,'Interpolation','Linear');
            MLBP_FEATURE(imaging,119:177)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',3,'Interpolation','Linear');
            MLBP_FEATURE(imaging,178:236)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',4,'Interpolation','Linear');
            MLBP_FEATURE(imaging,237:295)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',5,'Interpolation','Linear');                     
            imaging=imaging+1;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           end
           %% Correlation coefficient %%%                     
           MLBP_ECLD(child,image)=pdist2(MLBP_FEATURE(1,:),MLBP_FEATURE(2,:));% EUCLIDEAN
           MLBP_MNKS(child,image)=pdist2(MLBP_FEATURE(1,:),MLBP_FEATURE(2,:),'cityblock');% CITYBLOCK
           MLBP_COS(child,image)=pdist2(MLBP_FEATURE(1,:),MLBP_FEATURE(2,:),'cosine');% COSINE 
           MLBP_CORR(child,image)=pdist2(MLBP_FEATURE(1,:),MLBP_FEATURE(2,:),'correlation');% MINKOWSKI         
           clear HOG_FEATURE
           end
           child=child+1;
           clearvars -except child dr1 im1 dr2 im2 MLBP_ECLD MLBP_MNKS MLBP_COS MLBP_CORR      
end  
           MLBP_EC_var=normalize(var(MLBP_ECLD),'range',[1 100]);
           MLBP_MN_var=normalize(var(MLBP_MNKS),'range',[1 100]);%MLBP_EC_Mean MLBP_MN_Mean MLBP_COS_Mean MLBP_COR_Mean
           MLBP_COS_var=normalize(var(MLBP_COS),'range',[1 100]);
           MLBP_COR_var=normalize(var(MLBP_CORR),'range',[1 100]);
%% FUSSION_FEATURE=normalize(EYE_var,'range',[1 100]);
           MLBP_EC_Mean=normalize(mean(MLBP_ECLD),'range',[1 100]);
           MLBP_MN_Mean=normalize(mean(MLBP_MNKS),'range',[1 100]);%MLBP_EC_Mean MLBP_MN_Mean MLBP_COS_Mean MLBP_COR_Mean
           MLBP_COS_Mean=normalize(mean(MLBP_COS),'range',[1 100]);
           MLBP_COR_Mean=normalize(mean(MLBP_CORR),'range',[1 100]);

eval(['save',' Stable_Age_Identify_Method2_data1MLBP', ' MLBP_ECLD MLBP_MNKS MLBP_COS MLBP_CORR MLBP_EC_var MLBP_MN_var MLBP_COS_var MLBP_COR_var MLBP_EC_Mean MLBP_MN_Mean MLBP_COS_Mean MLBP_COR_Mean']);
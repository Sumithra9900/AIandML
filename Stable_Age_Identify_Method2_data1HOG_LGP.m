clear all;clc;
images=1;combination=1; child=1;
dr1=dir(num2str('D:\stableagePrograms\YEAR_DATA'));
for im1=3:length(dr1)       
           dr2=dir(strcat('D:\stableagePrograms\YEAR_DATA\',dr1(im1).name));
           for image=1:(length(dr2)-3)
               imaging=1;
           for session=image:image+1
           File =strcat('D:\stableagePrograms\YEAR_DATA\',dr1(im1).name,'\',num2str(session),'.jpg');
           img=imresize(imread(File),[500 500]);
            [M, N, O]=size(img);
            if (O==1)
                X=img;
            elseif(O==3)
                X=rgb2gray(img);
            end
            u=5;v=8;m=39;n=39;
                                gaborArray = cell(u,v);
                                fmax = 0.25;
                                gama = sqrt(2);
                                eta = sqrt(2);
                                for i = 1:u  
                                fu = fmax/((sqrt(2))^(i-1));
                                alpha = fu/gama;
                                beta = fu/eta;   
                                for j = 1:v
                                    tetav = ((j-1)/v)*pi;
                                    gFilter = zeros(m,n);        
                                    for x = 1:m
                                        for y = 1:n
                                        xprime = (x-((m+1)/2))*cos(tetav)+(y-((n+1)/2))*sin(tetav);
                                        yprime = -(x-((m+1)/2))*sin(tetav)+(y-((n+1)/2))*cos(tetav);
                                        gFilter(x,y) = (fu^2/(pi*gama*eta))*exp(-((alpha^2)*(xprime^2)+(beta^2)*(yprime^2)))*exp(1i*2*pi*fu*xprime);
                                        end
                                    end
                                    gaborArray{i,j} = gFilter;       
                                end
                            end
                            img = X;%rgb2gray(X);
                            img = double(img);
                            %% Filtering
                            % Filter input image by each Gabor filter
                            [u,v] = size(gaborArray);
                            gaborResult = cell(u,v);
                            for i = 1:u
                                for j = 1:v
                                    gaborResult{i,j} = conv2(img,gaborArray{i,j},'same');
                                    % J{u,v} = filter2(G{u,v},I);
                                end
                            end
                            block=1;
                            for ii=1:size(gaborResult,1)
                                for jj=1:size(gaborResult,2)
                                FEAT(block,1:59)=extractLBPFeatures(real(gaborResult{ii,jj}),'NumNeighbors',8,'Radius',1,'Interpolation','Linear');
                                FEAT(block,60:118)=extractLBPFeatures(real(gaborResult{ii,jj}),'NumNeighbors',8,'Radius',2,'Interpolation','Linear');
                                FEAT(block,119:177)=extractLBPFeatures(real(gaborResult{ii,jj}),'NumNeighbors',8,'Radius',3,'Interpolation','Linear');
                                FEAT(block,178:236)=extractLBPFeatures(real(gaborResult{ii,jj}),'NumNeighbors',8,'Radius',4,'Interpolation','Linear');
                                FEAT(block,237:295)=extractLBPFeatures(real(gaborResult{ii,jj}),'NumNeighbors',8,'Radius',5,'Interpolation','Linear');
                                block=block+1;
                                end
                            end
                      LGP_FEATURE(1,:)=sum(FEAT,1);
                      HOG_FEATURE(1,:) = extractHOGFeatures(X,'CellSize',[16 16],'BlockSize',[16 16]);
% %                       MLBP_FEATURE(1,1:59)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',1,'Interpolation','Linear');
% %                       MLBP_FEATURE(1,60:118)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',2,'Interpolation','Linear');
% %                       MLBP_FEATURE(1,119:177)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',3,'Interpolation','Linear');
% %                       MLBP_FEATURE(1,178:236)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',4,'Interpolation','Linear');
% %                       MLBP_FEATURE(1,237:295)=extractLBPFeatures(X,'NumNeighbors',8,'Radius',5,'Interpolation','Linear');                     
                     % FEATURE_MAT(:,1:9216)=MLBP_FEATURE; 
                      FEATURE_MAT(:,1:9216)=HOG_FEATURE; 
                      FEATURE_MAT(:,9217:9511)=LGP_FEATURE;%9216
                      FUSSION_FEATURE=normalize(FEATURE_MAT,'range',[1 100]);   
                      LGP_HOG(imaging,:)=FUSSION_FEATURE;
                      clear  HOG_FEATURE LGP_FEATURE
                      imaging=imaging+1;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           end
           %% Correlation coefficient %%%                     
           LGP_HOG_ECLD(child,image)=pdist2(LGP_HOG(1,:),LGP_HOG(2,:));% EUCLIDEAN
           LGP_HOG_MNKS(child,image)=pdist2(LGP_HOG(1,:),LGP_HOG(2,:),'cityblock');% CITYBLOCK
           LGP_HOG_COS(child,image)=pdist2(LGP_HOG(1,:),LGP_HOG(2,:),'cosine');% COSINE 
           LGP_HOG_CORR(child,image)=pdist2(LGP_HOG(1,:),LGP_HOG(2,:),'correlation');% MINKOWSKI         
           clear HOG_FEATURE
           end
           child=child+1;
           clearvars -except child dr1 im1 dr2 im2 LGP_HOG_ECLD LGP_HOG_MNKS LGP_HOG_COS LGP_HOG_CORR      
end  
           LGP_HOG_EC_var=normalize(var(LGP_HOG_ECLD),'range',[1 100]);
           LGP_HOG_MN_var=normalize(var(LGP_HOG_MNKS),'range',[1 100]);%MLBP_EC_Mean MLBP_MN_Mean MLBP_COS_Mean MLBP_COR_Mean
           LGP_HOG_COS_var=normalize(var(LGP_HOG_COS),'range',[1 100]);
           LGP_HOG_COR_var=normalize(var(LGP_HOG_CORR),'range',[1 100]);
                            %% FUSSION_FEATURE=normalize(EYE_var,'range',[1 100]);
           LGP_HOG_EC_Mean=normalize(mean(LGP_HOG_ECLD),'range',[1 100]);
           LGP_HOG_MN_Mean=normalize(mean(LGP_HOG_MNKS),'range',[1 100]);%MLBP_EC_Mean MLBP_MN_Mean MLBP_COS_Mean MLBP_COR_Mean
           LGP_HOG_COS_Mean=normalize(mean(LGP_HOG_COS),'range',[1 100]);
           LGP_HOG_COR_Mean=normalize(mean(LGP_HOG_CORR),'range',[1 100]);

eval(['save',' Stable_Age_Identify_Method2_data1HOG_LGP', ' LGP_HOG_ECLD LGP_HOG_MNKS LGP_HOG_COS LGP_HOG_CORR LGP_HOG_EC_var LGP_HOG_MN_var LGP_HOG_COS_var LGP_HOG_COR_var LGP_HOG_EC_Mean LGP_HOG_MN_Mean LGP_HOG_COS_Mean LGP_HOG_COR_Mean']);
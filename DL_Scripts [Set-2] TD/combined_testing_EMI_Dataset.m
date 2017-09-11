close all;
clear all;
clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Load class specific dictionaries                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% load dictionary for BGN
load ('BGN1_DL_Data');
D_BGN=Dict;
clear Dict; clear J; clear Z;

% load dictionary for CFL
load ('CFL1_DL_Data');
D_CFL=Dict;
clear Dict; clear J; clear Z;

% load dictionary for CPU
load ('CPU1_DL_Data');
D_CPU=Dict;
clear Dict; clear J; clear Z;

% load dictionary for LC
load ('LC1_DL_Data');
D_LC=Dict;
clear Dict; clear J; clear Z;

% load dictionary for LCD
load ('LCD1_DL_Data');
D_LCD=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PRJ
load ('PRJ1_DL_Data');
D_PRJ=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PS
load ('PS1_DL_Data');
D_PS=Dict;
clear Dict; clear J; clear Z;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Four Appliance Scenario                                   %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%load EMI data samples 
load ('BGN1_reshaped_TD_Data');
TEST_BGN = Data_Scaled(:,1:800); clear Data_Scaled;

load ('CFL1_reshaped_TD_Data');
TEST_CFL = Data_Scaled(:,1:800); clear Data_Scaled;

load ('CPU1_reshaped_TD_Data');
TEST_CPU = Data_Scaled(:,1:800); clear Data_Scaled;

TEST = [TEST_CFL];
%% concatenating dictionaries

% Dictionary=[D_BGN D_CFL D_CPU D_LC];

Dictionary=[D_BGN D_CFL D_CPU D_LC D_LCD D_PRJ D_PS];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                         classification before disaggregation                %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% [predClass, residual] = SRC(Dictionary, TEST, class);
% N_FH=length(predClass(predClass==1));
% N_BH=length(predClass(predClass==2)); 
% N_TF=length(predClass(predClass==3));
% ACC_FH_BD=N_FH/size(TEST,2)*100;
% ACC_BH_BD=N_BH/size(TEST,2)*100;
% ACC_TF_BD=N_TF/size(TEST,2)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            sparse coding based disaggregation                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z=myIST(Dictionary,TEST,1000,0.001);

%% Coefficients Belonging to AUT

Z1=Z((1:1000),:);
Z2=Z((1001:2000),:);
Z3=Z((2001:3000),:);
Z4=Z((3001:4000),:);
Z5=Z((4001:5000),:);
Z6=Z((5001:6000),:);
Z7=Z((6001:7000),:);


%%
class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_SH,2)) 4*ones(1,size(D_TF,2))];
k = max(class); % number of classes
% 
% decision making
for i=1:k
for iter=1:size(Z,2)
        classRep =Z(find(class==i),:);
        thresh_coeff(i,iter) =norm((classRep(:,iter)));
end
end
m=[];
for i=1:k
        [a b] =find(thresh_coeff(i,:)>0.001);
        classRep=sum(a);
        m=[m classRep];
end

% for i=1:k
% for iter=1:size(Z,2)
%         classRep =fftshift(fft(Dictionary(:,find(class==i))*Z(find(class==i),:)));
%         thresh_coeff(i,iter) =max((classRep(:,iter)));
% end
% end
% count_FH=length(find(thresh_coeff(1,:)>=0.001));
% count_BH=length(find(thresh_coeff(2,:)>=0.001));
% count_TF=length(find(thresh_coeff(3,:)>=0.001));
% count_FH_BH=length(find((thresh_coeff(1,:)>=0.001)& (thresh_coeff(2,:)>=0.001)));
% count_BH_TF=length(find((thresh_coeff(2,:)>=0.001)& (thresh_coeff(3,:)>=0.001)));
% count_FH_TF=length(find((thresh_coeff(1,:)>=0.001)& (thresh_coeff(3,:)>=0.001)));
% count_FH_BH_TF=length(find((thresh_coeff(1,:)>=0.001)& (thresh_coeff(2,:)>=0.001)& (thresh_coeff(3,:)>=0.001)));
% count_none=length(find((thresh_coeff(1,:)<=0.001)& (thresh_coeff(2,:)<=0.001)& (thresh_coeff(3,:)<=0.001)));
% for j=1:size(Z,2)
%  if thresh_coeff(1,j)<0.001
%     Z1(:,j)=zeros(size(Z1(:,1)));
%     T_FH_tilda_positive(:,j)=D_FH*Z1(:,j);
%  else
%     T_FH_tilda_positive(:,j)=D_FH*Z1(:,j);
% NUM_HUMAN=size();
% A_FH_AD=NUM_HUMAN/size(T_FH_tilda_positive,2)*100;
% end
% 
% if norm(Z2,'fro')<0.01
%     Z2=zeros(size(Z2));
%     disp('backward walking human is absent');
    T_BH_tilda_positive=D_BH*Z2;
%     A_BH_AD=0;
% else
%     disp('backward walking human is present'); 
%     T_BH_tilda_positive=D_BH*Z2;
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% [predClass] = SRC(Dictionary, T_BH_tilda_positive, class);
% NUM_HUMAN=length(predClass(predClass==2));
% A_BH_AD=NUM_HUMAN/size(T_BH_tilda_positive,2)*100;
% end
% 
% if norm(Z3,'fro')<0.01
%         Z3=zeros(size(Z3));
%        disp('table fan is absent');
%        T_TF_tilda_positive=D_TF*Z3;
%        A_TF_AD=0;
% else
%     disp('table fan is present');
    T_TF_tilda_positive=D_TF*Z3;
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% [predClass, residual] = SRC(Dictionary, T_TF_tilda_positive, class);
% NUM_TABLE_FAN=length(predClass(predClass==3));
% A_TF_AD=NUM_TABLE_FAN/size(T_TF_tilda_positive,2)*100;
% end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   CLassification after disaggregation                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                   
% if norm(Z1,'fro')<0.01
%     Z1=zeros(size(Z1));
%     disp('forward walking human is absent');
%     T_FH_tilda_positive=D_FH*Z1;
%     A_FH_AD=0;
% else
%     disp('forward walking human is present'); 
    T_FH_tilda_positive=D_FH*Z1;
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% [predClass] = SRC(Dictionary, T_FH_tilda_positive, class);
% NUM_HUMAN=length(predClass(predClass==1));
% A_FH_AD=NUM_HUMAN/size(T_FH_tilda_positive,2)*100;
% end
% 
% if norm(Z2,'fro')<0.01
%     Z2=zeros(size(Z2));
%     disp('backward walking human is absent');
%     T_BH_tilda_positive=D_BH*Z2;
%     A_BH_AD=0;
% else
%     disp('backward walking human is present'); 
%     T_BH_tilda_positive=D_BH*Z2;
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% [predClass] = SRC(Dictionary, T_BH_tilda_positive, class);
% NUM_HUMAN=length(predClass(predClass==2));
% A_BH_AD=NUM_HUMAN/size(T_BH_tilda_positive,2)*100;
% end
% 
% if norm(Z3,'fro')<0.01
%         Z3=zeros(size(Z3));
%        disp('table fan is absent');
%        T_TF_tilda_positive=D_TF*Z3;
%        A_TF_AD=0;
% else
%     disp('table fan is present');
%     T_TF_tilda_positive=D_TF*Z3;
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% [predClass, residual] = SRC(Dictionary, T_TF_tilda_positive, class);
% NUM_TABLE_FAN=length(predClass(predClass==3));
% A_TF_AD=NUM_TABLE_FAN/size(T_TF_tilda_positive,2)*100;
% end


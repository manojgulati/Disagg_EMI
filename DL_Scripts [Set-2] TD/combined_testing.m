close all;
clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Load class specific dictionaries                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% load dictionary for forward human
load ('human_forward_DL','Dict_human');
D_FH=Dict_human;

% load dictionary for backward human
load ('human_backward_DL','Dict_human');
D_BH=Dict_human;

% load dictionary for table fan
load ('human_sideways_DL','Dict_human');
D_SH=Dict_human;

% load dictionary for table fan
load ('table_fan_DL','Dict_human');
D_TF=Dict_human;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             Single Target Scenario (FH- forward human)                  %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_FH');
% TEST=data_human_forward(:,151:200);
% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %            Single Target Scenario (BH- backward human)                    %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_BH');
% TEST=data_human_backward(:,151:200);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Single Target Scenario (SH- sideways walking human)                  %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_SH');
% TEST=data_human_sideways(:,151:200);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Single Target Scenario (TF- table fan)                               %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_TF');
% TEST=data_table_fan(:,151:200);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             Two Target Scenario (FH-BH)                                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_FH_BH');
% TEST=data_human_forward_backward;
% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %            Two Target Scenario (BH-TF)                                  %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_BH_TF');
% TEST=data_human_backward_table_fan;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Two Target Scenario (FH-TF)                                          %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_FH_TF');
% TEST=data_human_forward_table_fan;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Two Target Scenario (SH-TF)                                          %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_SH_TF');
% TEST=data_human_sideways_TF;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             Three Target Scenario (FH-BH-TF)                            %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_FH_BH_TF');
% TEST=data_human_forward_backward_TF;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %            Three Target Scenario (FH-SH-TF)                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_FH_SH_TF');
% TEST=data_human_forward_sideways_TF;
% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Three Target Scenario (BH-SH-TF)                                     %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %load human data samples 
% load ('data_BH_SH_TF');
% TEST=data_human_backward_sideways_TF;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Four Target Scenario (FH-BH-SH-TF)                                    %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%load human data samples 
load ('data_FH_BH_SH_TF');
TEST=data_human_forward_backward_sideways_TF;

% %concatenating dictionaries
 Dictionary=[D_FH D_BH D_SH D_TF];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


%coefficients belonging to human
Z1=Z((1:2000),:);

%coefficients belonging to table fan
Z2=Z((2001:4000),:);
% 
% %coefficients belonging to Ceiling fan
Z3=Z((4001:6000),:);

% %coefficients belonging to Ceiling fan
Z4=Z((6001:8000),:);


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


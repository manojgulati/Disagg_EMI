close all;
clear all;
clc;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

Path1 = '_DL_Data_T4_1';

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Load class specific dictionaries                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% load dictionary for CFL
load (strcat('CFL',Path1));
D_CFL=Dict;
clear Dict; clear J; clear Z;

% load dictionary for CPU
load (strcat('CPU',Path1));
D_LCD_CPU=Dict;
clear Dict; clear J; clear Z;

% load dictionary for LC
load (strcat('LC',Path1));
D_LC=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PRJ
load (strcat('PRJ',Path1));
D_PRJ=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PRT
load (strcat('PRT',Path1));
D_PRT=Dict;
clear Dict; clear J; clear Z;

% load dictionary for MFD
load (strcat('MFD',Path1));
D_MFD=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PRJ
load (strcat('BGN',Path1));
D_BGN=Dict;
clear Dict; clear J; clear Z;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    Four Appliance Scenario                                   %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%load EMI data samples 
% load ('BGN1_reshaped_TD_Data');
% TEST_BGN = Data_Scaled(:,1:800); clear Data_Scaled;
% 
% load ('CFL1_reshaped_TD_Data');
% TEST_CFL = Data_Scaled(:,1:800); clear Data_Scaled;
% 
% load ('CPU1_reshaped_TD_Data');
% TEST_CPU = Data_Scaled(:,1:800); clear Data_Scaled;
% 
% load ('LC1_reshaped_TD_Data');
% TEST_LC = Data_Scaled(:,1:800); clear Data_Scaled;
% 
% load ('LCD1_reshaped_TD_Data');
% TEST_LCD = Data_Scaled(:,1:800); clear Data_Scaled;
% 
% load ('PRJ1_reshaped_TD_Data');
% TEST_PRJ = Data_Scaled(:,1:800); clear Data_Scaled;
% 
% load ('PS1_reshaped_TD_Data');
% TEST_PS = Data_Scaled(:,1:800); clear Data_Scaled;

% % concatenating dictionaries

Dictionary=[D_CFL D_LCD_CPU D_LC D_PRJ D_PRT D_MFD D_BGN];

%% %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            sparse coding based disaggregation                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
for i=1:41
    disp(i);
    load(strcat(char(File_Names(i)),'_TD_Dump'));

    TEST = M1(:,:); 

    clear M1;

    Z=myIST(Dictionary,TEST,1000,0.001);
    save(strcat('Z_',char(File_Names(i)),'_Selftest_T4_1.mat'),'Z');
    clear TEST; clear Z; %clear TEST_Norm;
end
disp('Self Test Done');

% %% 
% for i=1:4
%     disp(i);
%     load(strcat(char(File_Names(i)),'_reshaped_TD_Data'));
%     TEST = Data_Scaled(:,801:1600); clear Data_Scaled;
% %     TEST_Norm = (TEST - min(min(TEST)))/(max(max(TEST)) - min(min(TEST)));
%     Z=myIST(Dictionary,TEST,1000,0.001);
%     save(strcat('Z_',char(File_Names(i)),'_Crosstest_T1.mat'),'Z');
%     clear TEST; clear Z; %clear TEST_Norm;
% end
% disp('Cross Test Done');

% %
% 
% File_name = Dict;
% 
% imagesc(File_name); 
% colorbar;
% % caxis([-0.06 0.06]);
% 
% % saveas(gcf,strcat('Z_UnScaled_PRJ','_NAxis.png'));
% % saveas(gcf,strcat('PRJ_Dict_Norm','.png'));
% 
% %% Quick Stats
% Z1_Test = File_name;
% Z1_Stats = [median(median(Z1_Test)); mean(mean(Z1_Test)); std(std(Z1_Test)); max(max(Z1_Test)); min(min(Z1_Test))]';
% 
% Z1_Stats
% 
% %% Coefficients Belonging to AUT
% 
% Z1=Z((1:100),:);
% Z2=Z((101:200),:);
% Z3=Z((201:300),:);
% Z4=Z((301:400),:);
% % Z5=Z((4001:5000),:);
% % Z6=Z((5001:6000),:);
% % Z7=Z((6001:7000),:);
% 
% Z1_N = norm(Z1);
% Z2_N = norm(Z2);
% Z3_N = norm(Z3);
% Z4_N = norm(Z4);
% % Z5_N = norm(Z5);
% % Z6_N = norm(Z6);
% % Z7_N = norm(Z7);
% 
% %%
% 
% % C7 = [Z1_N;Z2_N;Z3_N;Z4_N;Z5_N;Z6_N;Z7_N];
% 
% clearvars -except C1 C2 C3 C4 C5 C6 C7
% 
% C = [C1 C2 C3 C4 C5 C6 C7];
% %%
% class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_SH,2)) 4*ones(1,size(D_TF,2))];
% k = max(class); % number of classes
% % 
% % decision making
% for i=1:k
% for iter=1:size(Z,2)
%         classRep =Z(find(class==i),:);
%         thresh_coeff(i,iter) =norm((classRep(:,iter)));
% end
% end
% m=[];
% for i=1:k
%         [a b] =find(thresh_coeff(i,:)>0.001);
%         classRep=sum(a);
%         m=[m classRep];
% end
% 
% % for i=1:k
% % for iter=1:size(Z,2)
% %         classRep =fftshift(fft(Dictionary(:,find(class==i))*Z(find(class==i),:)));
% %         thresh_coeff(i,iter) =max((classRep(:,iter)));
% % end
% % end
% % count_FH=length(find(thresh_coeff(1,:)>=0.001));
% % count_BH=length(find(thresh_coeff(2,:)>=0.001));
% % count_TF=length(find(thresh_coeff(3,:)>=0.001));
% % count_FH_BH=length(find((thresh_coeff(1,:)>=0.001)& (thresh_coeff(2,:)>=0.001)));
% % count_BH_TF=length(find((thresh_coeff(2,:)>=0.001)& (thresh_coeff(3,:)>=0.001)));
% % count_FH_TF=length(find((thresh_coeff(1,:)>=0.001)& (thresh_coeff(3,:)>=0.001)));
% % count_FH_BH_TF=length(find((thresh_coeff(1,:)>=0.001)& (thresh_coeff(2,:)>=0.001)& (thresh_coeff(3,:)>=0.001)));
% % count_none=length(find((thresh_coeff(1,:)<=0.001)& (thresh_coeff(2,:)<=0.001)& (thresh_coeff(3,:)<=0.001)));
% % for j=1:size(Z,2)
% %  if thresh_coeff(1,j)<0.001
% %     Z1(:,j)=zeros(size(Z1(:,1)));
% %     T_FH_tilda_positive(:,j)=D_FH*Z1(:,j);
% %  else
% %     T_FH_tilda_positive(:,j)=D_FH*Z1(:,j);
% % NUM_HUMAN=size();
% % A_FH_AD=NUM_HUMAN/size(T_FH_tilda_positive,2)*100;
% % end
% % 
% % if norm(Z2,'fro')<0.01
% %     Z2=zeros(size(Z2));
% %     disp('backward walking human is absent');
%     T_BH_tilda_positive=D_BH*Z2;
% %     A_BH_AD=0;
% % else
% %     disp('backward walking human is present'); 
% %     T_BH_tilda_positive=D_BH*Z2;
% % class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% % [predClass] = SRC(Dictionary, T_BH_tilda_positive, class);
% % NUM_HUMAN=length(predClass(predClass==2));
% % A_BH_AD=NUM_HUMAN/size(T_BH_tilda_positive,2)*100;
% % end
% % 
% % if norm(Z3,'fro')<0.01
% %         Z3=zeros(size(Z3));
% %        disp('table fan is absent');
% %        T_TF_tilda_positive=D_TF*Z3;
% %        A_TF_AD=0;
% % else
% %     disp('table fan is present');
%     T_TF_tilda_positive=D_TF*Z3;
% % class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% % [predClass, residual] = SRC(Dictionary, T_TF_tilda_positive, class);
% % NUM_TABLE_FAN=length(predClass(predClass==3));
% % A_TF_AD=NUM_TABLE_FAN/size(T_TF_tilda_positive,2)*100;
% % end
% % end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                   CLassification after disaggregation                    %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                   
% % if norm(Z1,'fro')<0.01
% %     Z1=zeros(size(Z1));
% %     disp('forward walking human is absent');
% %     T_FH_tilda_positive=D_FH*Z1;
% %     A_FH_AD=0;
% % else
% %     disp('forward walking human is present'); 
%     T_FH_tilda_positive=D_FH*Z1;
% % class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% % [predClass] = SRC(Dictionary, T_FH_tilda_positive, class);
% % NUM_HUMAN=length(predClass(predClass==1));
% % A_FH_AD=NUM_HUMAN/size(T_FH_tilda_positive,2)*100;
% % end
% % 
% % if norm(Z2,'fro')<0.01
% %     Z2=zeros(size(Z2));
% %     disp('backward walking human is absent');
% %     T_BH_tilda_positive=D_BH*Z2;
% %     A_BH_AD=0;
% % else
% %     disp('backward walking human is present'); 
% %     T_BH_tilda_positive=D_BH*Z2;
% % class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% % [predClass] = SRC(Dictionary, T_BH_tilda_positive, class);
% % NUM_HUMAN=length(predClass(predClass==2));
% % A_BH_AD=NUM_HUMAN/size(T_BH_tilda_positive,2)*100;
% % end
% % 
% % if norm(Z3,'fro')<0.01
% %         Z3=zeros(size(Z3));
% %        disp('table fan is absent');
% %        T_TF_tilda_positive=D_TF*Z3;
% %        A_TF_AD=0;
% % else
% %     disp('table fan is present');
% %     T_TF_tilda_positive=D_TF*Z3;
% % class=[ones(1,size(D_FH,2)) 2*ones(1,size(D_BH,2)) 3*ones(1,size(D_TF,2))];
% % [predClass, residual] = SRC(Dictionary, T_TF_tilda_positive, class);
% % NUM_TABLE_FAN=length(predClass(predClass==3));
% % A_TF_AD=NUM_TABLE_FAN/size(T_TF_tilda_positive,2)*100;
% % end
% 

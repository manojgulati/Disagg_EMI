close all;
clear all;
clc;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

Path1 = '_DDL_Data_T5';

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

% load dictionary for BGN
load (strcat('BGN',Path1));
D_BGN=Dict;
clear Dict; clear J; clear Z;

% % concatenating dictionaries
Dictionary=[D_CFL D_LCD_CPU D_LC D_PRJ D_PRT D_MFD D_BGN];

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            sparse coding based disaggregation                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Uncomment this section (below) while using this script for testing DL on test data

% for i=29:41
%     disp(i);
%     load(strcat(char(File_Names(i)),'_TD_Dump'));
%     % % Convert Data in to dB scale
% %     ampY_dB = 10*log10(1000*((ampY_1.^2)/10^6));
%     TEST = M1(:,:); 
% %     clear ampY_dB; 
%     clear M1;
% %     TEST_Norm = (TEST - min(min(TEST)))/(max(max(TEST)) - min(min(TEST)));
%     Z=myIST(Dictionary,TEST,1000,0.001);
%     save(strcat('Z_',char(File_Names(i)),'_Selftest_T5.mat'),'Z');
%     clear TEST; clear Z; %clear TEST_Norm;
% end
% disp('Testing Done');


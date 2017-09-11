clc;
clear all;
close all;

% Load appliance dictionaries
combined_testing_EMI_Dataset_2();

% Number of dictionary atoms
Num_classes = 7;
% Number of test samples used while testing
Num_test_samples = 3000;
% Number of dictionary atoms
Dict_atoms = 100;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};
D = [];

File_Index = 1;

% Comment while loop command (below) while computing stats required to set Threshold for each of 7 AUTs

while(File_Index<=41)

disp(File_Index);

load(strcat('Z_',char(File_Names(File_Index)),'_Selftest_T5.mat'));

% % Coefficients Belonging to AUT

Z1=Z((1:Dict_atoms),:);
Z2=Z((Dict_atoms+1:2*Dict_atoms),:);
Z3=Z(((2*Dict_atoms)+1:3*Dict_atoms),:);
Z4=Z(((3*Dict_atoms)+1:4*Dict_atoms),:);
Z5=Z(((4*Dict_atoms)+1:5*Dict_atoms),:);
Z6=Z(((5*Dict_atoms)+1:6*Dict_atoms),:);
Z7=Z(((6*Dict_atoms)+1:7*Dict_atoms),:);

DZ1 = D_CFL*Z1;
DZ2 = D_LCD_CPU*Z2;
DZ3 = D_LC*Z3;
DZ4 = D_PRJ*Z4;
DZ5 = D_PRT*Z5;
DZ6 = D_MFD*Z6;
DZ7 = D_BGN*Z7;

% %
for index=1:Num_test_samples
    Z1_norm(index) = norm(DZ1(:,index));
    Z2_norm(index) = norm(DZ2(:,index));
    Z3_norm(index) = norm(DZ3(:,index));
    Z4_norm(index) = norm(DZ4(:,index));
    Z5_norm(index) = norm(DZ5(:,index));
    Z6_norm(index) = norm(DZ6(:,index));
    Z7_norm(index) = norm(DZ7(:,index));
end

% % Basic Stats on sparse matrix

Z1_Stats = [median(Z1_norm); mean(Z1_norm); std(Z1_norm); max(Z1_norm); min(Z1_norm); prctile(Z1_norm,[10 15 25 75])';]';
Z2_Stats = [median(Z2_norm); mean(Z2_norm); std(Z2_norm); max(Z2_norm); min(Z2_norm); prctile(Z2_norm,[10 15 25 75])';]';
Z3_Stats = [median(Z3_norm); mean(Z3_norm); std(Z3_norm); max(Z3_norm); min(Z3_norm); prctile(Z3_norm,[10 15 25 75])';]';
Z4_Stats = [median(Z4_norm); mean(Z4_norm); std(Z4_norm); max(Z4_norm); min(Z4_norm); prctile(Z4_norm,[10 15 25 75])';]';
Z5_Stats = [median(Z5_norm); mean(Z5_norm); std(Z5_norm); max(Z5_norm); min(Z5_norm); prctile(Z5_norm,[10 15 25 75])';]';
Z6_Stats = [median(Z6_norm); mean(Z6_norm); std(Z6_norm); max(Z6_norm); min(Z6_norm); prctile(Z6_norm,[10 15 25 75])';]';
Z7_Stats = [median(Z7_norm); mean(Z7_norm); std(Z7_norm); max(Z7_norm); min(Z7_norm); prctile(Z7_norm,[10 15 25 75])';]';

Z_Stats = [Z1_Stats;Z2_Stats;Z3_Stats;Z4_Stats;Z5_Stats;Z6_Stats;Z7_Stats];

% Comment this section (below) while computing stats required to set Threshold for each of 7 AUTs

%% Threshold as Pert15
% Th_CFL = 0.002860657;
% Th_LCD_CPU = 0.003253666;
% Th_LC = 4.80E-04; % 
% Th_PRJ = 0.012245193;
% Th_PRT = 0.033601034; % 
% Th_MFD = 0.009228391;
% Th_BGN = 0.057739379; %


% % % Threshold as PERT10
Th_CFL = 0.003123252; % Pert25
Th_LCD_CPU = 0.003019443;
Th_LC = 5.55E-04; % Pert25
Th_PRJ = 0.011754595;
Th_PRT = 0.031525147; % 
Th_MFD = 0.00747196;
Th_BGN = 0.056696119; %


C1=0;C2=0;C3=0;C4=0;C5=0;C6=0;C7=0;
for index=1:Num_test_samples
    if(Z1_norm(index)>=Th_CFL)
        C1=C1+1;
    end
    if(Z2_norm(index)>=Th_LCD_CPU)
        C2=C2+1;
    end
    if(Z3_norm(index)>=Th_LC)
        C3=C3+1;
    end
    if(Z4_norm(index)>=Th_PRJ)
        C4=C4+1;
    end
    if(Z5_norm(index)>=Th_PRT)
        C5=C5+1;
    end
    if(Z6_norm(index)>=Th_MFD)
        C6=C6+1;
    end
    if(Z7_norm(index)>=Th_BGN)
        C7=C7+1;
    end
end

C = [C1;C2;C3;C4;C5;C6;C7];

% clearvars -except C D File_Index File_Names Num_classes Num_test_samples D_CFL D_LC D_PRJ D_LCD_CPU D_PRT D_MFD D_BGN Dict_atoms

D = [D , C];

File_Index = File_Index+1;

end

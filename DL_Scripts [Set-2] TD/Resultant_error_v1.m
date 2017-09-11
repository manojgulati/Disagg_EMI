clc;
clear all;
close all;

combined_testing_EMI_Dataset_2();

Num_classes = 7;
Num_test_samples = 3000;
Dict_atoms = 1000;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD'};
D = [];

File_Index = 1;

while(File_Index<=22)

disp(File_Index);

load(strcat('Z_',char(File_Names(File_Index)),'_Selftest_T1.mat'));

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

% % Selftest Threshold
Th_CFL = 0.000773121;
Th_LCD_CPU = 0.004604558;
Th_LC = 1.79E-04; %PERT15
Th_PRJ = 0.00429386;
Th_PRT = 0.00E+00; %PERT10
Th_MFD = 0.001345596;
Th_BGN = 0.000795484; %

% % % Crosstest Threshold
% Th_CFL = ;
% Th_LCD_CPU = ;
% Th_LC = ; %PERT15
% Th_PRJ = ;
% Th_PRT = ; %PERT10
% Th_MFD = ;
% Th_BGN = ; %


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

clearvars -except C D File_Index File_Names Num_classes Num_test_samples D_CFL D_LC D_PRJ D_LCD_CPU D_PRT D_MFD D_BGN Dict_atoms

D = [D , C];

File_Index = File_Index+1;

end

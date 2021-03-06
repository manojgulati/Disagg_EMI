clc;
clear all;
close all;

Num_classes = 4;
Num_test_samples = 800;
File_Names = {'CFL1','LCD_CPU1','LC1','PRJ1','CFL_PRJ1','LC_PRJ1','PRJ_CPU_LCD1','CFL_CPU_LCD1','CFL_LC1','LC_CPU_LCD1'};
D = [];

File_Index = 4;

% while(File_Index<=10)

disp(File_Index);

load(strcat('Z_',char(File_Names(File_Index)),'_Selftest_T2.mat'));

%% Coefficients Belonging to AUT

Z1=Z((1:1000),:);
Z2=Z((1001:2000),:);
Z3=Z((2001:3000),:);
Z4=Z((3001:4000),:);

% %
Z1_R = reshape(Z1,[1 800000]);
Z2_R = reshape(Z2,[1 800000]);
Z3_R = reshape(Z3,[1 800000]);
Z4_R = reshape(Z4,[1 800000]);

figure;
hist(Z1_R,50);
% xaxis([-0.1 0.4]);
set(gca,'xlim',[-0.002 0.005])

figure;
hist(Z2_R,50);
% xaxis([-0.1 0.4]);
set(gca,'xlim',[-0.002 0.005])

figure;
hist(Z3_R,50);
% xaxis([-0.1 0.4]);
set(gca,'xlim',[-0.002 0.005])

figure;
hist(Z4_R,50);
% xaxis([-0.1 0.4]);
set(gca,'xlim',[-0.002 0.005])

%%
for index=1:Num_test_samples
    Z1_norm(index) = norm(Z1(:,index));
    Z2_norm(index) = norm(Z2(:,index));
    Z3_norm(index) = norm(Z3(:,index));
    Z4_norm(index) = norm(Z4(:,index));
end

% % Basic Stats on sparse matrix

Z1_Stats = [median(Z1_norm); mean(Z1_norm); std(Z1_norm); max(Z1_norm); min(Z1_norm); prctile(Z1_norm,[25]);]';
Z2_Stats = [median(Z2_norm); mean(Z2_norm); std(Z2_norm); max(Z2_norm); min(Z2_norm); prctile(Z2_norm,[25]);]';
Z3_Stats = [median(Z3_norm); mean(Z3_norm); std(Z3_norm); max(Z3_norm); min(Z3_norm); prctile(Z3_norm,[25]);]';
Z4_Stats = [median(Z4_norm); mean(Z4_norm); std(Z4_norm); max(Z4_norm); min(Z4_norm); prctile(Z4_norm,[25]);]';

Z_Stats = [Z1_Stats;Z2_Stats;Z3_Stats;Z4_Stats];

% % Selftest Threshold
Th_CFL = 0.3949;
Th_LCD_CPU = 1.0270;
Th_LC = 0.8070;
Th_PRJ = 1.5537;

% % % Crosstest Threshold
% Th_CFL = 0.0013;
% Th_LCD_CPU = 0.0228;
% Th_LC = 0.0030;
% Th_PRJ = 0.0121;

C1=0;C2=0;C3=0;C4=0;
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
end

C = [C1;C2;C3;C4];

clearvars -except C D File_Index File_Names Num_classes Num_test_samples

D = [D , C];

File_Index = File_Index+1;

% end

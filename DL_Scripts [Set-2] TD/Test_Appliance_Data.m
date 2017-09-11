clc;
clear all;
close all;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD'};

for i = 1:7
   
display(i);

%load data samples 
load(strcat(char(File_Names(i)),'_TD_Dump.mat'));

% PRSG Code
range = 10000;

X =  randi([1 3000],1,range);
 
% % Data matrix
for index=1:range
    Signal_data(:,index)=M1(:,X(index));
end

% Signal_data=M1(1:525,:);

% % dictionary learning
[Dict,Z,J]=myDL_rand_init(Signal_data,50);

% % Lambda1 is initialised to be zero.
save(strcat(char(File_Names(i)),'_DL_Data_T4_1.mat'),'Dict','J','Z');

Z_norm = norm(Z)

end
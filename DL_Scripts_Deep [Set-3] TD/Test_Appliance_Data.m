clc;
clear all;
close all;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN'};

for i = 1:7
   
display(i);

%load data samples 
load(strcat(char(File_Names(i)),'_TD_Dump.mat'));

% Pseudo Random Sequence Generator Code
range = 10000;

X =  randi([1 3000],1,range);

% % Data matrix repear to make 10000 traces from 3000 traces
for index=1:range
    Signal_data(:,index)=M1(:,X(index));
end

% Signal_data=M1(1:525,:);

% % dictionary learning
% [Dict,Z,J]=myDL_rand_init(Signal_data,50);

N1 = 1000;
N2 = 500;
N3 = 100;

display('Stage-1');
[Dict_1,Z_1,J1]=myDL_rand_init(Signal_data,N1);
display('Stage-2');
[Dict_2,Z_2,J2]=myDL_rand_init(Z_1,N2);
display('Stage-3');
[Dict_3,Z_3,J3]=myDL_rand_init(Z_2,N3);

display('Combining Dictionaries');
Dict=Dict_1*Dict_2*Dict_3;

save(strcat(char(File_Names(i)),'_DDL_Data_T5.mat'),'Dict');

end
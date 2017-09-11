clc;
clear all;
close all;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN'};

for i = 1:1
   
display(i);

%load data samples 
load(strcat(char(File_Names(i)),'_FFT_Dump.mat'));

% % Convert Data in to dB scale
% ampY_dB = 10*log10(1000*((ampY_1.^2)/10^6));

% PRSG Code
range = 10000;

X =  randi([1 3000],1,range);
% 
% % Data matrix
for index=1:range
    Signal_data(:,index)=M1(1:525,X(index));
end

% Signal_data=M1(1:525,:);

% Signal_data_norm = (Signal_data - min(min(Signal_data)))/(max(max(Signal_data)) - min(min(Signal_data)));

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


save(strcat(char(File_Names(i)),'_DDL_Data_T4.mat'),'Dict');

Z_norm1 = norm(Z_1)
Z_norm2 = norm(Z_2)
Z_norm3 = norm(Z_3)

end
% %
% plot(J);
% xlabel('Time(sec)','FontSize', 12)
% ylabel('Frequency(Hz)','FontSize', 12)
% title('Convergence of objective function')
% xlabel('number of iterations')
% ylabel('objective function')
% 
% 
% %signal reconstruction to check the acuracy of the dictionary learnt 
% signal_rec=Dict_human*Z_human;
% 
% %normalised mean square error between original signal and reconstructed using dictionary
% nmse=norm((-signal_rec+signal_human_data),'fro')/norm(signal_human_data,'fro')*100;

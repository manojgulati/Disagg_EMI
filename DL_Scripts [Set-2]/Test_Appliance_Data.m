clc;
clear all;
close all;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD'};

for i = 1:7
   
display(i);

%load data samples 
load(strcat(char(File_Names(i)),'_FFT_Dump.mat'));

% % Convert Data in to dB scale
% ampY_dB = 10*log10(1000*((ampY_1.^2)/10^6));

% PRSG Code
range = 10000;

X =  randi([1 3000],1,range);
 
% % Data matrix
for index=1:range
    Signal_data(:,index)=M1(1:525,X(index));
end

% Signal_data=M1(1:525,:);

% Signal_data_norm = (Signal_data - min(min(Signal_data)))/(max(max(Signal_data)) - min(min(Signal_data)));

% % dictionary learning
[Dict,Z,J]=myDL_rand_init(Signal_data,1000);

% %

save(strcat(char(File_Names(i)),'_DL_Data_T2.mat'),'Dict','J','Z');

Z_norm = norm(Z)

end
%%
plot(J);
xlabel('Time(sec)','FontSize', 12)
ylabel('Frequency(Hz)','FontSize', 12)
title('Convergence of objective function')
xlabel('number of iterations')
ylabel('objective function')


%signal reconstruction to check the acuracy of the dictionary learnt 
signal_rec=Dict_human*Z_human;

%normalised mean square error between original signal and reconstructed using dictionary
nmse=norm((-signal_rec+signal_human_data),'fro')/norm(signal_human_data,'fro')*100;

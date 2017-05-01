clc;
clear all;
close all;

Path1 = 'CFL1_';

%load data samples 
load (strcat(Path1,'FFT_Dump.mat'));

% % Convert Data in to dB scale
% ampY_dB = 10*log10(1000*((ampY_1.^2)/10^6));

% PRSG Code
range = 3000;

X =  randi([1 100],1,range);

% % Data matrix
for index=1:range
    Signal_data(:,index)=ampY_1(1:525,X(index));
end

% Signal_data=ampY_1(1:525,:);

% Signal_data_norm = (Signal_data - min(min(Signal_data)))/(max(max(Signal_data)) - min(min(Signal_data)));

% % dictionary learning
[Dict,Z,J]=myDL_rand_init(Signal_data,50);

% %

save(strcat(Path1,'DL_Data_T15.mat'),'Dict','J','Z');

Z_norm = norm(Z)

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

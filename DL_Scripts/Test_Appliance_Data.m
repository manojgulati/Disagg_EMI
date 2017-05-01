clc;
clear all;
close all;

Path1 = 'PRJ1_';

%load data samples 
load (strcat(Path1,'reshaped_TD_Data.mat'));

%% Data matrix

Signal_data=Data_Scaled(:,1:800);

% Signal_data_norm = (Signal_data - min(min(Signal_data)))/(max(max(Signal_data)) - min(min(Signal_data)));

%dictionary learning
[Dict,Z,J]=myDL_rand_init(Signal_data,1000);

% %

save(strcat(Path1,'DL_Data_T2.mat'),'Dict','J','Z');

%%

figure;
imagesc(Data_Scaled)
colorbar;
% caxis([-0.045 0.035]);

%     Save figures
%     saveas(gcf,strcat(char(File_Names(index)),'_Dict_1024x1000','.png'));
%     close all;

%%


A1 = min(min(Data_Scaled))

A2 = max(max(Data_Scaled))










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

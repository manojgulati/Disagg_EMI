clc;
clear all;
close all;

%load human data samples 
load ('data_SH');

%human data matrix

signal_human_data=data_human_sideways(:,1:150);

%dictionary learning
[Dict_human,Z_human,J]=myDL_rand_init(signal_human_data,2000);

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

clc;
clear all;
close all;

%%
load('Simulated_Results.mat');

plot(log10(f),Amplitude,'b--*');
xlabel('Frequency [in log10(Hz)]');
ylabel('Amplitude (in dB)');
ylim([-50 -10]);

saveas(gcf,strcat('Simulated_Transfer_Function.png'));

%%

F_meas = [10*10^3 25*10^3 50*10^3 100*10^3 500*10^3 1*10^6 5*10^6 10*10^6];

Amplitude_meas = [-100 -89.49 -83.5 -77.85 -63.60 -57.57 -45.66 -42.6];

plot(log10(F_meas),Amplitude_meas,'r--*');
xlabel('Frequency [in log10(Hz)]');
ylabel('Amplitude (in dBm)');
ylim([-110 -30]);
saveas(gcf,strcat('Measured_Transfer_Function.png'));



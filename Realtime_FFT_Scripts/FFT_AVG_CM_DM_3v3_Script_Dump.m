% Matlab code for computing Frequency Spectrum of Common Mode and Differential Mode components of Conducted EMI
% Manoj Gulati
% IIIT-D
% This script is used to generate averaged FFTs for Journal/Sensys draft
% DOM: 25-09-2015

% clear all previously stored variables
clear all;
close all;
clc;

Path1 = './CFL_Test [RAW PS]/';
Path2 = 'Plots/';
Path3 = 'Data/';

loadContent=dir(strcat(Path1,'*.csv'));
No_of_files = size(loadContent,1);
No_of_traces = No_of_files;
%%
offset = 0;
% while(offset<=No_of_files)

for i=1:No_of_traces
    M1(:,:,i) = dlmread(strcat(Path1,loadContent(i+offset,1).name),'');
end

for i = 1:No_of_traces
    % Fetch content for Channel-1 (Vdm)
    y1(:,i)  = M1(:,1,(i));
    % Fetch content for Channel-2 (Earth)
    y2(:,i)  = M1(:,2,(i));
end

% Adding offset as precribed by redpitaya wiki after measurement data collected using 50 ohm termination. 
% This will be added to compensate for avg. noise captured by AFE of Redpitaya when terminated with matched load.
% Default value is 75 and 28
y1  = y1 + 99;
y2  = y2 + 126;

% Scaling factor for digital to analog conversion of ADC values.
% Resolution = 2*Vp/2^14 i.e. 2*1.079V/16384 = 0.0001317 
y1=y1*0.000131;
y2=y2*0.000131;

% Configuration Parameters
fs = 15.625*(10^6);  %sample frequency in Hz
T  = 1/fs;        %sample period in s
L  = 16384;       %signal length
t  = (0:L-1) * T; %time vector

% Dummy signals for testing algorithm (uncomment to verify FFT computation)
% f1 = 5*10^6;
% f2 = 10*10^6;
% y1 = 5*sin(2*pi*f1*t)+10*sin(2*pi*f2*t);%test signal
% y2 = 5*sin(2*pi*f1*t)-10*sin(2*pi*f2*t);%test signal

% Plot time domain data
% plot(y1(1:16384),'r');
% hold on;
% plot(y2(1:16384),'b');

% Paragraph Break

% Initialising null vectors to store EMI samples
ampY_1 = zeros(L/2+1,No_of_traces);
ampY_2 = zeros(L/2+1,No_of_traces);

% Loop to compute FFT over 100 traces of EMI
for i = 1:No_of_traces
    % Computing spectrum for Differential Mode EMI 
    Y1(:,i)  = fft(y1(:,i))/L;
    % Computing spectrum for Common Mode EMI 
    Y2(:,i)  = fft(y2(:,i))/L;
    % Computing magnitude of Vdm and Vcm for length L/2
    ampY_1(:,i) = 2*abs(Y1(1:L/2+1,i));
    ampY_2(:,i) = 2*abs(Y2(1:L/2+1,i));
%     ampY_1(:,i) = 2*(Y1(1:L/2+1,i));
%     ampY_2(:,i) = 2*(Y2(1:L/2+1,i));

end
% % Dump FFT Data

% Computing f vector for length fs/2
f = fs/2*linspace(0,1,L/2+1);

% save(strcat(Path2,'FFT_Dump','.mat'),'ampY_1','f');


% % Integrating the amplitude over 100 traces for averaging
AmpY_1 = sum(ampY_1,2);
AmpY_2 = sum(ampY_2,2);
% Averaging over 100 traces
AmpY_1 = AmpY_1/No_of_traces;
AmpY_2 = AmpY_2/No_of_traces;



%% Paragraph Break

% % Plotting Complete FFT Spectrum for CM and DM EMI
% Points = 8192;
f1 = f/1000000;
% 
% figure;
%Plot spectrum.
figure;
% figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'Color','w');  %Make the figure background white
% subplot(2,1,1);
plot(f1,10*log10(1000*((AmpY_1.^2)/10^6)),'b');
% set(gca,'xlim',[0 5]);
ylabel('Amplitude|dBm|');
title(strcat('Amplitude Spectrum of EMI'));
% legend('Current Sense Resistor');
ylim([-150 -90]);
% ylim([0 0.5e-6]);
xlim([0.001 1]);
grid on;

% subplot(2,1,2);
% plot(f1,10*log10(1000*((AmpY_2.^2c)/10^6)),'r');
% % semilogx(f1,10*log10(1000*((AmpY_2.^2)/10^6)),'b');
% % set(gca,'xlim',[0 5]);
% ylabel('Amplitude|dBm|');
% xlabel('Frequency (MHz)');
% legend('Wide-band CT');
% ylim([-150 -90]);
% % ylim([0 0.5e-11]);
% xlim([0.01 5]);
% % legend('CM[10 ohm]','CM[100 ohm]','CM[1 kohm]');
% grid on;

% Function to plot as per IEEE publication specifications in 4 formats eps, fig, PDF and png
% saveas(gcf,strcat('Plot_',Path2,'_Mains','_Analyze_X1_','.png'));




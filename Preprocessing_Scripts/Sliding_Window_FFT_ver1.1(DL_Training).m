% This script is meant to compute FFT on real time EMI data collected using 
% Redpitaya and timestamped with UTC.
% Manoj Gulati
% IIIT-Delhi
% DOI: 19th Dec, 2015
% DOM: 21st Dec, 2015

clc;
clear all;
close all;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

file_ind = 23;

while(file_ind<=41)

Path1 = './PRT_PRT_PRJ/';
Path2 = 'Plots/';
Path3 = 'Data/';
Path4 = 'FFT_Dump/';

loadContent=dir(strcat('./',char(File_Names(file_ind)),'/','*.csv'));
No_of_files_actual = size(loadContent,1);
No_of_files = 3010;
No_of_traces = 1;
% %
offset = 0;
while(offset<=No_of_files)

for i=1:No_of_traces
    M1(:,:,i) = dlmread(strcat('./',char(File_Names(file_ind)),'/',loadContent(i+offset,1).name),'');
end

for i=1:No_of_traces
    % Fetch content for Channel-1 (Vdm)
    y1(:,i)  = M1(:,1,i);
    % Fetch content for Channel-2 (Earth)
    y2(:,i)  = M1(:,2,i);
end

% Adding offset as precribed by redpitaya wiki after measurement data collected using 50 ohm termination.
% This will be added to compensate for avg. noise captured by AFE of Redpitaya when terminated with matched load.
% Default value is 75 and 28
y1  = y1 + 75;
y2  = y2 + 92;

% Scaling factor for digital to analog conversion of ADC values.
% Resolution = 2*Vp/2^14 i.e. 2*1.079V/16384 = 0.0001317 
y1=y1*0.000131;
y2=y2*0.000131;

% Configuration Parameters
% fs = 1.953125*(10^6);  %sample frequency in Hz
fs = 15.625*(10^6);  %sample frequency in Hz
del_t  = 1/fs;        %sample period in s
L  = 16384;       %signal length
t  = (0:L-1) * del_t; %time vector
T = L*del_t; % Total time of measurement
del_f = 1/T; % Min. Freq. resolution (in Hz)

% Initialising null vectors to store EMI samples
ampY_1 = zeros(L/2,No_of_traces);
ampY_2 = zeros(L/2,No_of_traces);

% Loop to compute FFT over 100 traces of EMI
for i = 1:No_of_traces
    % Computing spectrum for Differential Mode EMI 
    Y1(:,i)  = fft(y1(:,i))/L;
    % Computing spectrum for Common Mode EMI 
    Y2(:,i)  = fft(y2(:,i))/L;
    % Computing magnitude of Vdm and Vcm for length L/2
    ampY_1(:,i) = (Y1(1:L/2,i));
    ampY_2(:,i) = (Y2(1:L/2,i));
end

% % Integrating the amplitude over 10 traces for averaging
% AmpY_1 = sum(ampY_1,2);
% AmpY_2 = sum(ampY_2,2);
% % Averaging over 10 traces
% AmpY_1 = AmpY_1/No_of_traces;
% AmpY_2 = AmpY_2/No_of_traces;

% Computing f vector for length fs/2
f = (fs/2-1/T)*linspace(0,1,L/2);

% Plotting Complete FFT Spectrum for CM and DM EMI
Points = 8192;
f1 = f/1000000;

% Plot Spectrum
% set(gcf,'Color','w');  %Make the figure background white
% subplot(2,1,1);
% plot(f1,10*log10(1000*((AmpY_1.^2)/10^6)),'r');
% ylabel('|Y-CM|(dBm)');
% title(strcat('Amplitude Spectrum of EMI'));
% legend('CM EMI');
% ylim([-145 -35]);
% yticks = -145:15:-35;
% set(gca,'YTick',yticks);
% xlim([0.01 5]);
% grid on;
% hold on;
% 
% subplot(2,1,2);
% plot(f1,10*log10(1000*((AmpY_2.^2)/10^6)),'b');
% yticks = -145:15:-35;
% set(gca,'YTick',yticks);
% ylim([-145 -35]);
% xlim([0.01 5]);
% ylabel('|Y-DM|(dBm)');
% xlabel('Frequency (MHz)');
% legend('DM EMI');
% grid on;

% display('Check1:');
% display(i);
% display('Check2:');
display(i-No_of_traces+offset+1);

% Function to plot as per IEEE publication specifications in 4 formats eps, fig, PDF and png
% ConvertPlot4Publication(strcat(Path1,Path2,'FFT_X5_',loadContent(i-No_of_traces+offset+1,1).name),'height',4, 'width',6,'fontsize', 10, 'fontname', 'Times New Roman', 'samexaxes', 'on','linewidth',0.5,'pdf','off','eps','off','psfrag','off','fig','off');
% close all;

% CM_Data = 10*log10(1000*((AmpY_1.^2)/10^6));
CM_Data = ampY_1;
% DM_Data = 10*log10(1000*((AmpY_2.^2)/10^6));

% Write timestamp with all averaged FFT traces to get index of missing values
Timestamp = round(str2num(loadContent(i-No_of_traces+offset+1,1).name(1:end-4)));

% Store averaged FFT data as mat files
save(strcat('./',char(File_Names(file_ind)),'/',Path4,loadContent(i-No_of_traces+offset+1,1).name,'.mat'),'CM_Data','Timestamp');  % function form
% clear variables
clear CM_Data;
clear DM_Data;
clear AmpY_1;
clear AmpY_2;

offset = offset+1;
end

display(File_Names(file_ind));


file_ind = file_ind+1;

end


% Plotting script showing spectrogram of averaged EMI data and Time-domain 
% power data combined
% Manoj Gulati
% IIIT-Delhi
% DOI: 22st Dec, 2015
% DOM: 2nd Jan, 2016

clc;
clear all;
close all;
format long g;

% Path for Averaged FFT data 
Path1 = './LC-BGN/';
Path4 = '';
Path2 = 'Data/';
Path3 = 'Processed_EMI/';

% Path for Smart meter data 
Path5 = strcat(Path1,'Smart_Meter_Data/');
Path6 = '01-June-2017.csv';
% Path6 = '30-May-2017.csv';

% Load averaged and preprocessed FFT data
load(strcat(Path1,Path4,Path3,'Processed_EMI','.mat'));

% Load smart meter data collected from EM6400
M2 = importdata(strcat(Path5,Path6));
[x1] = M2(:,1);
[x2,y2] = unique(round(M2(:,1)));

fs = 15.625*(10^6);  %sample frequency in Hz
del_t  = 1/fs;        %sample period in s
L  = 16384;       %signal length
t  = (0:L-1) * del_t; %time vector
T = L*del_t; % Total time of measurement
del_f = 1/T; % Min. Freq. resolution (in Hz)
% Computing f vector for length fs/2
f = (fs/2-1/T)*linspace(0,1,L/2);
f1 = f/1000000;

%% Print start and end timestamp of FFT data
clc;
display('Start TS:');
display(TS_Vector_Required(1));
display('End TS:');
display(TS_Vector_Required(end));

%%
% Timestamp for time domain and frequency domain plot
start_time = TS_Vector_Required(1);
end_time = TS_Vector_Required(end);
time_slot = end_time - start_time+1;
% clc;

% find vector of time domain data
x_begin = find(x2 == start_time);
x_end = find(x2 == end_time);

EMI_duration = size(M1_Updated,2);

%% Plot spectrogram using stacked FFT data retrived from averaged FFT frames
% figure;
% figure('units','normalized','outerposition',[0 0 1 1]);
t_axis = [1:EMI_duration];

ah1 = subplot(3,1,1);
% ax=gca;
plot([1:EMI_duration],M2(y2(x_begin+1:x_begin+EMI_duration),3));
xlim([1  EMI_duration]);
xlabel('Time (in seconds)','FontSize',12);
ylabel('Real Power (W)','FontSize',12);
grid on;

ah2 = subplot(3,1,2);
plot([1:EMI_duration],M2(y2(x_begin+1:x_begin+EMI_duration),4));
xlim([1  EMI_duration]);
xlabel('Time (in seconds)','FontSize',12);
ylabel('Reactive Power (VAR)','FontSize',12);
grid on;

ah3 = subplot(3,1,3);
x_lim = t_axis;
imagesc(x_lim,f1(1:1500),M1_Updated(1:1500,:));
% set(gca, 'YTickLabel',[f1(1:5244)]);
xlabel('Time (in seconds)','FontSize',12);
ylabel('Frequency (in MHz)','FontSize',12);
h = colorbar;
caxis([-150 -90])
ylabel(h, 'Amplitude (dBm)','FontSize',12);

% grid on;

% find current position [x,y,width,height]
pos3 = get(ah3,'Position');
pos2 = get(ah2,'Position');
pos1 = get(ah1,'Position');
% set width of second axes equal to first
pos2(3) = pos1(3);
pos3(3) = pos1(3);

set(ah2,'Position',pos2)
set(ah3,'Position',pos3)


% Function to plot as per IEEE publication specifications in 4 formats eps, fig, PDF and png
% ConvertPlot4Publication(strcat(Path1,'Spectrogram_TD_COMB'),'width',3,'fontsize', 10, 'fontname', 'Times New Roman', 'samexaxes', 'on','linewidth',0.5,'pdf','off','eps','off','psfrag','off','fig','off');
% saveas(gcf,strcat(Path1,'Spectrogram_TD_COMB_visualize','.png'));

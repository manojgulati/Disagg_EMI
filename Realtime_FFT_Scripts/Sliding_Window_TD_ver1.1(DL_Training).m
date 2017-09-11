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

file_ind = 41;

while(file_ind<=41)

Path1 = './CFL_CPU/';
Path2 = '/';
Path3 = 'Data/';
Path4 = 'TD_Dump/';

loadContent=dir(strcat('./',char(File_Names(file_ind)),Path2,'*.csv'));
No_of_files_actual = size(loadContent,1);
No_of_files = 3002;
No_of_traces = 1;

n_factor = 31; % Downsampling factor

offset = 0;
while(offset<=No_of_files)

for i=1:No_of_traces
    M1(:,:,i) = dlmread(strcat('./',char(File_Names(file_ind)),Path2,loadContent(i+offset,1).name),'');
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
% fs = 15.625*(10^6);  %sample frequency in Hz
% del_t  = 1/fs;        %sample period in s
% L  = 16384;       %signal length
% t  = (0:L-1) * del_t; %time vector
% T = L*del_t; % Total time of measurement
% del_f = 1/T; % Min. Freq. resolution (in Hz)

% Initialising null vectors to store EMI samples
ampY_1 = downsample(y1,n_factor);
ampY_2 = downsample(y2,n_factor);


display(i-No_of_traces+offset+1);


CM_Data = ampY_1;

% Write timestamp with all averaged FFT traces to get index of missing values
Timestamp = round(str2num(loadContent(i-No_of_traces+offset+1,1).name(1:end-4)));

% Store averaged FFT data as mat files
save(strcat('./',char(File_Names(file_ind)),Path2,Path4,loadContent(i-No_of_traces+offset+1,1).name,'.mat'),'CM_Data','Timestamp');  % function form
% clear variables
clear CM_Data;
clear ampY_1;


offset = offset+1;
end


file_ind = file_ind+1;

end


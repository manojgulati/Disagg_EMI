% This script is meant to compute 2D Spectrogram using stacked FFT data.
% It takes averaged FFT data in mat file format
% Manoj Gulati
% IIIT-Delhi
% DOI: 21st Dec, 2015
% DOM: 21st Dec, 2015

clc;
clear all;
close all;

Path1 = '/Users/manojgulati/Databin/MSMT1_20NOV/EMI_Data/';
Path2 = 'Data/';

loadContent=dir('/Users/manojgulati/Databin/MSMT1_20NOV/EMI_Data/Data/*.mat');
No_of_files = size(loadContent,1);
fs = 15.625*(10^6);  %sample frequency in Hz
L  = 16384;       %signal length
% Computing f vector for length fs/2
f = fs/2*linspace(0,1,L/2+1);
f1 = f/1000000;
%%
clc;
for i=1:No_of_files
    load(strcat(Path1,Path2,loadContent(i,1).name));
    M1(:,i) = CM_Data;
    clear CM_Data;
end

%%
clc;
% Plot spectrogram using stacked FFT data retrived from averaged FFT frames
xlim = linspace(1,No_of_files,100);
imagesc(xlim,f1,M1);
xlabel('Time (in seconds)');
ylabel('Frequency (in MHz)');
colorbar;





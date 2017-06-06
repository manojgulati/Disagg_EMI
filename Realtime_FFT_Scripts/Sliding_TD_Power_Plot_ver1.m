% This script is meant to compute 2D Spectrogram using stacked FFT data.
% It takes averaged FFT data in mat file format
% Manoj Gulati
% IIIT-Delhi
% DOI: 21st Dec, 2015
% DOM: 25th Dec, 2015

clc;
clear all;
close all;
format long g;

Path1 = '/Users/manojgulati/Databin/MSMT_25Dec/CFL/Smart_Meter_Data/';
% Path2 = 'Data/';

M1 = importdata(strcat(Path1,'25-December-2015.csv'));

%%
[x1] = M1(:,1);
[x,y] = unique(round(M1(:,1)));

%%
ax=gca;
plot(unique(round(M1(y,1)))/1000000,M1(y,3));
% xlim([1448.022267 1448.022667]);
ax.XTicklabel = [UTC_to_IST(min(x)) UTC_to_date(max(x))];

% Matlab code for reshaping TD EMI Data 
% This will be used for learning dictionaries
% Manoj Gulati
% IIIT-D
% DOM: 23-02-2017

% clear all previously stored variables
clear all;
close all;
clc;

Path2 = 'LC_CPU_LCD1_';
File_Path = strcat(Path2);

No_of_traces = 100;
CM_EMI_Index = 1;
Data_Load = [];

for index = 1:No_of_traces
    M1(:,:)=importdata(strcat(File_Path,int2str(index),'.csv'));
    % Reshape data for DL
    M_reshaped = reshape(M1(:,CM_EMI_Index),[1024,16]); 
    Data_Load = [Data_Load, M_reshaped];
end

%% Scaling factor for offset correction and ADC conversion

Data_preScale  = Data_Load + 99;
Data_Scaled = Data_preScale*0.000131;
%
save(strcat(Path2,'reshaped_TD_Data.mat'),'Data_Scaled');

%% Plot 2-D TD data

imagesc(Data_Scaled);
colorbar;
caxis([-0.0050 0.0035]);

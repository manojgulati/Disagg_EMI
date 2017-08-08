clc;
clear all;
close all;
format long g;


%% Load timestamp indices for fetching smart meter data

% Path for Averaged FFT data 
Path1 = './PRT_PRT_MFD/';
Path4 = '';
Path2 = 'Data/';
Path3 = 'Processed_EMI/';

% Path for Smart meter data 
Path5 = strcat(Path1,'Smart_Meter_Data/');
Path6 = '06-August-2017.csv';

% Load averaged and preprocessed FFT data
% load(strcat(Path1,Path4,Path3,'Processed_EMI','.mat'));

loadContent=dir(strcat(Path1,'*.csv'));
No_of_files_actual = size(loadContent,1);
No_of_files = 3000;
No_of_traces = 1;
%
offset = 1;
while(offset<=No_of_files)

X = strsplit(loadContent(offset).name,'.');

index(offset) = str2double(X(1));

offset = offset+1;

end
index_unique = unique(index)';

% Load smart meter data collected from EM6400
M2 = importdata(strcat(Path5,Path6));
[x1] = M2(:,1);
[x2,y2] = unique(round(M2(:,1)));

for t = 1:length(index_unique)
    test(t) = find(x2==index_unique(t));
end

% Fetch real power values from smart meter dump
real_power_unique = M2(y2(test),3)';

% Make a power dataset having 3000 power values for 300 seconds of EMI data
for p = 1:3000
    slot = find(index_unique==index(p));
    real_power(p) = real_power_unique(slot);
end






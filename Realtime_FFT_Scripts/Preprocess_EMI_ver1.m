% Preprocessing script to fill in missing values in EMI data with
% interpolated data points

% Manoj Gulati
% IIIT-Delhi
% DOI: 28th Dec, 2015
% DOM: 1st Jan, 2016

clc;
clear all;
close all;
format long g;

% Path for Averaged FFT data 
Path1 = './PRT_PRT_MFD/';
Path4 = '';
Path2 = 'Data/';
Path3 = 'Processed_EMI/';

% Load averaged FFT data in to 2D matrix M1 having rows specifying frequency 
% range and columns showing time duration of data measurements.
loadContent=dir(strcat(Path1,Path4,Path2,'*.mat'));
No_of_files = size(loadContent,1);
TS_Vector = [];
% %

for i=1:No_of_files
    load(strcat(Path1,Path4,Path2,loadContent(i,1).name));
    M1(:,i) = CM_Data;
    TS_Vector = [TS_Vector; Timestamp];
    clear CM_Data;
    clear Timestamp;
end


% Store start and end time of EMI data
Start_time = TS_Vector(1);
End_time = TS_Vector(end);
% Store original Timestamp vector in a secondary variable
TS_Vector_Original = TS_Vector;


% indices to unique values in column 3
[~, ind] = unique(TS_Vector);
% duplicate indices
duplicate_ind = setdiff(1:size(TS_Vector), ind);
% duplicate values
duplicate_value = TS_Vector(duplicate_ind);

% Delete duplicated columns from EMI data and Timestamp vector
M1_Unique = M1(:,setdiff(1:size(M1,2),[duplicate_ind]));
TS_Vector = TS_Vector(setdiff(1:size(TS_Vector),[duplicate_ind]));
M1_Backup = M1_Unique;

% Compute Interpolation required for filling missing EMI data
TS_Vector_Required = [Start_time:1:End_time]';

% Find indices where data is missing
missing_values = setdiff(TS_Vector_Required,TS_Vector);

% %

M1_Updated = M1_Unique;

% loop to fill in missing EMI data frames 
for value = 1:size(missing_values,1)
    target = find(TS_Vector_Required == missing_values(value));
    source = target-1;
    
    M1_Updated = [M1_Updated(:,1:target-1) M1_Updated(:,source) M1_Updated(:,target:end)];   
end


% % Store processed EMI FFT data as mat file
save(strcat(Path1,Path4,Path3,'Processed_EMI','.mat'),'M1_Updated','TS_Vector_Required');



clc;
clear all;
close all;

Path1 = 'PRJ';
Path2 = '-BGN'
Path4 = '/FFT_Dump/';
Path5 = 'Combined_FFT_Dump/';

loadContent=dir(strcat('./',Path1,Path2,Path4,'*.csv.mat'));
No_of_files = size(loadContent,1);
No_of_traces = 3000;
% %

ST_Index = 1;
ET_Index = 3000;

loadContent(ST_Index).name

loadContent(ET_Index).name


% %
for i=1:No_of_traces
    load(strcat(Path1,Path2,Path4,loadContent(i,1).name),'');
    M1(:,i) = CM_Data;
    clear CM_Data;
end
% %
% save(strcat(Path1,Path5,'CFL_MFD','_FFT_Dump','.mat'),'M1');  % function form
save(strcat('./',Path1,'_FFT_Dump','.mat'),'M1');  % function form


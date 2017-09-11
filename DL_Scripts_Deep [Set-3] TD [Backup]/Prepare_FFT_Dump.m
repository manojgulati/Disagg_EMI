clc;
clear all;
close all;

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

file_ind = 23;

while(file_ind<=41)

Path1 = 'BGN';
Path2 = '/';
Path4 = '/TD_Dump/';
Path5 = 'Combined_FFT_Dump/';

loadContent=dir(strcat('./',char(File_Names(file_ind)),Path2,Path4,'*.csv.mat'));
No_of_files = size(loadContent,1);
No_of_traces = 3000;
% %

ST_Index = 1;
ET_Index = 3000;

loadContent(ST_Index).name

loadContent(ET_Index).name

% %
for i=1:No_of_traces
    load(strcat('./',char(File_Names(file_ind)),Path2,Path4,loadContent(i,1).name),'');
    M1(:,i) = CM_Data;
    clear CM_Data;
end
% %
% save(strcat(Path1,Path5,'CFL_MFD','_FFT_Dump','.mat'),'M1');  % function form
save(strcat('./',char(File_Names(file_ind)),'_TD_Dump','.mat'),'M1');  % function form

file_ind = file_ind+1;

end


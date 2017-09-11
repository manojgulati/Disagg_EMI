clc;
clear all;
close all;
tic

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

% AUT_names = {'CFL','CPU','LC','PRJ','PRT','MFD','Frequency_Combos'};

load Actual_Test_Cases

File_Index = 1;
TPR_Stats = zeros(41,1);
FPR_Stats = zeros(41,1);

while(File_Index<=41)
    disp(File_Names(File_Index));

    if(File_Index==23||File_Index==29||File_Index==7)
        disp('test');
        File_Index = File_Index+1;
        continue
    end

    load(strcat(char(File_Names(File_Index)),'_DR_0.mat'));
    
    if(isempty(TPR)||isempty(FPR))
        File_Index = File_Index+1;
        continue
    end
    
    % Fetch TPR stats for all cases
    TPR_Stats(File_Index,1) = TPR;
    FPR_Stats(File_Index,1) = FPR;

    clear TPR; clear FPR; 

    File_Index = File_Index+1;

end

U = [TPR_Stats,FPR_Stats];

dlmwrite(strcat('Disagg_Results_',num2str(0),'.csv'),U,'-append');

toc
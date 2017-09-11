clc;
close all
clear all

Path1 = 'MFD';

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

AUT_names = {'CFL','CPU','LC','PRJ','PRT','MFD'};

File_Index = 8;

while(File_Index<=8)

disp(File_Index);

load(strcat(char(File_Names(File_Index)),'_SM_Data'));
load(strcat('Class_labels_',char(File_Names(File_Index)),'_T5'));
load('Appliance_Info');

% %
num_cases=1;
count = struct;
% Appliance_Combination = [];

for i=1:num_cases
    T = [1*C1(i) 2*C2(i) 3*C3(i) 4*C4(i) 5*C5(i) 6*C6(i)];
    K = nonzeros(T)'
    Emeas = real_power(i)
    tol = 0.1;
    [Appliance_Combo_output,Energy_Consumed_output,Error_output]=Disaggregation_FUNC(K,Emeas,tol)
    ncase = size(Appliance_Combo_output,1);
    
    Appliance_Combination=zeros(ncase,6);
    
    for t = 1:ncase
        Appliance_Combination(t,K) = Appliance_Combo_output(t,:);
    end
    count(i).value = Appliance_Combination;
    count(i).Energy_output = Energy_Consumed_output;
    count(i).Error = Error_output;

    clear Appliance_Combo_output
    clear Appliance_Combination
end

% clc;

% Compute Disagg Statistics on computed counts for each appliance category
% A1 = zeros(num_cases,6);
% for t=1:num_cases
%     for AUT = 1:6
%             A1(t,AUT) = count(t).value(1,AUT);
% %             disp(t);
%     end
% end
% 
% Disagg_Stats = A1;
% 
% Resultant_Sum = sum(Disagg_Stats);
% 
% Disagg_Stats_New = [Disagg_Stats; Resultant_Sum];

% Dump count structure and disaggregation stats
% save(strcat(char(File_Names(File_Index)),'_Disagg_Results.mat'),'Disagg_Stats','count');

% Dump this data in to csv with a header
% fmt = repmat('%s,', 1, length(AUT_names));
% fmt(end:end+1) = '\n';
% txt = sprintf(fmt, AUT_names{:});
%    
% fid = fopen(strcat(char(File_Names(File_Index)),'_Disagg_Results1.csv'), 'w');
% fprintf(fid, fmt, AUT_names{:});
% fclose(fid);
% 
% dlmwrite(strcat(char(File_Names(File_Index)),'_Disagg_Results1.csv'),Disagg_Stats_New,'-append');

File_Index = File_Index+1;

end

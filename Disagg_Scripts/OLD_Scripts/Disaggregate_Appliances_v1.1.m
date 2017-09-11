clc;
close all
clear all

tic

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

AUT_names = {'CFL','CPU','LC','PRJ','PRT','MFD','OCC','Energy','Error'};

File_Index = 1;

while(File_Index<=1)
disp('File_Index:');
disp(File_Index);

load(strcat(char(File_Names(File_Index)),'_SM_Data'));
load(strcat('Class_labels_',char(File_Names(File_Index)),'_T5'));
load('Appliance_Info');

% %
num_cases=3000;
count = struct;
% Appliance_Combination = [];
unique_rows = [0 0 0 0 0 0];
unique_occ = 0;
E_Output = 0;
Err_Output = 0;
for i=1:num_cases
%     disp('Num_Case:');
%     disp(i);
    T = [1*C1(i) 2*C2(i) 3*C3(i) 4*C4(i) 5*C5(i) 6*C6(i)];
%     K = nonzeros(T)';
    K = [1 2 3 4 5 6];
    
    Emeas = real_power(i);
    tol = 0.1;
    [Appliance_Combo_output,Energy_Consumed_output,Error_output]=Disaggregation_FUNC(K,Emeas,tol);
    ncase = size(Appliance_Combo_output,1);
    
    Appliance_Combination=zeros(ncase,6);
    
    for t = 1:ncase
        Appliance_Combination(t,K) = Appliance_Combo_output(t,:);
    end
    count(i).value = Appliance_Combination;
    count(i).Energy_output = Energy_Consumed_output;
    count(i).Error = Error_output;

    check = ismember(Appliance_Combination,unique_rows,'rows');
    
    if(nonzeros(check)>=1)
%         display('Test Check-1');
        for ind=1:size(unique_rows,1)
            flag = ismember(Appliance_Combination,unique_rows(ind,:),'rows');
            unique_occ(ind) = unique_occ(ind)+sum(flag);
            E_Output(ind) = (E_Output(ind)+sum(Energy_Consumed_output(flag)))/(size(nonzeros(flag),1)+1);
            Err_Output(ind) = (Err_Output(ind)+sum(Error_output(flag)))/(size(nonzeros(flag),1)+1);
        end
    else
        unique_occ(size(unique_rows,1)+1:size(Appliance_Combination,1)+size(unique_rows,1)) = 1;
        unique_rows = [unique_rows; Appliance_Combination];
        E_Output = [E_Output; Energy_Consumed_output];
        Err_Output = [Err_Output; Error_output];
    end
    
    clear Appliance_Combo_output
    clear Appliance_Combination
end

clc;
% Dump count structure and disaggregation stats
% save(strcat(char(File_Names(File_Index)),'_Disagg_Results.mat'),'count','unique_occ','unique_rows','E_Output','Err_Output');

% Dump this data in to csv with a header
fmt = repmat('%s,', 1, length(AUT_names));
fmt(end:end+1) = '\n';
txt = sprintf(fmt, AUT_names{:});
   
fid = fopen(strcat(char(File_Names(File_Index)),'_Disagg_Results.csv'), 'w');
fprintf(fid, fmt, AUT_names{:});
fclose(fid);

% Combined Disaggregation Stats
U = [unique_rows,unique_occ',E_Output,Err_Output];

dlmwrite(strcat(char(File_Names(File_Index)),'_Disagg_Results.csv'),U,'-append');

File_Index = File_Index+1;

end

toc

% Shobha Sundar Ram
% Indraprastha Institute of Information Technology Delhi
% August 22 2017
% Generating all the possible disaggregated results combinations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;
tic

File_Names = {'CFL','CPU','LC','PRJ','PRT','MFD','BGN','CFL_CPU','CFL_LC','CFL_PRJ','CFL_PRT','CFL_MFD','CPU_LC','CPU_PRJ','CPU_PRT','CPU_MFD','LC_PRJ','LC_PRT','LC_MFD','PRJ_PRT','PRJ_MFD','PRT_MFD','CFL_CPU_LC','CFL_CPU_PRJ','CFL_CPU_PRT','CFL_CPU_MFD','CFL_LC_PRJ','CFL_LC_PRT','CFL_LC_MFD','CFL_PRJ_PRT','CPU_LC_PRJ','CPU_LC_PRT','CPU_LC_MFD','CPU_PRJ_PRT','LC_PRJ_PRT','PRJ_PRT_MFD','CFL_CFL_CFL','CPU_CPU_PRJ','CPU_CPU_MFD','PRT_PRT_PRJ','PRT_PRT_MFD'};

AUT_names = {'CFL','CPU','LC','PRJ','PRT','MFD','Frequency_Combos'};

load Actual_Test_Cases

File_Index = 30;

while(File_Index<=41)

disp(File_Names(File_Index));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASES - WITH EMI DATA AND WITHOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% With EMI Data
% case_id = 1; 
% Without EMI Data
case_id = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DETECTION RESULTS FROM EMI SENSOR
% I have made it a [1x6] binary vector that shows 1 in 
% ith position if appliance i is present 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obtain 3000 traces
Num_traces = 3000;
% Load the detection results
switch(case_id)
    case 1
        % Load the detection results for 3000 traces
        load(strcat('Class_labels_',char(File_Names(File_Index)),'_T5'));
        C = C';
        % Detect_results = randint(Num_traces,6);
        Detect_results = C(1:Num_traces,1:6);
        % Detect_results = [1 1 0 1 1 0];
    case 0
        Detect_results = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD SMART RESULTS IN WATTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the smart meter data
% a = 160; b = 190; 
% Emeas = a + (b-a).*rand(Num_traces,1);
% Emeas = 180*ones(Num_traces,1);
load(strcat(char(File_Names(File_Index)),'_SM_Data'));
Emeas = real_power';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DISAGGREGATION CATEGORIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the disaggregation categories
s = load('Disaggregate_Cat');
A_Perm = s.A_Perm;
numPerm = s.numPerm;
Results_Counter = zeros(numPerm,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPECIFY TOLERANCE LIMITS FOR DISAGGREGATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tol_input = 0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRAPPER CODE FOR DISAGGREGATION ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 1:Num_traces
    switch(case_id)
        case 1
            % Obtain detection results for each trace
            Detect_results_trace = Detect_results(t,:);
            % Obtain class labels of detected appliances
            K_input = find(Detect_results_trace == 1);
        case 0
            K_input = 1:6;
    end
    
  % Obtain smart meter measurement for each trace
  Emeas_input = Emeas(t,:);
  % Obtain disaggregated output
  [Appliance_Combo_output,Energy_Consumed_output,Error_output]=Disaggregation_FUNC(K_input,Emeas_input,tol_input);
  if sum(sum(Appliance_Combo_output)) == 0
      % If disaggregation fails, then zero appliances are detected. This
      % result can eventually be ignored
      Results_Counter(1) = Results_Counter(1)+1;
  else
      % These are all the possible disaggregated outputs that have been
      % identified to be within the specified tolerance limit
      size_App_Combo = size(Appliance_Combo_output);
      for n = 1:size_App_Combo(1)
           App_Combo_mat = repmat(Appliance_Combo_output(n,:),[numPerm,1]);
           Diff_mat = sum(abs(App_Combo_mat - A_Perm),2);
           [minVal minInd]= min(Diff_mat);
           % Update the frequency counter for each disaggregated category
           Results_Counter(minInd) = Results_Counter(minInd)+1;
      end
      % Compute FPR for each of these test cases
      Temp = ismember(Appliance_Combo_output,Actual_Test_Cases(File_Index,:),'rows');
      FPR_Stats(t) = sum(Temp)/size_App_Combo(1);
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS FOR ALL THE TRACES FOR EACH CATEGORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
non_zero_Ind = find(Results_Counter~=0);
Dis_Combos = A_Perm(non_zero_Ind,:);
Frequency_Combos = Results_Counter(non_zero_Ind);

% Dump this data in to csv with a header
% fmt = repmat('%s,', 1, length(AUT_names));
% fmt(end:end+1) = '\n';
% txt = sprintf(fmt, AUT_names{:});
%    
% fid = fopen(strcat(char(File_Names(File_Index)),'_Disagg_Results_',num2str(case_id),'.csv'), 'w');
% fprintf(fid, fmt, AUT_names{:});
% fclose(fid);
% 
% % Combine Disaggregation Stats
% U = [Dis_Combos, Frequency_Combos];
% 
% dlmwrite(strcat(char(File_Names(File_Index)),'_Disagg_Results_',num2str(case_id),'.csv'),U,'-append');

% Find frequency of appropriate combination
[a b] = ismember(Dis_Combos,Actual_Test_Cases(File_Index,:),'rows');

Dis_Combos(find(b),:)
TD = Frequency_Combos(find(b),:)

% Sort Disaggregated Combinations
[Freq_sorted,Indices] = sort(Frequency_Combos,'descend')
Dis_Combos_Sorted = Dis_Combos(Indices,:)

% Compute True Positive Rate
TPR = TD/30

% Compute False Positive Rate
% FPR = (sum(Frequency_Combos)-TD)/(287*30)
FPR = sum(FPR_Stats)/3000

save(strcat(char(File_Names(File_Index)),'_DR_',num2str(case_id),'.mat'),'Dis_Combos_Sorted','TPR','FPR','Freq_sorted');

File_Index = File_Index+1;

end
toc


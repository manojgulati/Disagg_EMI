clc;
close all;
clear all;


Y = randn(100,6);

AUT_names = {'CFL','CPU','LC','PRJ','PRT','MFD'};

% Dump this data in to csv with a header
% dlmwrite('Hello_World.csv',AUT_names,'-append');

fmt = repmat('%s,', 1, length(AUT_names));
fmt(end:end+1) = '\n';
txt = sprintf(fmt, AUT_names{:});
   
fid = fopen('Hello_World.csv', 'w');
fprintf(fid, fmt, AUT_names{:});
fclose(fid);

dlmwrite('Hello_World.csv',Y,'-append');

%         for k=1:6
%         count(i,k)=length(find(Appliance_Combo_output==k));
%         end
%%
clc;

% Find max number of possible combinations for each test case
for i=1:3000
    A(i) = size(count(i).value,1);
end

max(A)

log_data = find(A(:)==2);

%% For Fetching first set of combinations

[Fetch_unique_rows, ia, ic] = unique(A1,'rows');

for k=1:size(Fetch_unique_rows,1)
    log(k)=length(find(ic==k));
end

%% Load second set of possible combinations
A2 = [];
for index = 1:size(log_data)
    A2(index,:) = count(log_data(index)).value(2,:);
end

[Fetch_unique_rows_2, ia_2, ic_2] = unique(A2,'rows');

for k=1:size(Fetch_unique_rows_2,1)
    log_2(k)=length(find(ic_2==k));
end

%%
clear all;
clc;

M=[];
H = [1 2 3;];
T2 = [100; 80];
% H=[0 0 0];
T = [1 2 3; 3 4 5; 1 2 3; 4 5 6; 7 8 9; 1 2 3; 1 2 3; 3 4 5];
T1 = [20; 30; 40; 10; 20; 30; 40; 50];
unique_occ = 0;

out = ismember(T,H,'rows')
% sum(out)
% nonzeros(out)
size(H,1)

if(nonzeros(out)>=1)
    display('Test');
    for i=1:size(H,1)
        flag = ismember(T,H(i,:),'rows')
        unique_occ(i) = sum(flag)
        T2(i) = (T2(i)+sum(T1(flag)))/(size(nonzeros(flag),1)+1)
    end
end




clc;
clear all;

load PRT_SM_Data;

num_traces = 3000;

index_range = 300;

offset = 0;

for i=1:index_range
    A(i,:) = real_power(1+offset:10+offset);
    offset = offset+10;
end
%% Compute maximum of each EMI bin using histogram
close all
T = [];
for i=1:index_range
    [counts,centers] = hist(A(i,:),10);
    Z = [];
    Z = centers(find(counts==max(counts)));
    T(i) = Z(1,1);
    disp(i)
end

% %
plot(T)
% grid on;
xlabel('Time');
ylabel('Power(Watts)');


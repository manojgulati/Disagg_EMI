clc;
close all;
% clear all;

format long e

% load CFL_CPU_LC_SM_Data


Start_TS = 1501853695;
Stop_TS = 1501854299;

[x2,y2] = unique(round(VarName1(:,1)));

x_begin = find(x2 == Start_TS);
x_end = find(x2 == Stop_TS);


%%
plot(VarName3(y2(x_begin+1:x_end)));
grid on;

% xlabel('Time (100ms)');
xlabel('Time (second)');
ylabel('Power (Watts)');




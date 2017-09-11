clc;

clear all;
close all;


% Generate pseudo SM data
xmin=18;
xmax=22;
n=3000;
real_power=xmin+rand(1,n)*(xmax-xmin);

save('CFL_T5_SM_Data.mat','real_power');




plot(real_power)




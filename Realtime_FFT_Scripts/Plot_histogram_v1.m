clc;
close all;


% x = Z1_norm;

nbins = 10;

% hist(Z1_norm,[0:0.001:0.013],'r'); 
% hold on;
hist(Z1_norm,[0:0.001:0.013],'b'); 

% [c,x] = hist(x,nbins);
% bar(x,c,0.5)

ylim([0 3000]);
grid on;
ylabel('Frequency');
% xlabel('norm[X]');












clc;
close all;


% x = Z1_norm;

% nbins = 10;
% 
% % hist(Z1_norm,[0:0.001:0.013],'r'); 
% % hold on;
% % hist(Z1_norm,[0:0.001:0.013],'b'); 
% h=hist(Z1_norm,'BinWidth',5); 
% 
% % [c,x] = hist(x,nbins);
% % bar(x,c,0.5)
% 
% xlabel('norm[X]');

% % New Histogram PLot [17-08-2017]
% clear all;

x = Z3_norm;

max(x)
min(x)

% bin_range = -1:0.001:.5; % Old range for testing purposes

bin_range = 0:0.001:0.08;
bin_counts = histc(x,bin_range);

figure
bar(bin_range,bin_counts,'histc');

ylim([0 2000]);
grid on;
ylabel('Frequency');













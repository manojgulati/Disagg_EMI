clc;
% clear all;
close all;

% M = csvread('Measured Transfer Function - Sheet1.csv',,);

%% Log scale of frequency

plot(log10(Frequencyf(1:8)),MeasuredAmplitudedBm(1:8),'r--*');
hold on;
plot(log10(Frequencyf(9:16)),MeasuredAmplitudedBm(9:16),'b--*');
plot(log10(Frequencyf(17:24)),MeasuredAmplitudedBm(17:24),'c--*');
plot(log10(Frequencyf(25:32)),MeasuredAmplitudedBm(25:32),'g--*');
plot(log10(Frequencyf(33:40)),MeasuredAmplitudedBm(33:40),'k--*');
grid on;
xlabel('Frequency Log10(f) Hz');
ylabel ('Amplitude (in dBm)');
legend('Vin(Vpp)=10V','Vin(Vpp)=8V','Vin(Vpp)=6V','Vin(Vpp)=4V','Vin(Vpp)=2V');

%%
saveas(gcf,strcat('Measured_Transfer_Function_logscale.png'));

%% Linear Scale
close all;
Frequency = Frequencyf/1000000;
plot(Frequency(1:8),MeasuredAmplitudedBm(1:8),'r--*');
text( Frequency(33:40), MeasuredAmplitudedBm(33:40), [num2str(Frequency(33:40))],'HorizontalAlignment','left','VerticalAlignment','top');
hold on;
plot(Frequency(9:16),MeasuredAmplitudedBm(9:16),'b--*');
plot(Frequency(17:24),MeasuredAmplitudedBm(17:24),'c--*');
plot(Frequency(25:32),MeasuredAmplitudedBm(25:32),'g--*');
plot(Frequency(33:40),MeasuredAmplitudedBm(33:40),'k--*');
grid on;
xlim([-1 15]);
set(gca,'XTick',[-1:1:15])
% set(gca,'XTick',[0.01,0.05,0.1,0.5,1,5,10,15,16])
ylim([-100 -35]);
xlabel('Frequency (in MHz)');
ylabel ('Amplitude (in dBm)');
legend('Vin(Vpp)=10V','Vin(Vpp)=8V','Vin(Vpp)=6V','Vin(Vpp)=4V','Vin(Vpp)=2V');

%% Linear scale

saveas(gcf,strcat('Measured_Transfer_Function_linearscale.fig'));




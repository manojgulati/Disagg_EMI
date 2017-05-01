% Matlab code for computing Frequency Spectrum of Common Mode and Differential Mode components of Conducted EMI
% Manoj Gulati
% IIIT-D
% DOC: 05-12-2016
% DOM1: NA

clc;
clear all;
close all;

%%
Fs = 15.625*10^6; % Sampling Freq
del_T = 1/Fs; % time interval b/w two time samples
L = 16384; % Length of signal
T = (0:L-1)*del_T; % Total time

% Load EMI Data
for k=1:100
    M1(:,:) = load(strcat('BGN1_',num2str(k),'.csv'));
    % Fetch content for Channel-1
    y1(:,k)  = M1(:,1);
    % Fetch content for Channel-2
    y2(:,k)  = M1(:,2);
    clear M1; %M1 = [];
end

%% Simulate a sine wave at three different frequencies
% S = 0.7*sin(2*pi*50*T)+ (1)*sin(2*pi*120*T) + (0.8)*sin(2*pi*400*T);

% Make a dummy signal with 100 traces
% S_Dum = zeros(1000,100);
% for i=1:100
%     S_Dum(:,i) =  S;
% end
% % Plot Time Domain Signal
% close all;
% plot(T,S,'r');

%% Convert digitised data from ADC in to equivalent analog values
% Adding offset as precribed by redpitaya wiki after measurement data collected using 50 ohm termination. 
% This will be added to compensate for avg. noise captured by AFE of Redpitaya when terminated with matched load.
% Default value is 75 and 28
ch1_offset=113;
ch2_offset=145;

y1  = y1 + ch1_offset;
y2  = y2 + ch2_offset;

% Scaling factor for digital to analog conversion of ADC values.
% Resolution = 2*Vp/2^14 i.e. 2*1.079V/16384 = 0.0001317 
% y1=y1*(1.3171*10^-4);
% y2=y2*(1.3171*10^-4);
y1=y1*0.000131;
y2=y2*0.000131;

%% Run FFT Function

for j=1:100
    Y1_FFT(:,j)= fftshift(fft(y1(:,j))); 
    Y2_FFT(:,j)= fftshift(fft(y2(:,j))); 
    
    Y1_ABS(:,j) = 2*abs(Y1_FFT(:,j)/L);
    Y2_ABS(:,j) = 2*abs(Y2_FFT(:,j)/L);
end
%% Take average of computed FFT signal
Y1_AVG = sum(Y1_ABS')/100;
Y2_AVG = sum(Y2_ABS')/100;


%% Plot FFT Data
close all;

% Generate Frequency Vector
% f = Fs*((-L/2):(L/2-1))/L;
f = Fs*(0:(L/2-1))/L;

D1 = Y1_AVG(L/2+1:end);
D2 = Y2_AVG(L/2+1:end);
D1_Log = 10*log10(1000*((D1.^2)/10^6));
D2_Log = 10*log10(1000*((D1.^2)/10^6));

figure;
subplot(2,1,1);
plot(f,D1_Log,'b');
xlim([10*10^3 5*10^6]);
subplot(2,1,2);
plot(f,D2_Log,'r');
xlim([10*10^3 5*10^6]);

title('100 traces of sine wave')
xlabel('f (Hz)')
ylabel('|P1(f)|')

















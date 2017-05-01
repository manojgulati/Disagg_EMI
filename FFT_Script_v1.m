clc;
clear all;
close all;

%%
Fs = 1000; % Sampling Freq
del_T = 1/Fs; % time interval b/w two time samples
L = 1000; % Length of signal
T = (0:L-1)*del_T; % Total time

% Simulate a sine wave at three different frequencies
S = 0.7*sin(2*pi*50*T)+ (1)*sin(2*pi*120*T) + (0.8)*sin(2*pi*400*T);

% Make a dummy signal with 100 traces
S_Dum = zeros(1000,100);
for i=1:100
    S_Dum(:,i) =  S;
end

%% Plot Time Domain Signal
close all;
plot(T,S,'r');

%% Run FFT Function

for j=1:100
    Y(:,j)= fftshift(fft(S_Dum(:,j))); 
    P1(:,j) = 2*abs(Y(:,j)/L);
end
% Take average of computed FFT signal
P2 = sum(P1');
P3 = P2/100;

% Generate Frequency Vector
f = Fs*((-L/2):(L/2-1))/L;

%% Plot FFT Data
plot(f,P2,'b');
hold on;
plot(f,P3,'r--*')
title('100 traces of sine wave')
xlabel('f (Hz)')
ylabel('|P1(f)|')

















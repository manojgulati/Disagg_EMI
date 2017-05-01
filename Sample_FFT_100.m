clc;
clear all;
Fs = 1000;
T = 1/Fs;
L = 1000;
t = (0:L-1)*T;
for i = 0:99
    S(:,i+1) = (0.7*i)*sin(2*pi*(50+i)*t) + (i)*sin(2*pi*(120+i)*t) + (0.8*i)*sin(2*pi*(400+i)*t);
    Y(:,i+1)= fftshift(fft(S(:,i+1))); 
    P1(:,i+1) = 2*abs(Y(:,i+1)/L);
end
%P2 = abs(Y/L)
%P1 = P2(1:L/2+1);
%P1(2:end-1) = 2*P1(2:end-1);
%f = Fs*((0:L/2))/L;
f = Fs*((-L/2)+1:(L/2))/L;
plot(f,P1(:,100))
title('100 traces of sine wave')
xlabel('f (Hz)')
ylabel('|P1(f)|')

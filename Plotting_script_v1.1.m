clear all;
clc;
close all;

F_meas = [10*10^3 25*10^3 50*10^3 100*10^3 500*10^3 1*10^6 5*10^6 10*10^6];

Amplitude_meas = [-100 -89.49 -83.5 -77.85 -63.60 -57.57 -45.66 -42.6];

for i=1:8
    P_out(i) = 10^(Amplitude_meas(i)/10)*(10^-3);
    V_out(i) = sqrt(P_out(i)/100);
end

V_out_db = 20*log10(V_out/10);

plot(log10(F_meas),V_out_db,'r--*');
xlabel('Frequency [in log10(Hz)]');
ylabel('Amplitude (in dB)');
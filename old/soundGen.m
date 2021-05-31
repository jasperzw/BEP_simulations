source_mag = 300;     % [Pa]

f = 2e3:5:6.5e3;
Ts = 8.9e-3;
t_array = linspace(0,Ts,length(f));
STSS = source_mag*sin(2*pi*f.*t_array);
fc = round(1/t_array(2));

filename = 'STSS.wav';

samples = 1;
STSStotal = [];

for i = 1:samples
    STSStotal = [STSStotal STSS]; 
end


STSStotal = resample(STSStotal, 48e3, fc);
STSStotal = STSStotal ./ max(abs(STSStotal));

audiowrite(filename,STSStotal,48e3);

test = audioread('STSS.wav')
%Fs = 48e3;
Fs = fc
test = STSS
L = length(test);
Y = fft(test);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
%soundsc(STSStotal,fc)
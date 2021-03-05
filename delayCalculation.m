function [a] = delayCalculation(sensor_input)
%DELAYCALCULATION calculates fourier delay
%
% perform as fast fourier transform to get the phase delay of the highest
% amplitude frequency which is in the domain.
nmics = length(sensor_input(:,1));

for i = 1:nmics
   Y = fft(sensor_input(i,:));
   L = length(sensor_input(i,:));
   P2 = abs(Y/L);
   P1 = P2(1:L/2+1);
   P1(2:end-1) = 2*P1(2:end-1);
   
   P4 = Y
   P3 = P4(1:L/2+1);
   index = find(P1==max(P1))
   
   a(i) = P3(index)
end
end


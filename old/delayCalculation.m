function [a, response] = delayCalculation(sensor_input, index)
%DELAYCALCULATION calculates fourier delay
%
% perform as fast fourier transform to get the phase delay of the highest
% amplitude frequency which is in the domain.



% find the amount of microphones in array
nmics = length(sensor_input(:,1));

for i = 1:nmics
   %peform fast fourier
   Y = fft(sensor_input(i,:));
   %get the length of samples
   L = length(sensor_input(i,:));

   %take only one side of the spectrum and multiple by 2 as to count for
   %the other spectrum side
   P2 = abs(Y/L);
   P1 = P2(1:L/2+1);
   P1(2:end-1) = 2*P1(2:end-1);
   
   %find the frequency with the fundamental frequency
   P4 = Y
   P3 = P4(1:L/2+1);

   %get the phases
   a(i,1) = angle(P3(index))
   if(i ~= 1)
    a(i,1) = exp(-j*(a(i,1)-a(1,1)))
   end
end

a(1,1) = 1
M = 1/(a'*a)
response = 0
for i = 1:nmics
Y = fft(sensor_input(i,:))
L = length(Y)

Y(1:L/2) = Y(1:L/2)*a(i)'*(1/M)
Y(L/2+1:end) = Y(L/2+1:end)*a(i)*(1/M)

finish = real(ifft(Y))
response = response + finish
end
end


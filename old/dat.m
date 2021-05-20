
angles = []

for i = 1:length(measurementsSimulation)/2
   m = i*2-1;
   angles = [angles; measurementsSimulation(m+1,:)*100];
end

% y = [0 -15 -30 -45 -60 -75 -90]
% plot(y,angles)
% legend("inclination error","azimuth error","rotation error")
% title("angle error at inclination")
% xlabel("inclination degrees")
% ylabel("error in degrees")
% ylim([-5 5])

y = [5 7 9 11 13 15]
stem(y,angles)
%legend("location error")
title("Error of location estimation")
xlabel("distance")
ylabel("error (cm)")
xlim([4.5 15.5])
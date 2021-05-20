% load 'data/sunFlowerArray.mat'
% inclination = pi/4;
% azimuth = 0;
% 
% inclination = inclination+pi/2; %the actual array is orthogonal to direction vector
% 
% r_x = [[1 0 0];[0 cos(inclination) -sin(inclination)];[0 sin(inclination) cos(inclination)]];
% r_z = [[cos(azimuth) -sin(azimuth) 0]; [sin(azimuth) cos(azimuth) 0]; [0 0 1]];
sunFlowerArray = receivers(1).arrayPattern-receivers(1).arrayPattern(1,:);

for i = 1:length(sunFlowerArray)
   %sunFlowerArray(i,:) = (r_z*r_x*sunFlowerArray(i,:)')';
   plot3([0 sunFlowerArray(i,1)],[0 sunFlowerArray(i,2)], [0 sunFlowerArray(i,3)])
   hold all
end

xlabel("x-axis")
ylabel("y-axis")
zlabel("z-axis")
xlim([-0.1 0.1])
ylim([-0.1 0.1])
zlim([-0.1 0.1])
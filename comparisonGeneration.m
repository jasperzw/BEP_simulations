
azimuthSet = linspace(0,pi/2,200) %azimuth is form [-pi/2 pi/2] but we only take one half
inclinationSet = linspace(0,pi*2,500)
r = 1;
medium_speed = 340

load sunFlowerArray.mat

resultStorage = [];

for inclination = inclinationSet
    azimuthStorage = [];
   for azimuth = azimuthSet
       x = r*cos(inclination)*sin(azimuth);
       y = r*sin(inclination)*sin(azimuth);
       z = r*cos(azimuth);

       waveVector = [x y z];
       delaySet = zeros(length(sunFlowerArray),1);
       for i = 1:length(sunFlowerArray)
          microphoneVector = sunFlowerArray(i,:)-sunFlowerArray(1,:);
          wm = dot(waveVector,microphoneVector);
          delaySet(i) = wm/medium_speed;
       end
       azimuthStorage = [azimuthStorage steeringStorage(delaySet)];
   end
   resultStorage = [resultStorage; azimuthStorage];
end

save("comparison.mat","resultStorage")
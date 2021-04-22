
azimuthSet = 0:pi/200:pi/2; %azimuth is form [-pi/2 pi/2] but we only take one half
inclinationSet = 0:pi/200:pi*2;
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

%load t.mat;
errorStorage = zeros(size(resultStorage));
display("going to error calculation")

for i = 1:size(resultStorage,1)
   for k = 1:size(resultStorage,2)
       error = t(:,4)-resultStorage(i,k).delaySet;
       error = sum(abs(error));
       errorStorage(i,k) = error;
   end
end

[row col] = find(errorStorage == min(min(errorStorage)))
resultAzimuth = (180/pi)*azimuthSet(col)
resultInclination = (180/pi)*inclinationSet(row)

figure
mesh(errorStorage)
xlabel("index of azimuth")
ylabel("index of inclination")
zlabel("absolute error")
delayArray = zeros(1,length(sunFlowerArray))
middle = sunFlowerArray(1,:)

for i = 1:length(sunFlowerArray)
   x = xcorr(STSS,readOut(i,:));
   steps = find(x==max(x));
   delayArray(i) = steps*t_array(2);
end

delayArray = delayArray - delayArray(1)
waveVector = zeros(length(sunFlowerArray),3)

for i = 2:length(sunFlowerArray)
    distanceVector = sunFlowerArray(i,:)-sunFlowerArray(1,:);
    distance = sqrt(sum(distanceVector.^2))
    distanceWave = (delayArray(i)*medium_speed); 
    angle = asind(distanceWave/distance)
    
    waveVector(i,:) = distanceVector*sind(angle)
end


finalVector = sum(waveVector)+sunFlowerArray(1,:)
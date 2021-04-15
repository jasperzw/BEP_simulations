
middle = sunFlowerArray(1,:)

t = zeros(length(sunFlowerArray),length(sources));

for nmbSource = 1:length(sources)
delayArray = zeros(1,length(sunFlowerArray))
for i = 1:length(sunFlowerArray)
   x = xcorr(STSS,readOut(i+(nmbSource-1)*length(sunFlowerArray),:));
   %steps = find(x==max(x));
   steps = find(readOut(i+(nmbSource-1)*length(sunFlowerArray),:)>10,1);
   %steps = find(x>10^6,1)
   delayArray(i) = steps*t_array(2);
end

delayArray = delayArray;
t(:,nmbSource) = delayArray';
end

waveVector = zeros(length(sunFlowerArray),3)

for i = 2:length(sunFlowerArray)
    distanceVector = sunFlowerArray(i,:)-sunFlowerArray(1,:);
    distance = sqrt(sum(distanceVector.^2))
    distanceWave = (delayArray(i)*medium_speed); 
    angle = asind(distanceWave/distance)
    
    waveVector(i,:) = distanceVector*sind(angle)
end


finalVector = sum(waveVector)+sunFlowerArray(1,:)

subplot(3,1,1)
scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,1), 'filled')
axis image
title("First source")
subplot(3,1,2)
scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,1), 'filled')
axis image
title("Second source")
subplot(3,1,3)
scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,3), 'filled')
axis image
title("Third source")
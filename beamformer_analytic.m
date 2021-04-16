
middle = sunFlowerArray(1,:)

t = zeros(length(sunFlowerArray),length(sources));

for nmbSource = 1:length(sources)
delayArray = zeros(1,length(sunFlowerArray))
for i = 1:length(sunFlowerArray)
   x = xcorr(STSS,readOut(i+(nmbSource-1)*length(sunFlowerArray),:));
   steps = find(x>10^4);
   steps = -y(steps(end));
   %steps = find(readOut(i+(nmbSource-1)*length(sunFlowerArray),:)>10,1);
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
    angleVector = asind(distanceWave/distance)
    
    waveVector(i,:) = distanceVector*sind(angleVector)
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

Y = fft(readOut(1,:));
Fs = 1/(t_array(2));
L = length(Y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure
subplot(2,1,1)
x = xcorr(STSS,readOut(1,:))
plot(y,x)
xlim([-6e3 0])
subplot(2,1,2)
plot(STSS)
hold all
plot(readOut(1,:))
xlim([0 6e3])
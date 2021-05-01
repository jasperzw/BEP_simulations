
middle = sunFlowerArray(1,:);

t = zeros(length(sunFlowerArray),length(sources));

for nmbSource = 1:length(sources)
delayArray = zeros(1,length(sunFlowerArray));
for i = 1:length(sunFlowerArray)
    [x y] = xcorr(readOut(i+(nmbSource-1)*length(sunFlowerArray),:),STSS);
    index = find(y==0)
    x = x(index:end);
    [pks loc] = findpeaks(x);
    highest = maxk(pks,4);
    index = length(highest);
    for f = 1:length(highest)
    index(f) = find(x == highest(f));
    end

    steps = min(index);

   %steps = find(x>10^5);
   %steps = -y(steps(end));
   %steps = find(readOut(i+(nmbSource-1)*length(sunFlowerArray),:)>10,1);
   %steps = find(x>10^6,1)
   delayArray(i) = steps*t_array(2);
end

%delayArray = delayArray;
t(:,nmbSource) = delayArray';
end
t_u = t; 
t = t-t(1,:)
% 
% waveVector = zeros(length(sunFlowerArray),3);
% temp = zeros(length(sunFlowerArray),5);
% array2d = [sunFlowerArray(:,1)-receiver_x sunFlowerArray(:,2)-receiver_y]
% 
% for i = 2:length(sunFlowerArray)
%     distanceVector = array2d(i,:);
%     a = sqrt(sum(distanceVector.^2))
%     b = (t(i,4)*medium_speed); 
%     angleV = asin(b/a);
%     temp(i,1) = angleV;
%     z = tan(angleV)*a;
%     temp(i,2) = z;
%     angleVector = [-distanceVector/norm(distanceVector) angleV];
%     temp(i,3:5) = angleVector
%     %angleVector = angleVector/norm(angleVector);
%     waveVector(i,:) = angleVector;
% end
% 
% %finalVector = sum(waveVector)
% finalVector = [mean(waveVector(:,1)) mean(waveVector(:,2)) mean(waveVector(:,3))]
% %finalVector = finalVector/norm(finalVector);
% finalAngleXY = atand(finalVector(2)/(finalVector(1)))
% finalAngleZ = atand(finalVector(3)/sqrt(finalVector(1)^2+finalVector(2)^2))
% 
% figure
% for i = 2:length(sunFlowerArray)
%    plot3([0 waveVector(i,1)],[0 waveVector(i,2)],[0 waveVector(i,3)])
%    hold all
% end
% 
% figure
% subplot(4,1,1)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,1), 'filled')
% axis image
% title("First source")
% subplot(4,1,2)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,2), 'filled')
% axis image
% title("Second source")
% subplot(4,1,3)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,3), 'filled')
% axis image
% title("Third source")
% subplot(4,1,4)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, t(:,4), 'filled')
% axis image
% title("Fourth source")
% 
% figure
% scatter(array2d(:,1),array2d(:,2))
% hold all
% scatter(finalVector(1),finalVector(2))
% 
% % Y = fft(readOut(1,:));
% % Fs = 1/(t_array(2));
% % L = length(Y);
% % P2 = abs(Y/L);
% % P1 = P2(1:L/2+1);
% % P1(2:end-1) = 2*P1(2:end-1);
% % 
% % figure
% % f = Fs*(0:(L/2))/L;
% % plot(f,P1) 
% % title('Single-Sided Amplitude Spectrum of X(t)')
% % xlabel('f (Hz)')
% % ylabel('|P1(f)|')
% % 
% % figure
% % subplot(2,1,1)
% % x = xcorr(STSS,readOut(1,:))
% % plot(y,x)
% % xlim([-6e3 0])
% % subplot(2,1,0)
% % plot(STSS)
% % hold all
% % plot(readOut(1,:))
% % xlim([0 6e3])
function [t_u d angleStorage] = beamformer_analytic(sunFlowerArray,sources,readOut,STSS,t_array)
middle = sunFlowerArray(1,:);

t = zeros(length(sunFlowerArray),length(sources));
d = zeros(length(sunFlowerArray),length(sources));

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
   delayArray(i) = steps;
end

%delayArray = delayArray;
d(:,nmbSource) = delayArray';
t(:,nmbSource) = delayArray'*t_array(2);
end
t_u = t; 
t = t-t(1,:)

load data/comparison.mat

errorStorage = zeros(size(resultStorage));
display("going to error calculation")

angleStorage = zeros(2,length(sources))

for m = 1:length(sources)
    for i = 1:size(resultStorage,1)
       for k = 1:size(resultStorage,2)
           error = t(:,m)-resultStorage(i,k).delaySet;
           error = sum(abs(error));
           errorStorage(i,k) = error;
       end
    end

    [row col] = find(errorStorage == min(min(errorStorage)))
    resultAzimuth = (180/pi)*azimuthSet(col)
    resultInclination = (180/pi)*inclinationSet(row)
    angleStorage(1,m) = resultAzimuth;
    angleStorage(2,m) = resultInclination;
end

% figure
% mesh(errorStorage)
% xlabel("index of azimuth")
% ylabel("index of inclination")
% zlabel("absolute error")
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

end
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
% % subplot(2,1,2)
% % plot(STSS)
% % hold all
% % plot(readOut(1,:))
% % xlim([0 6e3])



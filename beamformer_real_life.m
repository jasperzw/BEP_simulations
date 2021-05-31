function [t_u d angleStorage errorStorage] = beamformer_real_life(sunFlowerArray,sources,readOut,STSS,sensivity,fs)
middle = sunFlowerArray(1,:);

t = zeros(length(sunFlowerArray),length(sources));
d = zeros(length(sunFlowerArray),length(sources));

for nmbSource = 1:length(sources)
delayArray = zeros(1,length(sunFlowerArray));
for i = 1:length(sunFlowerArray) 
    [x y] = xcorr(readOut(i+(nmbSource-1)*length(sunFlowerArray),:),STSS);
    pos = find(y>=0,1);
	x = x(pos:end);
    s = std(x)*sensivity;
    f = x(find(x>s));
    c = findpeaks(f);
    m = find(x==c(1));
   steps = m;
   delayArray(i) = steps;
end

%delayArray = delayArray;
d(:,nmbSource) = delayArray';
t(:,nmbSource) = delayArray'/fs;
end
t_u = t; 
t = t-t(1,:);

load data/comparison.mat;

errorStorage = zeros(size(resultStorage));
display("going to error calculation");

angleStorage = zeros(2,length(sources));

for m = 1:length(sources)
    for i = 1:size(resultStorage,1)
       for k = 1:size(resultStorage,2)
           error = t(:,m)-resultStorage(i,k).delaySet;
           error = sum(abs(error));
           errorStorage(i,k) = error;
       end
    end

    [row col] = find(errorStorage == min(min(errorStorage)),1);
    resultAzimuth = (180/pi)*azimuthSet(col);
    resultInclination = (180/pi)*inclinationSet(row);
    angleStorage(1,m) = resultAzimuth;
    angleStorage(2,m) = resultInclination;
end


end




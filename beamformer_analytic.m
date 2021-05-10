function [t_u d angleStorage errorStorage] = beamformer_analytic(sunFlowerArray,sources,readOut,STSS,t_array)
middle = sunFlowerArray(1,:);

t = zeros(length(sunFlowerArray),length(sources));
d = zeros(length(sunFlowerArray),length(sources));

for nmbSource = 1:length(sources)
delayArray = zeros(1,length(sunFlowerArray));
for i = 1:length(sunFlowerArray)
    [x y] = xcorr(readOut(i+(nmbSource-1)*length(sunFlowerArray),:),STSS);
    index = find(y==0);
    x = x(index:end);
    [pks loc] = findpeaks(x);
    highest = maxk(pks,4);
    index = length(highest);
    for f = 1:length(highest)
    index(f) = find(x == highest(f),1);
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

    [row col] = find(errorStorage == min(min(errorStorage)));
    resultAzimuth = (180/pi)*azimuthSet(col);
    resultInclination = (180/pi)*inclinationSet(row);
    %angleStorage(1,m) = resultAzimuth;
    %angleStorage(2,m) = resultInclination;
end

end




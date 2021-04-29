trueDelay = zeros(length(receivers),length(sources));
trueAngleStorage = zeros(length(receivers)*2,length(sources));

for i = 1:length(receivers)
    for m = 1:length(sources)
    f = (i-1)*2+1;
    vector = sources(m).position-receivers(i).arrayPattern(1,:)'
    trueDelay(i,m) = norm(vector)/340;
    azimuth = 90+atand(vector(3)/sqrt(vector(1)^2+vector(2)^2));
    inclination = atand(vector(2)/vector(1));
    if inclination<=0
        inclination = inclination+360;
    end
    trueAngleStorage(f,m) = azimuth;
    trueAngleStorage(f+1,m) = inclination;
    end
end

temp = finalAngleStorage-trueAngleStorage;
temp = abs(temp);
temp = mean(temp,2);

totalMean = [temp(1)+temp(3) temp(2)+temp(4)]
totalMean = totalMean/2
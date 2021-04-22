storage = zeros(length(sunFlowerArray),length(sources))
i=1

for i = 1:length(sunFlowerArray)
    for y = 1:length(sources)
       disVector = sunFlowerArray(i,:)' - sources(y).position;
       dis = sqrt(sum(disVector.^2))
       delay = dis/medium_speed;
       storage(i,y) = delay;
    end
end
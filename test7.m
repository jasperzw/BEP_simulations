load test.mat;

answer = directionVector*0.3

SetA = squeeze(finalDirection(1,:,:));
SetB = squeeze(finalDirection(2,:,:));

SetA = ones(size(squeeze(finalDirection(1,:,:))));
SetA(:,1) = SetA(:,1)*answer(1);
SetA(:,2) = SetA(:,2)*answer(2);
SetA(:,3) = SetA(:,3)*answer(3);

p=1

temp = squeeze(finalDirection(p,:,:))-SetA;
temp = sqrt(sum((temp.^2),2));
index = find(temp == min(temp));
finalDirectionVector = squeeze(finalDirection(p,index,:))
final = finalDirectionVector
%final = mean(stor,2);
plot3([0 final(1)],[0 final(2)],[0 final(3)]);
% finalDirectionVector = stor;
[inclination,elevation,r] = cart2sph(finalDirectionVector(1),finalDirectionVector(2),finalDirectionVector(3));
inclination = rad2deg(inclination)
elevation = rad2deg(elevation)
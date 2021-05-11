
array_position = guess_set(1,:);

Roll = 0:5:359;
dis = 0.3;
color = ['r','g','c','y','m'];

finalDirection = zeros(length(sources),length(Roll),3);

for m = 1:2
U = array_position-sources(m).position';
b = finalAngleStorage(1,m);
U = U/norm(U);
V = cross(U,[1 0 0]);
V = V/norm(V);
answer = [0 1 0];

angle = atan2(norm(cross(U,V)), dot(U,V));
correctAngle = 90-finalAngleStorage(1,m);%rad2deg(atan2(norm(cross(U,answer)), dot(U,answer)));
b = correctAngle;


W = cross(V,U);
W = W/norm(W);


R = [W; V; U];


direction = zeros(length(Roll),3);

for i = 1:length(Roll)
directionRotation = [[cosd(Roll(i)) sind(Roll(i)) 0];[-sind(Roll(i)) cosd(Roll(i)) 0];[0 0 1]];
direction(i,:) = directionRotation*[0; dis*cosd(b); dis*sind(b)];
direction(i,:) = direction(i,:)*R;
end

finalDirection(m,:,:) = direction;

plot3([0 U(1)],[0 U(2)],[0 U(3)],'r')
hold all
%plot3([0 V(1)],[0 V(2)],[0 V(3)],'b')
hold all
%plot3([0 W(1)],[0 W(2)],[0 W(3)],'b')
% hold all
% plot3([0 test(1)],[0 test(2)],[0 test(3)],'y')
% hold all
% plot3([0 testRotated(1)],[0 testRotated(2)],[0 testRotated(3)],'c')
hold all

for i = 1:length(Roll)
plot3([0 direction(i,1)],[0 direction(i,2)],[0 direction(i,3)],color(m))
hold all
end
end
plot3([0 answer(1)],[0 answer(2)],[0 answer(3)],'--xm')
zlim([-1 1])
ylim([-1 1])
xlim([-1 1])
xlabel("x-axis")
ylabel("y-axis")
zlabel("z-axis")
title("Direction vector with roll")

directionVectorSet = []
for p = 1:2
    for i = 1:2
        if i~=p
            distances = pdist2(squeeze(finalDirection(p,:,:)),squeeze(finalDirection(i,:,:)));
            minDistance = min(distances(:));
            [rowOfA, rowOfB] = find(distances == minDistance);

            directionVectorSet = [directionVectorSet; squeeze(finalDirection(i,rowOfB,:))'];
        end
    end
end
directionVectorSet = [directionVectorSet; squeeze(finalDirection(1,rowOfA,:))'];

directionVectorSetNonOutlier = rmoutliers(directionVectorSet);
finalDirectionVector = mean(directionVectorSetNonOutlier)*5

plot3([0 finalDirectionVector(1)],[0 finalDirectionVector(2)],[0 finalDirectionVector(3)],'--og')

function [finalDirectionVector angles finalRotation, angle_error] = angle_calculation_analytic(finalAngleStorage,sources,array_position,receiver)

Roll = 0:5:359;
dis = 0.3;
color = ['r','m','c','y','g'];

finalDirection = zeros(length(sources),length(Roll),3);

figure

for m = 1:length(sources)
U = array_position-sources(m).position';
b = finalAngleStorage(1,m);
U = U/norm(U);
V = cross(U,[1 0 0]);
V = V/norm(V);
answer = [-1 0 1];

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
plot3([0 V(1)],[0 V(2)],[0 V(3)],'b')
hold all
plot3([0 W(1)],[0 W(2)],[0 W(3)],'b')
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
plot3([0 answer(1)],[0 answer(2)],[0 answer(3)],'m')
zlim([-1 1])
ylim([-1 1])
xlim([-1 1])
xlabel("x-axis")
ylabel("y-axis")
zlabel("z-axis")


directionVectorSet = [];
for p = 1:length(sources)
    for i = 1:length(sources)
        if i~=p
            distances = pdist2(squeeze(finalDirection(p,:,:)),squeeze(finalDirection(i,:,:)));
            minDistance = min(distances(:));
            [rowOfA, rowOfB] = find(distances == minDistance,1);

            directionVectorSet = [directionVectorSet; squeeze(finalDirection(i,rowOfB,:))'];
        end
    end
end
directionVectorSet = [directionVectorSet; squeeze(finalDirection(1,rowOfA,:))'];

directionVectorSetNonOutlier = rmoutliers(directionVectorSet);
finalDirectionVector = -mean(directionVectorSetNonOutlier)*5;

[inclination,elevation,r] = cart2sph(finalDirectionVector(1),finalDirectionVector(2),finalDirectionVector(3));
inclination = rad2deg(inclination);
elevation = rad2deg(elevation);


originalDirectionVector = receiver.directionVector;
[inclinationO,elevationO,r] = cart2sph(originalDirectionVector(1),originalDirectionVector(2),originalDirectionVector(3));
inclinationO = rad2deg(inclinationO);
elevationO = rad2deg(elevationO);

angles = [inclination elevation inclinationO elevationO];

angle_error = [inclinationO-inclination elevationO - elevation];

finalRotation = [];
for m = 1:length(sources)
U = finalDirectionVector;
Incoming = array_position-sources(m).position';
U = U/norm(U);
V = cross(U,[1 0 0]);
V = V/norm(V);
answer = [0 0 1];


W = cross(V,U);
W = W/norm(W);


R = [W; V; U];

O = U*inv(R);

r_x = [[1 0 0];[0 cos(-pi/2) -sin(-pi/2)];[0 sin(-pi/2) cos(-pi/2)]];
r_y = [[cos(-pi/2) 0 sin(-pi/2)];[0 1 0];[-sin(-pi/2) 0 cos(-pi/2)]];

Y_n = O*r_x*R;
X_n = O*r_y*R;
Y_n = Y_n/norm(Y_n);
X_n = X_n/norm(X_n);
N = X_n;
F = Y_n;

X_component = dot(Incoming,X_n);
Y_component = dot(Incoming,Y_n);

I = [X_component Y_component];
I = I/norm(I);

theta = finalAngleStorage(2,m);
R_o = [[cosd(theta) -sind(theta)];[sind(theta) cosd(theta)]];
I = I*R_o;

P = [I 0];
P = P*R;
P = P/norm(P);

A = dot(Incoming,U)*U;
C = Incoming-A;
C = C/norm(C);
C = C*inv(R);

R_z = [[cosd(theta) -sind(theta) 0]; [sind(theta) cosd(theta) 0]; [0 0 1]];

C = C*R_z;
C = C*R;

finalRotation = [finalRotation; P];
end
finalRotation = mean(rmoutliers(finalRotation));
u = finalRotation;
v = receiver.orientationVector;
angle_error = [angle_error atan2(norm(cross(u,v)),dot(u,v))];


plot3([0 finalDirectionVector(1)],[0 finalDirectionVector(2)],[0 finalDirectionVector(3)],'g')

%error("stop for graphing")

end

b = 45;
Roll = 0:359;
R = 0.07;

location = guess_set(1,:)
X = location'-sources(1).position
X = X/norm(X)

rotationMatrix = [[1 0 0];[0 cos(pi/2) -sin(pi/2)];[0 sin(pi/2) cos(pi/2)]];
Z = rotationMatrix*X
Y = cross(X,Z);
Y = Y/norm(Y);

plot3([0 X(1)],[0 X(2)],[0 X(3)])
hold all
plot3([0 Z(1)],[0 Z(2)],[0 Z(3)])
hold all
plot3([0 Y(1)],[0 Y(2)],[0 Y(3)])
xlabel("x-axis")
ylabel("y-axis")
zlabel("z-axis")

direction = zeros(length(Roll),3);
for i = 1:length(Roll)
direction(i,:) = [sind(Roll(i))*sind(b) cosd(Roll(i))*cosd(b) sind(b)];
end

for i = 1:length(Roll)
plot3([X(1) direction(i,1)],[X(2) direction(i,2)],[X(3) direction(i,3)])
hold all
end
%xlabel("x-axis")
%ylabel("y-axis")
%zlabel("z-axis")


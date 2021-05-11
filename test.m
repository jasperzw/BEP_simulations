% figure
% subplot(3,2,1)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, d(:,1), 'filled')
% axis image
% title("First source")
% subplot(3,2,2)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, d(:,2), 'filled')
% axis image
% title("Second source")
% subplot(3,2,3)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, d(:,3), 'filled')
% axis image
% title("Third source")
% subplot(3,2,4)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, d(:,4), 'filled')
% axis image
% title("Fourth source")
% subplot(3,2,5)
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2), 50, d(:,5), 'filled')
% axis image
% title("Fourth source")

Roll = 0:359;
dis = 0.3;
color = ['r','m','c','y','g'];

finalDirection = zeros(length(sources),length(Roll),3);


U = finalDirectionVectorStorage(4,:)
Incoming = guess_set(4,:)-sources(1).position'
Incoming = -Incoming
U = U/norm(U);
V = cross(U,[1 0 0]);
V = V/norm(V);
answer = [0 0 1];


W = cross(V,U);
W = W/norm(W);


R = [W; V; U];

O = U*inv(R);

r_x = [[1 0 0];[0 cos(pi/2) -sin(pi/2)];[0 sin(pi/2) cos(pi/2)]]
r_y = [[cos(pi/2) 0 sin(pi/2)];[0 1 0];[-sin(pi/2) 0 cos(pi/2)]]

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

theta = -finalAngleStorage(8,1)
R_o = [[cosd(theta) -sind(theta)];[sind(theta) cosd(theta)]];
I = I*R_o;

P = [I 0]
P = P*R;
P = P/norm(P);

A = dot(Incoming,U)*U;
C = Incoming-A;
C = C/norm(C);
C = C*inv(R);

R_z = [[cosd(theta) -sind(theta) 0]; [sind(theta) cosd(theta) 0]; [0 0 1]];

C = C*R_z;
C = C*R;


figure
plot3([0 U(1)],[0 U(2)],[0 U(3)])
hold all
%plot3([0 O(1)],[0 O(2)],[0 O(3)])
plot3([0 N(1)],[0 N(2)],[0 N(3)])
plot3([0 F(1)],[0 F(2)],[0 F(3)])
plot3([0 Incoming(1)],[0 Incoming(2)],[0 Incoming(3)])
plot3([0 P(1)],[0 P(2)],[0 P(3)])
plot3([0 C(1)],[0 C(2)],[0 C(3)],'--x')
xlabel("x-axis")
zlabel("z-axis")
ylabel("y-label")
xlim([-1 1])
ylim([-1 1])
zlim([-1 1])

% figure
% plot([0 I(1)],[0 I(2)])
% xlim([-1 1])
% ylim([-1 1])
v1 = [0 0; 0 0 ; 0 0]
v2 = [0 0.02; 0 0.05; 0 0.01]

plot3(v1(1,:),v1(2,:),v1(3,:))
hold all
plot3(v2(1,:),v2(2,:),v2(3,:))

medium_speed = 340
delay = 0.02/medium_speed;

distanceVector = v2(:,2)-v1(:,2);
a = sqrt(sum(distanceVector.^2))
b = delay*medium_speed; 
angleVector = acosd(b/a);

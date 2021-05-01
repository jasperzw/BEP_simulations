x_set = [];
y_set = [];
z_set = [];

for i = 1:length(sources)
    x_set = [x_set sources(i).position(1)];
    y_set = [y_set sources(i).position(2)];
    z_set = [z_set sources(i).position(3)];
end

d_u = trueDelay;

fun = @(x)(d_u(x(4),:)-(sqrt((x(1)-x_set).^2+(x(2)-y_set).^2+(x(3)-z_set).^2)/medium_speed));

X = 0:0.5:30;
Y = 0:0.5:30;
Z = zeros(length(X),length(Y),length(d_u));
for n = 1:length(d_u)
    for i = 1:length(X)
       for m = 1:length(Y)
        Z(m,i,n) = sum(fun([X(i) receivers(n).arrayPattern(1,2) Y(m) n]).^2);
       end
    end
end

%[X Y] = meshgrid(0:0.5:30);

% subplot(2,1,1)
% imagesc(X,Y,Z_old)
% colorbar
% xlabel("X-axis")
% ylabel("Y-axis")
% title("one-sided source")
% axis image
% subplot(2,1,2)
for f = 1:length(d_u)
subplot(2,length(d_u)/2,f)
imagesc(X,Y,Z(:,:,f))
ylim([0 10])
colorbar
xlabel("X-axis")
ylabel("Z-axis")
ylim([0 10])
title(f)
axis image
ylim([0 10])
end

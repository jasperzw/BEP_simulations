

x_set = [];
y_set = [];

for i = 1:amountSources
    m = (i-1)*2+1;
    x_set = [x_set double(coordinate_set(m))];
    y_set = [y_set double(coordinate_set(m+1))];
end

% below is the manual method
%fun = @(x)(t(1,:)-(sqrt(((x(1)-x_set)*dx).^2+((x(2)-y_set)*dy).^2)/340));
% Z = zeros(Nx,Ny);
% for x = 1:Nx
%    for y = 1:Ny
%     Z(x,y) = sum(fun([x,y]).^2);
%    end
% end
% 
% minSet = 1e03;
% Mx = 0;
% My = 0;
% for i = 1:Nx
%     for m = 1:Ny
%         if(Z(i,m)<minSet)
%            minSet = Z(i,m);
%            Mx = i;
%            My = m;
%         end
%     end
% end

sensor_set = []
for i = 1:Ny
    for n = 1:Nx
        if(sensor.mask(n,i) == 1)
            sensor_set = [sensor_set; [i,n]];
        end
    end
end

x0 = [100,100];
lb = [1,1];
ub = [Nx,Ny];
options = optimoptions('lsqnonlin','Display','off');
options.OptimalityTolerance = 1e-09;
options.FunctionTolerance = 2e-09
sensor_guess_set = [];

for i = 1:30
    fun = @(x)(t(i,:)-(sqrt(((x(2)-x_set)*dx).^2+((x(1)-y_set)*dy).^2)/340));
    [x,resnorm,residual,exitflag,output] = lsqnonlin(fun,x0,lb,ub,options);
    sensor_guess_set = [sensor_guess_set; x];
end

error_optimization = sqrt((sensor_guess_set(:,1)-sensor_set(:,1)).^2+(sensor_guess_set(:,2)-sensor_set(:,2)).^2);


middle = Nx/2;
offset_plot = 50;

figure
subplot(2,2,1)
plot(sensor_guess_set(1:15,1),sensor_guess_set(1:15,2))
%xlim([middle-offset_plot middle+offset_plot])
%ylim([middle-offset_plot middle+offset_plot])
xlim([0 Nx])
ylim([0 Ny])

hold all
plot(sensor_guess_set(16:30,1),sensor_guess_set(16:30,2))
plot(sensor_set(1:15,1),sensor_set(1:15,2))
plot(sensor_set(16:30,1),sensor_set(16:30,2))
title("arrays in the simulation") 
xlabel("Distance in millimeters")
ylabel("Distance in millimeters")
subplot(2,2,2)
plot(error_optimization)
title("error of specific microphone")
xlabel("Microphone Number")
ylabel("distance error in millimeters")

subplot(2,2,3)
plot(sensor_guess_set(:,1))
hold all
plot(sensor_set(:,1))
ylim([middle-offset_plot middle+offset_plot])
title("Comparison of the Y-axis")
xlabel("Microphone number")
ylabel("Distance in mm")
legend("Original position", "Estimated position")

subplot(2,2,4)
plot(sensor_guess_set(:,2))
hold all
plot(sensor_set(:,2))
ylim([middle-offset_plot middle+offset_plot])
title("Comparison of the X-axis")
xlabel("Microphone number")
ylabel("Distance in mm")
legend("Original position", "Estimated position")
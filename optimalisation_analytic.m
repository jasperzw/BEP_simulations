

x_set = [];
y_set = [];
z_set = [];

for i = 1:length(sources)
    x_set = [x_set sources(i).position(1)];
    y_set = [y_set sources(i).position(2)];
    z_set = [z_set sources(i).position(3)];
end

sensor_set = []
x0 = [15,5,3];
lb = [0,0,0];
ub = [50,50,10];
options = optimoptions('lsqnonlin','Display','iter');
options.OptimalityTolerance = 1e-09;
options.FunctionTolerance = 2e-09
sensor_guess_set = [];

for i = 1:64
    fun = @(x)(t_u(i,:)-(sqrt((x(1)-x_set).^2+(x(2)-y_set).^2+(x(3)-z_set).^2)/medium_speed));
    [x,resnorm,residual,exitflag,output] = lsqnonlin(fun,x0,lb,ub,options);
    sensor_guess_set = [sensor_guess_set; x];
end

error_optimization = sqrt((sensor_guess_set(:,1)-receiver_x).^2+(sensor_guess_set(:,2)-receiver_y).^2+(sensor_guess_set(:,3)-receiver_z).^2)

scatter(sensor_guess_set(:,1),sensor_guess_set(:,2)) 

% middle = Nx/2;
% offset_plot = 50;
% 
% figure
% subplot(2,2,1)
% plot(sensor_guess_set(1:15,1),sensor_guess_set(1:15,2))
% %xlim([middle-offset_plot middle+offset_plot])
% %ylim([middle-offset_plot middle+offset_plot])
% xlim([0 Nx])
% ylim([0 Ny])
% 
% hold all
% plot(sensor_guess_set(16:30,1),sensor_guess_set(16:30,2))
% plot(sensor_set(1:15,1),sensor_set(1:15,2))
% plot(sensor_set(16:30,1),sensor_set(16:30,2))
% title("arrays in the simulation") 
% xlabel("Distance in millimeters")
% ylabel("Distance in millimeters")
% subplot(2,2,2)
% plot(error_optimization)
% title("error of specific microphone")
% xlabel("Microphone Number")
% ylabel("distance error in millimeters")
% 
% subplot(2,2,3)
% plot(sensor_guess_set(:,1))
% hold all
% plot(sensor_set(:,1))
% ylim([middle-offset_plot middle+offset_plot])
% title("Comparison of the Y-axis")
% xlabel("Microphone number")
% ylabel("Distance in mm")
% legend("Original position", "Estimated position")
% 
% subplot(2,2,4)
% plot(sensor_guess_set(:,2))
% hold all
% plot(sensor_set(:,2))
% ylim([middle-offset_plot middle+offset_plot])
% title("Comparison of the X-axis")
% xlabel("Microphone number")
% ylabel("Distance in mm")
% legend("Original position", "Estimated position")
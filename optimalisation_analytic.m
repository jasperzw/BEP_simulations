function [sensor_guess_set, error_optimization] = optimalisation_analytic(sources,readOut,receiver,d,STSS,t_array,medium_speed)

x_set = [];
y_set = [];
z_set = [];

sunFlowerArray = receiver.arrayPattern;

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
options.OptimalityTolerance = 1e-20;
options.FunctionTolerance = 1e-20
sensor_guess_set = [];

d = d-d(1,:);

finalReadOut = zeros(length(sources),length(readOut));
%% apply delays as beamformer
for m = 1:length(sources)
    for i = 1:length(sunFlowerArray)
        finalReadOut(m,:) = finalReadOut(m,:) + shift(readOut(i+(m-1)*length(sunFlowerArray),:),-d(i,m));
    end
    % apply bandpass filter
    %finalReadOut(m,:) = bandpass(finalReadOut(m,:),[1e3 7e3],1/t_array(2));
end

%% calculate final delay
finalDelay = zeros(1,length(sources));

for m = 1:length(sources)
    [x y] = xcorr(finalReadOut(m,:),STSS);
    index = find(x==max(x));
    steps = y(index);
    finalDelay(m) = steps*t_array(2);
end




fun = @(x)(finalDelay(:)'-(sqrt((x(1)-x_set).^2+(x(2)-y_set).^2+(x(3)-z_set).^2)/medium_speed));
[x,resnorm,residual,exitflag,output] = lsqnonlin(fun,x0,lb,ub,options);
sensor_guess_set = x


error_optimization = sqrt((sensor_guess_set(:,1)-receiver.arrayPattern(1,1)).^2+(sensor_guess_set(:,2)-receiver.arrayPattern(1,2)).^2+(sensor_guess_set(:,3)-receiver.arrayPattern(1,3)).^2)

%scatter(sensor_guess_set(:,1),sensor_guess_set(:,2))
end

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

function [result] = shift(signal,amount)
result = zeros(1,length(signal));
temp = signal;
if amount<0
    temp = [temp(abs(amount)+1:end) zeros(1,abs(amount))];
end
if amount>0
    temp = [zeros(1,abs(amount)) temp(1:end-abs(amount))];
end
result = result + temp;
end
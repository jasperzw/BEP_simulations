function [sensor_guess_set, error_optimization, finalDelay] = optimalisation_real_life(sources,readOut,receiver,d,STSS,t_array,medium_speed,x0,angleStorage)

x_set = [];
y_set = [];
z_set = [];

sunFlowerArray = receiver.arrayPattern;

for i = 1:length(sources)
    x_set = [x_set sources(i).position(1)];
    y_set = [y_set sources(i).position(2)];
    z_set = [z_set sources(i).position(3)];
end

sensor_set = [];
%x0 = [18,6,3];
lb = [0,-2,1];
ub = [12,5,2];
options = optimoptions('lsqnonlin','Display','off');
options.OptimalityTolerance = 1e-20;
options.FunctionTolerance = 1e-20;
options.StepTolerance = 1e-10;
sensor_guess_set = [];


finalReadOut = zeros(length(sources),length(readOut));


%% calculate final delay

finalDelay = d;
%create offset

%timeSyncOffset = 2.9e-4*rand(1) %2.9e-4 is the travel time of sound for 10 cm

%d_u = finalDelay + timeSyncOffset;

fun = @(x)(finalDelay(:)'-(sqrt((x(1)-x_set).^2+(x(2)-y_set).^2+(x(3)-z_set).^2)/medium_speed));
x = lsqnonlin(fun,x0,lb,ub,options);
sensor_guess_set = x;


error_optimization = sqrt((sensor_guess_set(:,1)-receiver.arrayPattern(1,1)).^2+(sensor_guess_set(:,2)-receiver.arrayPattern(1,2)).^2+(sensor_guess_set(:,3)-receiver.arrayPattern(1,3)).^2);

%scatter(sensor_guess_set(:,1),sensor_guess_set(:,2))
end

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
function [sensor_guess_set, error_optimization, finalDelay,  calculatedAngleStorage] = optimalisation_analytic(sources,readOut,receiver,d,STSS,t_array,medium_speed,x0,angleStorage)

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
lb = [0,0,0];
ub = [50,50,10];
options = optimoptions('lsqnonlin','Display','off');
options.OptimalityTolerance = 1e-20;
options.FunctionTolerance = 1e-20;
options.StepTolerance = 1e-10;
sensor_guess_set = [];
d_u = d(1,:)*t_array(2);
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
%     index = find(y==0);
%     x = x(index:end);
%     [pks loc] = findpeaks(x);
%     highest = maxk(pks,1);
%     index = length(highest);
%     for f = 1:length(highest)
%     index(f) = find(x == highest(f),1);
%     end
% 
%     steps = min(index);
    s = std(x)*10+0*y;
    f = x(find(x>s));
    c = findpeaks(f);
    m = find(x==c(1));
    steps = y(m);
    finalDelay(m) = steps*t_array(2);
end

finalDelay = d_u;

%create offset

%timeSyncOffset = 2.9e-4*rand(1) %2.9e-4 is the travel time of sound for 10 cm

%d_u = finalDelay + timeSyncOffset;

fun = @(x)(finalDelay(:)'-(sqrt((x(1)-x_set).^2+(x(2)-y_set).^2+(x(3)-z_set).^2)/medium_speed));
x = lsqnonlin(fun,x0,lb,ub,options);
sensor_guess_set = x;


error_optimization = sqrt((sensor_guess_set(:,1)-receiver.arrayPattern(1,1)).^2+(sensor_guess_set(:,2)-receiver.arrayPattern(1,2)).^2+(sensor_guess_set(:,3)-receiver.arrayPattern(1,3)).^2);

%caculate definitive angle
calculatedAngleStorage = zeros(2,length(sources));
for m = 1:length(sources)
   vector = x' - sources(m).position;
   if vector(1)>0 & vector(2)>0 
   	inclinationOriginal = atand(vector(1)/vector(2));
   end
   if vector(1)<=0 & vector(2)>0
    inclinationOriginal = 180-atand(vector(1)/vector(2));
   end
   if vector(1)<=0 & vector(2)<=0
    inclinationOriginal = atand(vector(1)/vector(2))+180;
   end
   if vector(1)>0 & vector(2)<=0
        inclinationOriginal = 360-atand(vector(1)/vector(2));
   end
   azimuthOriginal = atand(vector(3)/sqrt(vector(1)^2+vector(2)^2));
   azimuthFinal = azimuthOriginal+angleStorage(1,m);
   inclinationFinal = inclinationOriginal-angleStorage(2,m);
   calculatedAngleStorage(1,m) = azimuthFinal';
   calculatedAngleStorage(2,m) = inclinationFinal;
end

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
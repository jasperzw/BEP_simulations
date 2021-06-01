clear
clc

%% load information
addpath '/home/jasper/Documents/Uni/BEP/Measurements_Zwarte_doos/Measurements/matlab'
files = dir('/home/jasper/Documents/Uni/BEP/Measurements_Zwarte_doos/Measurements/*.bin');

folders = string({files.folder});
names = string({files.name});
[~, idx] = sort(names);

filenames = fullfile(folders(idx), names(idx));

[calibrationEmittence,fs] = audioread('../Measurements_Zwarte_doos/mychirp_single.wav');

%get the sun flower formation
sunFlowerPattern = sunflower_map();
sunFlowerPattern = [sunFlowerPattern(:,3:4)/1000 zeros(64,1)];

%% assignen which files to be used

[sensivity sources MeasureSet] = data_load(9)

MeasureName = names(MeasureSet); %front middle back left right

%load 1 file to get fs
snd = load_sound(filenames(MeasureSet(1)), 0, 10);

ishMiddle = 26;

%resample calibration signal
calibrationEmittence = resample(calibrationEmittence,snd.fs,fs);

%audio player
emittence = audioplayer(calibrationEmittence, snd.fs);
received = audioplayer(snd.data(37,:), snd.fs);
receivedCalibration = audioplayer(snd.data(24+4+64,:),snd.fs);

coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(45)]];

receivers = [];

%set initial point for optimisation
temp = [];
for i = 1:length(sources)
    temp = [temp; sources(i).position];
end

x0 = mean(temp);
x0(3) = mean(coordinatesReceiver(:,3));

%% get estimate of the needed information
mediumSpeed = (343.21+346.13)/2;
distance = sqrt(sum((-coordinatesReceiver(1:3)'+temp').^2));
flightTime = distance/mediumSpeed;
samplesTaken = flightTime*snd.fs;

%gerenate receiver array
for i = 1:size(coordinatesReceiver,1)
    storageArray = zeros(size(sunFlowerPattern));
    inclination = coordinatesReceiver(i,4)+pi/2; %the actual array is orthogonal to direction vector
    azimuth = coordinatesReceiver(i,5);
    r_x = [[1 0 0];[0 cos(inclination) -sin(inclination)];[0 sin(inclination) cos(inclination)]];
    r_z = [[cos(azimuth) -sin(azimuth) 0]; [sin(azimuth) cos(azimuth) 0]; [0 0 1]];
    directionVector = (r_z*r_x*[0; 0; 1])';
    orientationVector = (r_z*r_x*[-1; 0; 0])';
    for m = i:size(sunFlowerPattern)
        storageArray(m,:) = (r_z*r_x*sunFlowerPattern(m,:)')';
    end
    receivers = [receivers receiverClass(storageArray+coordinatesReceiver(i,1:3),coordinatesReceiver(i,4),coordinatesReceiver(i,5),directionVector,orientationVector)];
end

%% perform delay calculation
dTotal = []; 
tTotal = [];
t = [];
display('processing data')
b = 0;
for m = MeasureSet
snd = load_sound(filenames(m), 0, 10);
clc
display(['|' repmat('x',1,b) repmat('-',1,length(MeasureSet)*2-b) '|'])
[t_u d] = beamformer_real_life(sunFlowerPattern,1,snd.data(1:64,:),calibrationEmittence,sensivity,snd.fs);
b=b+1;
clc
display(['|' repmat('x',1,b) repmat('-',1,length(MeasureSet)*2-b) '|'])
[t_u_c d_c] = beamformer_real_life(sunFlowerPattern,1,snd.data(65:end,:),calibrationEmittence,sensivity-2,snd.fs);
b=b+1;
begin_t = mean(t_u_c(35:38));
t = [t t_u-t_u(ishMiddle)];
d_res = d-d(ishMiddle);
d = d-round(mean(d_c(35:38)));
finalReadOut = zeros(1,length(snd.data(1,:)));
%% apply delays as beamformer

for i = 1:length(sunFlowerPattern)
    finalReadOut = finalReadOut + shift(snd.data(i,:),-d_res(i));
end

%% get final delay
[x y] = xcorr(finalReadOut,calibrationEmittence);
pos = find(y>=0,1);
x = x(pos:end);
s = std(x)*sensivity;
f = x(find(x>s));
c = findpeaks(f);
k = find(x==c(1));

beamformerDelay = k/snd.fs-begin_t;

% apply bandpass filter
%finalReadOut(m,:) = bandpass(finalReadOut(m,:),[1e3 7e3],1/t_array(2));

dTotal = [dTotal d];
tTotal = [tTotal beamformerDelay];
end

%% perform optimisation for result


load data/comparisonCam64Sun.mat;

errorStorage = zeros(size(resultStorage));

angleStorage = zeros(2,length(sources));

for m = 1:length(sources)
    for i = 1:size(resultStorage,1)
       for k = 1:size(resultStorage,2)
           error = t(:,m)-resultStorage(i,k).delaySet;
           error = sum(abs(error));
           errorStorage(i,k) = error;
       end
    end

    [row col] = find(errorStorage == min(min(errorStorage)),1);
    resultAzimuth = (180/pi)*azimuthSet(col);
    resultInclination = (180/pi)*inclinationSet(row);
    angleStorage(1,m) = resultAzimuth;
    angleStorage(2,m) = resultInclination;
end

t_set = (0:length(snd.data(37,:))-1)/snd.fs;

t_array = [0 1/snd.fs];
[sensor_guess_set, error_optimization, finalDelay] = optimalisation_real_life(sources,snd.data,receivers(1),tTotal,calibrationEmittence,t_array,mediumSpeed,x0,angleStorage);
[DirectionVector angles finalRotation, angle_error] = angle_calculation_real(angleStorage,sources,sensor_guess_set,receivers(1));
error_optimization

%% plotting 
subplot(5,1,1)
plot(t_set,snd.data(ishMiddle,:))
xlim([0.015 0.065])
title("Receiver ishMiddle mic")
subplot(5,1,2)
plot(t_set,finalReadOut)
xlim([0.015 0.065])
title("beamformer result")
subplot(5,1,3)
plot(t_set,snd.data(64+24+4,:))
xlim([0.015 0.065])
title("middle calibration array mic")
subplot(5,1,4)
[x y] = xcorr(finalReadOut,calibrationEmittence);
y = y/snd.fs;
plot(y,x)
xlim([0.015 0.065])
yline(std(x)*sensivity);
title("correlation beamformer")
subplot(5,1,5)
[x y] = xcorr(snd.data(64+24+4,:),calibrationEmittence);
y = y/snd.fs;
plot(y,x)
xlim([0.015 0.065])
yline(std(x)*sensivity-2);
title("correlation calibration middle mic")

%% short shift function to perform beamforming
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
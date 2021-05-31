clear
clc
addpath 'C:\Users\20182201\Documents\Uni\Jaar 3\Q3\BEP\Measurements_Zwarte_doos\Measurements\matlab'
files = dir('C:\Users\20182201\Documents\Uni\Jaar 3\Q3\BEP\Measurements_Zwarte_doos\Measurements\*.bin');

folders = string({files.folder});
names = string({files.name});
[~, idx] = sort(names);

filenames = fullfile(folders(idx), names(idx));
files = []
for i = 1:length(filenames)
temp = strsplit(filenames(:,i),'\');
files = [files temp(end)];
end
idx = 73 %middle standard calibration
%idx=70
MeasureSet = [69 73 31 71 74]; %front midden achter links rechts CALIBRATIE
snd = load_sound(filenames(idx), 0, 10);
sources = [sourceClass([2 1 0],[]); sourceClass([2.3 1 0],[]); sourceClass([2.6 1 0],[]); sourceClass([2.3 0.7 0],[]); sourceClass([2.3 1.3 0],[])];  

mediumSpeed = (343.21+346.13)/2;
distance = sqrt(1.3^2+1.5^2);
flightTime = distance/mediumSpeed;
samplesTaken = flightTime*snd.fs
sensivity = 4;

ishMiddle = 26;

[calibrationEmittence,fs] = audioread('../Measurements_Zwarte_doos/mychirp_single.wav');
calibrationEmittence = resample(calibrationEmittence,snd.fs,fs);

%audio player
emittence = audioplayer(calibrationEmittence, snd.fs);
received = audioplayer(snd.data(37,:), snd.fs);
receivedCalibration = audioplayer(snd.data(24+4+64,:),snd.fs);

sunFlowerPattern = sunflower_map();
sunFlowerPattern = [sunFlowerPattern(:,3:4) zeros(64,1)];

coordinatesReceiver = [[1 1 1.5 deg2rad(90) pi/2]];
%coordinatesReceiver = [[5 4 3 pi/4 pi/2]];

receivers = [];

x0 = mean([sources(:).position],2)';
x0(3) = mean(coordinatesReceiver(:,3));

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

dTotal = []; 
tTotal = [];
for m = MeasureSet
snd = load_sound(filenames(m), 0, 10);
[t_u d angleStorage errorStorage] = beamformer_real_life(sunFlowerPattern,1,snd.data(1:64,:),calibrationEmittence,sensivity,snd.fs);
[t_u_c d_c angleStorage_c errorStorage_c] = beamformer_real_life(sunFlowerPattern,1,snd.data(65:end,:),calibrationEmittence,sensivity-2,snd.fs);
begin_t = mean(t_u_c(35:38));
t = t_u-begin_t;
d_res = d-d(ishMiddle);
d = d-round(mean(d_c(35:38)));
finalReadOut = zeros(1,length(snd.data(1,:)));
%% apply delays as beamformer

for i = 1:length(sunFlowerPattern)
    finalReadOut = finalReadOut + shift(snd.data(i,:),-d_res(i));
end


[x y] = xcorr(finalReadOut,calibrationEmittence);
s = std(x)*10+0*y;
f = x(find(x>s));
c = findpeaks(f);
k = find(x==c(1));
steps = y(k);
beamformerDelay = steps/snd.fs;

% apply bandpass filter
%finalReadOut(m,:) = bandpass(finalReadOut(m,:),[1e3 7e3],1/t_array(2));

dTotal = [dTotal d];
tTotal = [tTotal t];
end

t_set = (0:length(snd.data(37,:))-1)/snd.fs;

t_array = [0 1/snd.fs];
[sensor_guess_set, error_optimization, finalDelay] = optimalisation_real_life(sources,snd.data,receivers(1),tTotal,calibrationEmittence,t_array,mediumSpeed,x0,angleStorage);
error_optimization





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
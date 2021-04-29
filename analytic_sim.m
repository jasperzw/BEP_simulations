clear
clc
source_mag = 300;     % [Pa]

f = 2e3:5:6e3;
Ts = 8.3e-3;
t_array = linspace(0,Ts,length(f));
STSS = source_mag*sin(2*pi*f.*t_array);

%walls on stratum
%up is x lower is y
wallSet = [wall([15; 7],[0; 7]); wall([0; 0],[43; 0]); wall([19.5; 7],[43; 7]); wall([15; 7],[15; 32]); wall([19.5;7],[19.5; 32])];

%set initial source
%sources = [sourceClass([7;6;1],[]) sourceClass([8;4.5;1],[]) sourceClass([9;3;1],[]) sourceClass([10; 1.5; 1],[]) sourceClass([30; 5; 1],[]) sourceClass([30; 3; 1],[])] %original source
%sources = [sourceClass([14;4;1],[]) sourceClass([16;4;1],[]) sourceClass([18;4;1],[]) sourceClass([20;4;1],[]) sourceClass([22;4;1],[])] %lineair array E = 8.5747
%coordinates = [[15 5 1];[15 3 1];[17 5 1];[17 3 1]]; %square E = 0.0343
%coordinates = [[12 2 1];[16 2 1];[14 4 1]]; %triangle E = 11.2393
%coordinates = [[12 2 1];[13 3 1];[14 4 1];[15 5 1]]; %diagonal E=12.3338
coordinates = [[12 4 1];[14 4 1];[16 4 1];[14 6 1];[14 2 1]]; %cross E = 5.5465 | Eo = 0.0187 
%coordinates = [[9 4 1];[11 4 1];[13 4 1];[11 6 1];[11 2 1];[13 4 1];[15 4 1];[17 4 1];[15 6 1];[15 2 1]]; %E=5.6978 | Eo=0.0152 
sources = [];

coordinates(:,1) = coordinates(:,1)-2;

for i = 1:size(coordinates,1)
   sources = [sources sourceClass(coordinates(i,:)',[])];
end


x0 = mean([sources(:).position],2)';
x0(3) = 3;
medium_speed = 340;

load('data/sunFlowerArray.mat')
% receiverClass([sunFlowerArray(:,1)+5 sunFlowerArray(:,2)+6 sunFlowerArray(:,3)+3])
%coordinatesReceiver = [[2 6 3];[2 1 3];[10 6 3];[10 1 3];[18 6 3];[18 1 3];[26 6 3];[26 1 3];[34 6 3];[34 1 3]];
coordinatesReceiver = [[10 6 3];[10 1 3];[18 6 3];[18 1 3]];
receivers = [];
for i = 1:size(coordinatesReceiver,1)
   receivers = [receivers receiverClass([sunFlowerArray(:,1)+coordinatesReceiver(i,1) sunFlowerArray(:,3)+coordinatesReceiver(i,2) sunFlowerArray(:,2)+coordinatesReceiver(i,3)])];
end

%plot information
for receiver = receivers
    plot(receiver.arrayPattern(1,1),receiver.arrayPattern(1,2),'ob')
    hold all
end
xlim([-5 45])
ylim([-5 35])
xlabel("x [meters]")
ylabel("y [meters]")
title("simulation")
legend()
x = [];
y = [];

for m = 1:length(wallSet)
 x = [wallSet(m).p1(1) wallSet(m).p2(1)];
 y = [wallSet(m).p1(2) wallSet(m).p2(2)];
 hold all
 line(x,y,'color','black')
end

%% plot the reflections


%% calculate the final sound readOut
receiverReadOut = [];

for receiver = receivers
    readOut = [];
    for i = 1:length(sources)
        [results]  = createReflectionMap(sources(i), [wallSet(1) wallSet(2)]);
        [results]  = createReflectionMap(results, [wallSet(1) wallSet(2)]);
        hold all
        for point = results
            plot(point.position(1),point.position(2),'xr')
        end
        plot(results(1).position(1),results(1).position(2),'xb')
        [microphoneResults, timeSet] = soundSimulation(results,receiver.arrayPattern,medium_speed,STSS,t_array);
        readOut = [readOut; microphoneResults]; 
    end
    receiverReadOut = [receiverReadOut readOutStorage(readOut)];
end

%% create beamformer
finalAngleStorage = zeros(2*length(receivers),length(sources));
guess_set = [];
guess_error = [];
delayStorage = zeros(length(receivers),length(sources));
calculatedAngleStorage = zeros(2,length(receivers));
for i = 1:length(receivers)
    m = (i-1)*2+1;
    [t_u d angleStorage] = beamformer_analytic(receivers(i).arrayPattern,sources,receiverReadOut(i).data,STSS,t_array);
    finalAngleStorage(m:m+1,:) = angleStorage;
    [sensor_guess_set, error_optimization, finalDelay,  calculatedAngleStorage] = optimalisation_analytic(sources,receiverReadOut(i).data,receivers(i),d,STSS,t_array,medium_speed,x0,angleStorage);
    guess_set = [guess_set; sensor_guess_set];
    guess_error = [guess_error error_optimization];
    calculatedAngleStorage(:,i) = mean(calculatedAngleStorage,2);
    delayStorage(i,:) = finalDelay;
    scatter(sensor_guess_set(1),sensor_guess_set(2),'pr')
end

h = zeros(4, 1);
h(1) = plot(0,0,'ob', 'visible', 'off');
h(2) = plot(0,0,'xb', 'visible', 'off');
h(3) = plot(0,0,'xr', 'visible', 'off');
h(4) = plot(0,0,'pr', 'visible', 'off');
legend(h, 'receiver','source','mirror source','estimated receiver');

%legend("Original Source","Mirror Source","Original Receiver","Estimated Receiver")

function [mirrorPoint] = reflect(source,surface)
% MYMEAN Local function that calculates mean of array.
    vector = surface.p1-surface.p2;
    b = source.position(1:2)-surface.p1;
    
    normal = [vector(2) -vector(1)];
    normal = normal/sqrt(normal(1)^2+normal(2)^2);
    b = [b;0];
    a = [vector;0];
    dis = norm(cross(a,b)) / norm(a);
    normal = normal.*dis*2*-1;
    normal = [normal 0];
    mirrorPoint = sourceClass(source.position+normal',surface);
end

function [result] = createReflectionMap(source,surface)
 result = [source];
 for wallObject = surface
    for sourceObject = source
        if not(isequal(sourceObject.surface,wallObject))
        result = [result reflect(sourceObject, wallObject)];
        end
    end
 end
end

function [microphoneReadouts, timeSet] = soundSimulation(sources,microphones,medium_speed,STSS,t_array)
timeSet = 0:t_array(2):0.1;
microphoneReadouts = [];
for microphone = microphones'
   soundLine = 0*timeSet;
   for source = sources
      dis_vector = microphone - source.position;
      distance = sqrt(dis_vector(1)^2+dis_vector(2)^2+dis_vector(3)^2);
      delay = distance/medium_speed;
      sound = STSS/(distance);
      temp = abs(timeSet - delay);
      closest = find(temp == min(temp));
      soundLine(closest:closest+length(sound)-1) = soundLine(closest:closest+length(sound)-1)+sound;
   end
  microphoneReadouts = [microphoneReadouts; soundLine];
end
end



source_mag = 300;     % [Pa]

f = 2e3:5:6e3
Ts = 8.3e-3
t_array = linspace(0,Ts,length(f))
STSS = source_mag*sin(2*pi*f.*t_array)

%walls on stratum
%up is x lower is y
wallSet = [wall([15; 7],[0; 7]); wall([0; 0],[43; 0]); wall([19.5; 7],[43; 7]); wall([15; 7],[15; 32]); wall([19.5;7],[19.5; 32])];

%set initial source
sources = [sourceClass([7.5;5.5;1],[]) sourceClass([25;3.5;1],[]) sourceClass([9.5;1.5;1],[]) sourceClass([40; 3; 1],[])] %sourceClass([25; 3; 1],[]) 
medium_speed = 340;

load('data/sunFlowerArray.mat')

receivers = [receiverClass([sunFlowerArray(:,1)+15 sunFlowerArray(:,2)+5 sunFlowerArray(:,3)+3]) receiverClass([sunFlowerArray(:,1)+30 sunFlowerArray(:,2)+5 sunFlowerArray(:,3)+3]) receiverClass([sunFlowerArray(:,1)+17 sunFlowerArray(:,2)+5 sunFlowerArray(:,3)+3])]


%plot information
for receiver = receivers
    plot(receiver.arrayPattern(1,1),receiver.arrayPattern(1,2),'ob')
    hold all
end
xlim([-5 45])
ylim([-5 35])
x = []
y = []

for m = 1:length(wallSet)
 x = [wallSet(m).p1(1) wallSet(m).p2(1)];
 y = [wallSet(m).p1(2) wallSet(m).p2(2)];
 hold all
 line(x,y,'color','black')
end

%% plot the reflections


%% calculate the final sound readOut
receiverReadOut = []

for receiver = receivers
    readOut = [];
    for i = 1:length(sources)
        [results]  = createReflectionMap(sources(i),[wallSet(1) wallSet(2)]);
        [results]  = createReflectionMap(results,[wallSet(1) wallSet(2)]);
        hold all
        for point = results
            plot(point.position(1),point.position(2),'xr')
        end
        plot(results(1).position(1),results(1).position(2),'xb')
        [microphoneResults, timeSet] = soundSimulation(results,receiver.arrayPattern,medium_speed,STSS,t_array);
        readOut = [readOut; microphoneResults]; 
    end
    receiverReadOut = [receiverReadOut readOutStorage(readOut)]
end

%% create beamformer
finalAngleStorage = zeros(2*length(receiver),length(sources))
guess_set = []
guess_error = []
for i = 1:length(receivers)
    m = (i-1)*2+1;
    [t_u d angleStorage] = beamformer_analytic(receivers(i).arrayPattern,sources,receiverReadOut(i).data,STSS,t_array)
    finalAngleStorage(m:m+1,:) = angleStorage;
    [sensor_guess_set, error_optimization] = optimalisation_analytic(sources,receiverReadOut(i).data,receivers(i),d,STSS,t_array,medium_speed)
    guess_set = [guess_set; sensor_guess_set];
    guess_error = [guess_error error_optimization];
end

function [mirrorPoint] = reflect(source,surface)
% MYMEAN Local function that calculates mean of array.
    vector = surface.p1-surface.p2
    b = source.position(1:2)-surface.p1
    
    normal = [vector(2) -vector(1)]
    normal = normal/sqrt(normal(1)^2+normal(2)^2)
    b = [b;0]
    a = [vector;0]
    dis = norm(cross(a,b)) / norm(a)
    normal = normal.*dis*2*-1;
    normal = [normal 0]
    mirrorPoint = sourceClass(source.position+normal',surface)
end

function [result] = createReflectionMap(source,surface)
 result = [source]
 for wallObject = surface
    for sourceObject = source
        sourceObject
        wallObject
        if not(isequal(sourceObject.surface,wallObject))
        result = [result reflect(sourceObject, wallObject)]
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


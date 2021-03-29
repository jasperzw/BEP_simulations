source_freq = 1e3;  % [Hz]
source_mag = 300;     % [Pa]

Ts = 5/source_freq
t_array = linspace(0,Ts,1000);


source = source_mag * sin(2 * pi * source_freq * t_array);
cond = (source > -source_mag/40) & (source < source_mag/40)
set = find(cond)

source(1:set(3)) = 0;
source(set(5):end) = 0;

%walls on stratum
%up is x lower is y
wallSet = [wall([15; 7],[0; 7]); wall([0; 0],[43; 0]); wall([19.5; 7],[43; 7]); wall([15; 7],[15; 32]); wall([19.5;7],[19.5; 32])];

source = [7.5;3.5]
receiver = [15; 5]
plot(source(1),source(2),'x')
hold all
plot(receiver(1),receiver(2),'o')
xlim([-5 45])
ylim([-5 35])
x = []
y = []

for m = 1:length(wallSet)
 x = [wallSet(m).p1(1) wallSet(m).p2(1)]
 y = [wallSet(m).p1(2) wallSet(m).p2(2)]
 hold all
 line(x,y,'color','black')
end



%  function computeImageSources(maxOrder) 
%      for order = 1 to maxOrder do 
%          for each source in sources do if source.order == (order - 1) 
%              for each surface in geometry do if (surface != source.reflecor) 
%                  newSource = reflect(source, surface) 
%                  newSource.reflector = surface 
%                  sources[nofSources++] = newSource
[vector normal, mirrorPoint]  = reflect(source,wallSet(1))
hold all
plot(mirrorPoint(1),mirrorPoint(2),'x')

function [vector normal, mirrorPoint] = reflect(source,surface)
% MYMEAN Local function that calculates mean of array.
    vector = surface.p1-surface.p2
    b = source-surface.p1
    
    normal = [vector(2) -vector(1)]
    normal = normal/sqrt(normal(1)^2+normal(2)^2)
    b = [b;0]
    a = [vector;0]
    dis = norm(cross(a,b)) / norm(a)
    normal = normal.*dis*2*-1;
    mirrorPoint = source+normal' 
end
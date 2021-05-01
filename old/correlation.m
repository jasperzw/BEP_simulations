data = sensor_data.p
signal = source.p
timeStep = kgrid.dt
corr = []
delay = []
for i = 1:length(data(:,1))
    r = xcorr(signal,data(i,:));
    corr = [corr; r];
    delay = [delay; find(r==max(r))*timeStep];
end


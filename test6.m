snd = load_sound(filenames(MeasureSet(5)), 0, 1, nArray, dataSet);
if dataSet == 2
temp = snd.data(65:end,:);
snd.data(end-63:end,:) = snd.data(1:64,:);
snd.data(1:64*2,:) = temp;
end

workFile = snd.data(26,:);
y = (0:length(workFile)-1)/snd.fs;
workFile = bandpass(workFile,[2.5e3 6.5e3],snd.fs);
testFile = bandpass(snd.data(end-64+28,:),[2.5e3 6.5e3],snd.fs);
%workFile = smooth(workFile,10);

subplot(3,1,1)
plot(y,workFile)
xlim([0 0.01])



subplot(3,1,2)
[x y] = xcorr(testFile,calibrationEmittence);
y = y/snd.fs;
pos = find(y>=0);
x = x(pos:end);
y = y(pos:end);
plot(y,x)

index1 = y(find(x==max(x)));

subplot(3,1,3)
[x y] = xcorr(workFile,calibrationEmittence);
y = y/snd.fs;
pos = find(y>=0);
x = x(pos:end);
y = y(pos:end);
plot(y,x);

posBegin = find(y==index1);
posEnd = posBegin+50e-3*snd.fs;
xSet = x(posBegin:posEnd);
index = find(x == max(xSet));

difference = (index-posBegin)/snd.fs



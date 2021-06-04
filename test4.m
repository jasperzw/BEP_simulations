[x_1 y_1] = xcorr(finalStore(3,:),calibrationEmittence);
[x_2 y_2] = xcorr(calStore(3,:),calibrationEmittence);
[finalX y] = xcorr(x_2,x_1);
smoothedX = smooth(finalX,0.02,'loess');

y = y/snd.fs;
index = y(find(smoothedX==max(smoothedX)))
subplot(3,1,1)
plot(y_1,x_1);
subplot(3,1,2)
plot(y_2,x_2);
subplot(3,1,3)
plot(y,finalX);
hold all
plot(y,smoothedX);


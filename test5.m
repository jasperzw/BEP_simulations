plotFile = 1;
subplot(5,1,1)
[x y] = xcorr(finalStore(plotFile,:),calStore(plotFile,:));
y = y/snd.fs;
pos = find(y>=0,1);
x = x(pos:end); 
y = y(pos:end);
plot(y,x)
xlim([0.015 0.065])
%plot(t_set,snd.data(ishMiddle,:))
xlim([0.015 0.065])
title("receiver,cal correlation")
subplot(5,1,2)
plot(t_set,finalStore(plotFile,:))
xlim([0.015 0.065])
title("beamformer result")
subplot(5,1,3)
plot(t_set,calStore(plotFile,:))
xlim([0.015 0.065])
title("middle calibration array mic")
subplot(5,1,4)
[x y] = xcorr(finalStore(plotFile,:),calibrationEmittence);
y = y/snd.fs;
plot(y,x)
xlim([0.015 0.065])
yline(std(x)*sensivity);
title("correlation beamformer")
subplot(5,1,5)
[x y] = xcorr(calStore(plotFile,:),calibrationEmittence);
y = y/snd.fs;
plot(y,x)
xlim([0.015 0.065])
yline(std(x)*sensivity-2);
title("correlation calibration middle mic")

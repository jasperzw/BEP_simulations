[x t] = xcorr(receiverReadOut(1).data(1,:),STSS);
s = std(x)*10+0*t
f = x(find(x>s))
c = findpeaks(f)
m = find(x==c(1));
d = t(m)
plot(t,x)
hold all
plot(t,s)
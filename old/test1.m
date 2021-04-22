[x set] = xcorr(readOut(1,:),STSS)

%grab only positive
index = find(set==0)
x = x(index:end)
[pks loc] = findpeaks(x)
highest = maxk(pks,4)
index = length(highest)
for i = 1:length(highest)
index(i) = find(x == highest(i))
end

result = min(index)

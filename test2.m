x = (0:0.02:0.02*7)-0.07;
y = -x;

squareGrid = zeros(64,2);

for i = 1:64
row = floor(((i-1)/8))+1
i
squareGrid(i,:) = [x(end-((i-8*(row-1))-1)) y(row)]
end

save("data/squareGrid.mat","squareGrid");
t = zeros(30,amountSources);
for i = 1:amountSources
    %check arrival time left side
    for n = 1:15
        p = sensor_data(i).left(n,:);
        temp = find(p>=0.01)*timeStep;
        t(n,i) = temp(1);
    end
    %check arrival time right side
    for n = 1:15
        p = sensor_data(i).right(n,:);
        temp = find(p>=0.01)*timeStep;
        t(n+15,i) = temp(1);
    end 
end
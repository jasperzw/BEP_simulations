calculatedAngleStorage = zeros(2,length(sources));
angleStorage = finalAngleStorage(1:2,:);
x = guess_set(1,:);
for m = 1:length(sources)
   vector = x' - sources(m).position;
   cross = sqrt(vector(1)^2+vector(2)^2);
   
   if vector(1)>0 & vector(2)>0 
   	inclinationOriginal = asind(abs(vector(2))/cross)
   end
   if vector(1)<=0 & vector(2)>0
    inclinationOriginal = 90+asind(abs(vector(1))/cross);
   end
   if vector(1)<=0 & vector(2)<=0
    inclinationOriginal = 180 + asind(abs(vector(2))/cross);
   end
   if vector(1)>0 & vector(2)<=0
        inclinationOriginal = 270 + asind(abs(vector(1))/cross);
   end
   azimuthOriginal = acosd(abs(vector(3))/cross);
   azimuthFinal = azimuthOriginal-angleStorage(1,m);
   inclinationFinal = inclinationOriginal-angleStorage(2,m);
   calculatedAngleStorage(1,m) = azimuthFinal';
   calculatedAngleStorage(2,m) = inclinationFinal;
end
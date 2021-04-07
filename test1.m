microphones = sunFlowerArray
sources = results
timeSet = 0:t_array(2):2;
microphoneReadouts = []
for microphone = microphones'
   soundLine = 0*timeSet;
   for source = sources
      dis_vector = microphone - source.position;
      distance = sqrt(dis_vector(1)^2+dis_vector(2)^2+dis_vector(3)^2);
      delay = distance/medium_speed;
      sound = STSS/(4*pi*distance^2)
      temp = abs(timeSet - delay);
      closest = find(temp == min(temp))
      soundLine(closest:closest+length(sound)-1) = soundLine(closest:closest+length(sound)-1)+sound
   end
  microphoneReadOuts = [microphoneReadouts; soundLine]
end
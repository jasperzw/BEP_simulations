classdef receiverClass
    %RECEIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        arrayPattern
        inclination
        azimuth
        directionVector
        orientationVector
    end
    
    methods
        function obj = receiverClass(microphonePosition,inclination,azimuth,directionVector,orientationVector)
            %RECEIVER Construct an instance of this class
            %   Detailed explanation goes here
            obj.arrayPattern = microphonePosition;
            obj.inclination = inclination;
            obj.azimuth = azimuth;
            obj.directionVector = directionVector;
            obj.orientationVector = orientationVector;
        end
    end
end


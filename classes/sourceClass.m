classdef sourceClass
    %SOURCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        surface
        position
    end
    
    methods
        function obj = sourceClass(positionSet, surfaceSet)
            obj.surface = surfaceSet;
            obj.position = positionSet;
        end
    end
end


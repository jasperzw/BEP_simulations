classdef runTime
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
        sourceCoordinates
    end
    
    methods
        function obj = runTime(F,coordinates)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.left = F(1:15,:);
            obj.right = F(16:30,:);
            obj.sourceCoordinates = coordinates;
        end
    end
end


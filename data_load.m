function [sensivity sources MeasureSet] = data_load(index)
%DATA_LOAD Summary of this function goes here
%   Detailed explanation goes here
switch index
    case 1 %calibration close
        MeasureSet = [69 73 31 71 74]; 
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4;
        
    case 2 %calibration far
        MeasureSet = [70 73 31 72 75]; 
        sources = [sourceClass([1.3 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 0.4 0],[]); sourceClass([2.3 2.4 0],[])]; %sources far 
        sensivity = 3.1;
        
    case 3 %15 inclination
        MeasureSet = [2 4 1 3 5];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 5;
        
    case 4 %30 inclination
        MeasureSet = [7 9 6 8 10];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;

    case 5 %45 inclination
        MeasureSet = [12 14 11 13 15];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;

    case 6 %60 inclination
        MeasureSet = [17    19    16    18    20];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 3;

    case 7 %75 inclination
        MeasureSet = [22    24    21    23    25];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 2.5;
        
    case 8 %90 inclination
        MeasureSet = [27    29    26    28    30];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        
    case 9 %45 azimuth
        MeasureSet = [45 47 49 46 48];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 3.6;
end
end


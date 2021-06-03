function [sensivity sources MeasureSet coordinatesReceiver nArray] = data_load(set,index)
%DATA_LOAD Summary of this function goes here
%   Detailed explanation goes here
nArray = 2;

if set == 1
switch index
    case 1 %calibration close
        MeasureSet = [69 73 31 71 74]; 
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(90)]];
        
    case 2 %calibration far
        MeasureSet = [70 73 31 72 75]; 
        sources = [sourceClass([1.3 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 0.4 0],[]); sourceClass([2.3 2.4 0],[])]; %sources far 
        sensivity = 3.1;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(90)]];
        
    case 3 %15 inclination
        MeasureSet = [2 4 1 3 5];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(15) deg2rad(90)]];
        
    case 4 %30 inclination
        MeasureSet = [7 9 6 8 10];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(30) deg2rad(90)]];

    case 5 %45 inclination
        MeasureSet = [12 14 11 13 15];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(45) deg2rad(90)]];

    case 6 %60 inclination
        MeasureSet = [17    19    16    18    20];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 3;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(60) deg2rad(90)]];

    case 7 %75 inclination
        MeasureSet = [22    24    21    23    25];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 2.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(75) deg2rad(90)]];
        
    case 8 %90 inclination
        MeasureSet = [27    29    26    28    30];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(90) deg2rad(90)]];
        
    case 9 %15 azimuth
        MeasureSet = [34 36 33 35 37];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(-15+90)]];
        
    case 10 %30 azimuth data seems a bit strange possibily broken
        MeasureSet = [40 42 39 41 43];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(-30+90)]];
        
    case 11 %45 azimuth
        MeasureSet = [45 47 44 46 48];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 3.6;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(-45+90)]];
        
    case 12 %60 azimuth
        MeasureSet = [55 57 54 56 58];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(-60+90)]];
        
    case 13 %75 azimuth
        MeasureSet = [60 62 59 61 63];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(-75+90)]];
        
    case 14 %90 azimuth
        MeasureSet = [65 67 64 66 68];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.5;
        coordinatesReceiver = [[1 1.4 1.5 deg2rad(0) deg2rad(-90+90)]];
end
end

if set == 2
    switch index
        case 1 % calibration
        MeasureSet = [132 130 128 129 131];
        sources = [sourceClass([2 1.4 0],[]); sourceClass([2.3 1.4 0],[]); sourceClass([2.6 1.4 0],[]); sourceClass([2.3 1.1 0],[]); sourceClass([2.3 1.7 0],[])];  %sources close
        sensivity = 4.3;
        coordinatesReceiver = [[1 1.4 1.05 deg2rad(0) deg2rad(90)]];
        nArray = 3;
        
        case 2 % 5 meter
        MeasureSet = [88 86 98 85 87];
        d = 5;
        sources = [sourceClass([d-2 2 0],[]); sourceClass([d 2 0],[]); sourceClass([d+2 2 0],[]); sourceClass([d 0 0],[]); sourceClass([d 4 0],[])];  %sources close
        sensivity = 2;
        coordinatesReceiver = [[0 -0.65+2 1.05 deg2rad(0) deg2rad(90)]];
        nArray = 3;

        case 3 % 6 meter
        MeasureSet = [83 95 101 94 96];
        d = 6;
        sources = [sourceClass([d-2 2 0],[]); sourceClass([d 2 0],[]); sourceClass([d+2 2 0],[]); sourceClass([d 0 0],[]); sourceClass([d 4 0],[])];  %sources close
        sensivity = 2;
        coordinatesReceiver = [[0 -0.65+2 1.05 deg2rad(0) deg2rad(90)]];
        nArray = 3;
        
        case 4 % 7 meter
        MeasureSet = [86 98 109 97 99];
        d = 7;
        sources = [sourceClass([d-2 2 0],[]); sourceClass([d 2 0],[]); sourceClass([d+2 2 0],[]); sourceClass([d 0 0],[]); sourceClass([d 4 0],[])];  %sources close
        sensivity = 2;
        coordinatesReceiver = [[0 -0.65+2 1.05 deg2rad(0) deg2rad(90)]];
        nArray = 3;
        
        case 5 % 8 meter
        MeasureSet = [95 101 77 100 102];
        d = 8;
        sources = [sourceClass([d-2 2 0],[]); sourceClass([d 2 0],[]); sourceClass([d+2 2 0],[]); sourceClass([d 0 0],[]); sourceClass([d 4 0],[])];  %sources close
        sensivity = 2;
        coordinatesReceiver = [[0 -0.65+2 1.05 deg2rad(0) deg2rad(90)]];
        nArray = 3;
        
        case 6 % 9 meter
        MeasureSet = [98 109 76 108 110];
        d = 9;
        sources = [sourceClass([d-2 2 0],[]); sourceClass([d 2 0],[]); sourceClass([d+1.4 2 0],[]); sourceClass([d 0 0],[]); sourceClass([d 4 0],[])];  %sources close
        sensivity = 2.8;
        coordinatesReceiver = [[0 -0.65+2 1.05 deg2rad(0) deg2rad(90)]];
        nArray = 3;
    end
end
end


% Simulations In Three Dimensions Example
%
% This example provides a simple demonstration of using k-Wave for the
% simulation and detection of a time varying pressure source within a
% three-dimensional heterogeneous propagation medium. It builds on the
% Monopole Point Source In A Homogeneous Propagation Medium Example and
% Simulations In Three Dimensions examples.    
%
% author: Bradley Treeby
% date: 20th January 2010
% last update: 4th May 2017
%  
% This function is part of the k-Wave Toolbox (http://www.k-wave.org)
% Copyright (C) 2010-2017 Bradley Treeby

% This file is part of k-Wave. k-Wave is free software: you can
% redistribute it and/or modify it under the terms of the GNU Lesser
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
% 
% k-Wave is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
% more details. 
% 
% You should have received a copy of the GNU Lesser General Public License
% along with k-Wave. If not, see <http://www.gnu.org/licenses/>. 

clearvars; 

% =========================================================================
% SIMULATION
% =========================================================================

% create the computational grid
Nx = 64;            % number of grid points in the x direction
Ny = 100;            % number of grid points in the y direction
Nz = 64;            % number of grid points in the z direction
dx = 0.1e-3;        % grid point spacing in the x direction [m]
dy = 0.1e-3;        % grid point spacing in the y direction [m]
dz = 0.1e-3;        % grid point spacing in the z direction [m]
kgrid = kWaveGrid(Nx, dx, Ny, dy, Nz, dz);

% define the properties of the propagation medium
medium.sound_speed =  340;	% [m/s]
medium.density = 1.2 * ones(Nx, Ny, Nz);       % [kg/m^3]
medium.alpha_coeff = 0.75;  % [dB/(MHz^y cm)]
medium.alpha_power = 1.5; 

% create the time array
kgrid.makeTime(medium.sound_speed,[],6e-5);

% define a square source element
source_amount = 1;  % [grid points]
x_offset = 50;
z_offset = 20;
source.p_mask = zeros(Nx, Ny, Nz);
for i = 1:source_amount
    source.p_mask(x_offset+i*10,10,z_offset)=1;
end

% define a time varying sinusoidal source
source_freq = 1e5;  % [Hz]
source_mag = 300;     % [Pa]
source.p = source_mag * sin(2 * pi * source_freq * kgrid.t_array);
cond = (source.p > -source_mag/40) & (source.p < source_mag/40)
set = find(cond)
source.p(1:set(3)) = 0;
source.p(set(5):end) = 0;

%possibility of a STSS ussage how ever simulation can not support.
f = 6e4:12e4
Ts = 8.3e-3
t = linspace(0,Ts,length(f))
STSS = sin(2*pi*f.*t)

% filter the source to remove high frequencies not supported by the grid
source.p = filterTimeSeries(kgrid, medium, source.p);



% define a series of Cartesian points to collect the data
%sensor_radius = 5;
sensor.mask = zeros(Nx, Ny, Nz);
%sensor.mask(Nx/4, Ny/2 - sensor_radius:Ny/2 + sensor_radius, Nz/2 - sensor_radius:Nz/2 + sensor_radius) = 1;
load('sunFlowerArray.mat');
sunFlowerArray = ((sunFlowerArray+0.07)*450)+1
roundedArray = round(sunFlowerArray);
for i = 1:64
    sensor.mask(roundedArray(i,1),Ny-10,roundedArray(i,2)) = 1;
end

%comparing the sunflower formation
% scatter(sunFlowerArray(:,1),sunFlowerArray(:,2))
% hold all
% scatter(roundedArray(:,1),roundedArray(:,2),'x')
% legend("original formation","rounded formation")

% define the field parameters to record
sensor.record = {'p', 'p_final'};

% input arguments
input_args = {'DisplayMask', source.p_mask, 'DataCast', 'single', ...
    'CartInterp', 'nearest'};

% run the simulation
sensor_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});

% =========================================================================
% VISUALISATION
% =========================================================================

% view final pressure field slice by slice
%flyThrough(sensor_data.p_final);

% plot the position of the source and sensor
voxelPlot(double(source.p_mask | sensor.mask));

% plot the simulated sensor data
figure;
imagesc(sensor_data.p);
colormap(getColorMap);
ylabel('Sensor Position');
xlabel('Time Step');
colorbar;
## Table of contents
* [General info](#general-info)
* [Simulations](#simulations)
* [Beamforming](#beamforming)
* [Optimalisation](#optimalisation)
* [Transformation](#transformation)

## General info
simulation for my BEP to create acoastic position calibration for microphone array's

## Simulations
The simulations consist out of:
* TOA2d.m 
* TOA3d.m

The k-wave library is used to simulate an audio wave in an air medium to generate information. The 2d has 2 array's in the middle with a random number of sources surrounding it to generate audio waves for further process

The 3d simulation has a square array with a single source to perform beamforming and reverberation

## Beamforming
The beamforming consist out of:
* delayCalculation.m
* beamForming.m

delayCalculation.m is a function which accept a linear array as input and calcuates the angle delay array at a specific frequency

beaforming.m peforms phase shift to obtain the original signal on which optimalisation can be performed.

## Optimalisation
To conclude a the final position a optimalisation problem is solved in optimalisation.m which conclused in a set of coordinates

## Transformation
The final result will be different coordinate set in a different frame. transformation.m will find intersection of microphones in both sets and use SVD to generate a rotation and transformation matrix to transform all sets into a common frame.
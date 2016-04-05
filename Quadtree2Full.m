function [zz,res]=Quadtree2Full(Sasc);
% Quadtree2Full  - Interpolates quadtree sampled data to a full set
%
% function [zz,res]=Quadtree2Full(Sasc);
% 
% This function recreates the full interferogram from Quadtree data
%
% Input:
% Sasc          (structure array) has to include:
%
%  Sasc.im      (nxm) - unwrapped interferogram
%  Sasc.AxX     (1xm) - vec of x-coordinates (km)
%  Sasc.AxY     (1xn) - vec of y-coords. (km)
%  Sasc.cnt     (2xk) - coord matrix for quadtree squares
%  Sasc.sv      (kx1) - vec of quadtree values
%
%
% Output:
%   zz          (nxm) - interpolated unwrapped interferogram 
%   res         (nxm) - residual between the original and zz


% make meshgrid
[xx,yy]=meshgrid(Sasc.AxX,Sasc.AxY);

% get center coordinate of each quadtree square
x = Sasc.cnt(1,:)';
y = Sasc.cnt(2,:)';

% get quadtree square value:
z = Sasc.sv;

% Do interpolation
disp('---> Interpolating using "griddata"');
zz = griddata(x,y,z,xx,yy);

% Calculate res
res = Sasc.im - zz;

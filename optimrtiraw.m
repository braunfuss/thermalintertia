%This is the funtion for raw calculation of the thermal inertia propeties

% PREPARE BOUNDS and Setup ON MODEL
% each of the following coloumns is the upper and lower boundary of one of
% the parameters that are optimized. This can be extended if the objective
% function is modified accordingly
% The raw physical properties are calculated here. This modell assumes a
% two layerd (eg. soil and vegetation) halfspace. It can be extended
% Here [Albedo heat_capacity_1 density_1 thermal_conductivity_1  heat_capacity_2 density_2 thermal_conductivity_2 ]
% the values below are representative for a wide range of rocks. For
% vegetation different values have to be used.
lb = [0.1 0.8 2.0 1.2 0.8 2.0 1.2];
ub = [1 0.9 3.0 5.0 0.9 3.0 5.0 ];

% 
% now arethe 
 sol= 12.39; %solar incidence angle. Has to be looked up or calculated if not measured in field. 
 lat= 51.8;% latitude of the measurment
% sol= 12.39; %potsdam
%  lat= 52.4;%potsdam
  image1= quarzit10; %thermal image input file 1
  image2= quarzit16; %thermal image input file 2

%   image1= potsdam5;
%  image2= potsdam14;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here comes the subsampling with a quadtree function. This is optional but
% reduces computional cost
delta = image2 - image1; 
 I1=image1; %morning image as array input
I2= image2;%midday image as array inputn
[m,n]= size (I1);

coord = [1:m ; 1:m ]
 tol = 0.8; %variance threshold 0.004 standard
sl = 4; %start level of Quadtree (1 is 4 boxes, 2 is 4 by 4 boxes etc) 5 standard
mxd = 8; %maximum level (quadtrees with 4 pixels only are not that meaningful...) 8 standard
%the quadtree fct is from J ́onsson, S., Zebker, H.A., Segall, P. & Amelung, F., 2002. Fault slip distri-
% bution of the 1999 Mw7.2 Hector Mine earthquake, California, estimated
% from satellite radar and GPS measurements, Bull. seism. Soc. Am., 92(4),
% please cite this if use it. During the supsampling a image will pop open.
% You can select quadtrees with the left mouse (draw rectangle) to exclude
% them. With right mouse you accept the image as it is. It will be used for
% all runs. 

[ce,cn,cnt,sv]=QuadtreeFct(delta,coord,tol,1,sl,mxd);

%[ce_ref,cn_ref,cnt_ref,sv_ref]=QuadtreeFct(I1,coord,tol,1,sl,mxd);


%Here we want to keep track which pixels are in what quadtreeebox
% (needed for building Covar-matrix later on)
geo_par=[size(I1,1) max(coord(2,:)) min(coord(1,:)) (coord(2,2)-coord(2,1)) (coord(1,2)-coord(1,1))];
[ass_m,qfoc]=Patch_vs_Pix(delta,geo_par,ce,cn,sv);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This scripts runs the non-linear optimization search, both simulated annealing
% and the gradient based method afterwards to check for stability

% Number of independent runs:
Nruns = 5;


X0 = [0.5 0.8 3.0 1.2 0.8 3.0 1.2];   % Starting point for each input parameter, if no a priori knowledge just use the middle of the upper and lower boundaries


%now you can select the mode. Mode 1 is calculating 
mode=1;

outfile=strcat('tirun_'); % name of the outfile, it will be appended with the number of each indepent run. This way each indepent run is saved into a different 

result= [];
misfittotal= [];

% now comes the main loop
for k=1:Nruns;

for l=1:length(sv)
    %ObjectiveFunction can be changed.
    
ObjectiveFunction = @(A) parameterized_objectiveraw(A,sol,lat,image1,image2,sv(l),mode);

[x,fval,exitFlag,output] = simulannealbnd(ObjectiveFunction,X0,lb,ub); %the simulated annealing
result= [result x];
misfittotal= [misfittotal fval];
 fprintf('The number of iterations was : %d\n', output.iterations);
 fprintf('The number of function evaluations was : %d\n', output.funccount);
 fprintf('The best function value found was : %g\n', fval);

  %-----------------------------------------------------------------
  
  %gridsearch using sim aneal solution as starting point, 
  %dient nur der Stabilitätsprüfung des miniums
  
 
  
 [mstar,resnorm,residual]  = lsqnonlin(ObjectiveFunction,x);

 

end
misfit= sum( (abs((misfittotal).^2)).^1/2)

  save(strcat(outfile,num2str(k)), 'x', 'mstar', 'misfit', 'result', 'misfittotal');

end


%optionale anzeige des ergebnisses in quadtrees
  patch(ce, cn, sv); axis image; hold on  %%plot function
  figure;
  result1= result(1:2:end); 
  patch(ce, cn, result1); axis image; hold on  %%plot function
%end

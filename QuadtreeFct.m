function [ce,cn,cnt,sv]=QuadtreeFct(ig,coord,tol,type,sl,mxd);
% function [ce,cn,cnt,sv]=QuadtreeFct(ig_unw,coord,tol,type,sl,mxd););
% tol:  deviation threshold of quadtree boxes
% type:  (0) - Mean ;(1)- Median ;(2) - RMS
% sl:   minimum division in range and azimuth
% mxd:  maximum division, maximum level of division
%
% QuadtreeExample - An example on how to use quadtree sub-sampling routines
%
% This script has an example of how to use the quadtree
% functions to decimate Insar data
%
% Sigurjon Jonsson, 28 Oct 2002


% Bugs:
% 1) The function has 'for' loops, and can be pretty slow
% if the datamatrix is big, or if you go to very fine,
% pixelsize decimation.  I never bothered to optimize the
% coding, as I was always only working with small image
% subsets, one day I'll speed this up.
% 
% 2) When the image size is now a power of 2, e.g. 5 12x512,
% then the code will add what is needed to make it a power
% of 2.  Therefore, when subsampled, it sometimes looks a bit
% oversampled along the edges (as well as along edges where
% there is missing data (where it didn't unwrap, etc)). This
% can be adjusted, of course, but the scripts don't include
% any adjustment options of this kind.
% 
% 3) I have sometimes had problem plotting quadtree data under
% windows using Matlab 6.  It is a problem with the
% function 'patch' (one of Matlab's own functions!).  This 
% function causes Matlab 6 to crash, sometimes.  I never
% bothered writing my own plotting function, but 'plot_quadtree'
% calls this Matlab function.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT DATA

% Load data, it has to be a rectangular matrix of unwrapped
% phase values.  It is convenient to scale the phase values
% so the show 'meters of range change' or 'meters of LOS
% displacement, etc.  The size of the rectangular matrix is not
% important, it's dimensions will be expanded to be a power of 2.
% WARNING:  If the matrix is very big (>10^7 entries), then
% this script is going to be slow.
% If the matrix has holes (e.g. areas that didn't unwrap), they
% should have matrix entries 'NaN' (e.g., see example 2)
%load dataexample1
%load dataexample2
%addpath ~/matlab/quadtree/



% smoothing of mask possible
% [mask_asc]=SmoothMask_func(mask_asc,4,4,15,10);

% clean mask, remove certain features...
% [mask_asc]=CleanMask(asc_array,mask_asc);

% Please indicate pixelsize in meters (or anything you want);
pixsiz_e = coord(1,2)-coord(1,1)
pixsiz_n = coord(2,2)-coord(2,1)


% figure settings
set(0,'Units','pixels')
scnsize = get(0,'ScreenSize');
topwidth=70;
% Define the size and location of the figures:
% top right
pos1  = [3*scnsize(3)/5,2*scnsize(4)/3-topwidth,2*scnsize(3)/5,scnsize(4)/3];
% bottom right
pos2  = [3*scnsize(3)/5,-scnsize(4)/100,2*scnsize(3)/5,scnsize(4)/3];
% top left
pos3  = [scnsize(3)/200,scnsize(4)/5-topwidth,2*scnsize(3)/5,4*scnsize(4)/5];







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% INPUT PARAMETERS FOR SUBSAMPLING

% Put tolerance threshold for the subsampling.  This value should be
% in same units as the image (eg. meters), and it should be selected
% so it capture most of the signal, but does not subsamble much of
% the noise (ideally).  For each quadtree square the RMS value (between
% datapoints in a quadtree square and (e.g.,) the mean of these data-
% points) is calculated.  If the RMS value is greater than 
% the threshold value, then we split up that square again into
% four new (smaller) parts, otherwise, we assign (e.g.,) the mean value
% to the center of the box.  If you start with a very low value for
% your data-set, then it is going to be very slow.  Therefore, it
% is better to start with a large value, and then decrease it in
% the next run.
%tol = 0.009;    % only 2.2 cm

% Here we select how we fit the data and compare to the tolerance value:
% type=0   Here we simply calculate the MEAN of the square values and 
%          then compare if the RMS about the MEAN is greater than the tolerance
% type=1   Here we assign the MEDIAN of square values to the square if the
%          RMS about the MEAN is smaller than the threshold
% type=2   Here we calculate the RMS about a bilinear plane and compare it
%          to the tolerance.  When smaller than the tolearnce we assign the
%          MEDIAN to the center coordinate (yes, I know it is nonlinear)
%type=1;

% Here we select the maximum size of quadtree squares.  Ideally, they shouldn't
% be larger than the max. correlation distance within the data (which depends
% on the size of the image).  I recommend that the largest quadtree square
% to be smaller than ca. 1/10 of the image dimension. Using sl=3 will give
% you at least 8x8 quadtree boxes, and sl=4, will give you at least 16x16.
%sl  = 3;

% Here we select the maximum number of quadtree levels.  We do this to avoid
% going down to pixel-size partioning.
%mxd = 7;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% RUN QUADTREE SUBSAMPLING

% Quadtree subsampling:
[indmat,sqval,cx,cy,cntp,matsize] = quadtree_part(ig,tol,type,sl,mxd);

% OUTPUT:
% indmat - is the output quadtree index matrix, nothing that is generally 
%          important in following 
% sqval  - Is (1xn) rowvector of values assigned to each quadtree square
% cx,cy  - Are (4xn) matrices for x,y locations for quadtree square cornerpoints
%          this is useful to plot with 'patch'
% cntp   - Is (2xn) matrix of coordinates for the center location of each square
% matsize- Is simply the size of expanded datamatrix (not important)

%%%%%%%%%%%%%% remove patches %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nnn=sqval;
figure
patch(cx,cy,nnn); axis image

button=1;

while (button==1)

	nnn=removepatches(cntp,nnn ,cx,cy);
	[dum,dum,button]=ginput(1);
	if (button==1); nnn =removepatches(cntp,nnn,cx,cy); end
	[dum,dum,button]=ginput(1);
end
sqval=nnn;
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PLOTTING

% Convert coordinates into KM (xy-style, instead of lin/col):
% NOTE: It is a common mistake to confuse x and y coordinates, be
% careful....
ce  =  cx*pixsiz_e /1e3;
cn  =  cy*pixsiz_n /1e3;
cnt = [cntp(:,2)*pixsiz_e cntp(:,1)*pixsiz_n]' / 1e3;

% Plot quadtree partitioning, and locations of center-coordinates
figure('position',pos2);
patch(ce,cn,sqval); axis image; axis xy; colorbar
hold on; plot(cnt(1,:),cnt(2,:),'.')

title('Quadtree decimated image (Temperature difference)')
xlabel('Distance X '); ylabel('Distance Y')




% Remove NaNs from the Quadtree data (if any)
ii=find(isnan(sqval)==0);

if length(ii)<length(sqval)
  sqval=sqval(ii);
  ce=ce(:,ii);cn=cn(:,ii);cnt=cnt(:,ii);

  figure('position',pos3);
  % plot input data:
  % figure('position',pos1);
  subplot(2,1,1)
  imagesc(ig); axis image;colorbar
  title('Temperature difference')
  subplot(2,1,2)
  patch(ce,cn,sqval); axis image; axis xy; colorbar
  hold on; plot(cnt(1,:),cnt(2,:),'.')
  title('Quadtree decimated image (Temperature difference)')
  xlabel('Distance X'); ylabel('Distance Y')
end

cn=cn+coord(2,1)/1e3;
ce=ce+coord(1,1)/1e3;
cnt(1,:)=cnt(1,:)+coord(1,1)/1e3;
cnt(2,:)=cnt(2,:)+coord(2,1)/1e3;
sv=sqval;
% saving the data

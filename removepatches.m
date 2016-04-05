function [new] = removepatches(cnt,old,xx,yy);
%   removepatches  - masks out region selected with mouse (assign NaNs) 
%
%       run:   a = removepatches(ce,cn,cnt,sval);
%              
%       in:    cnt    - (2xn) matrix of patch center locations
%              sval   - (1xn) vector of patch values
%              ce     - (4xn) of east (or x) patch corner locations
%              cn     - (4xn) of north (or y) patch corner locations
%              
%
%       out:   sv_new - (1xn) vector of patch values with some NaNs   
%

if nargin==0,help removepatches;return;end;


fprintf(1,'Select the polygon using the mouse...\n');

   [xy] = getrect(gcf);  
   X    = [xy(1) xy(1)+xy(3)];
   Y    = [xy(2) xy(2)+xy(4)];
   
  %XY = [xy(1:2)' (xy(1:2)+xy(3:4))'];
  
    % find the square that got selected and assign it to NaN
    ind = find(cnt(:,2)>X(1) & cnt(:,2)<X(2) & cnt(:,1)>Y(1) & cnt(:,1)<Y(2));
    old(ind) = NaN;
  
    if nargin>2
      clf; patch(xx,yy,old);axis image
    end
    
new=old;







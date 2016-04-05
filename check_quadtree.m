function newindmat = check_quadtree(oldindmat, data, tolerance, fittype);
% check_quadtree - Checks if we need further quadtree partitioning
%
% function newindmat = check_quadtree(oldindmat, data, tolerance);
%  
% This script checks if we can put a constant value for
% a square instead of a quadtree it once again.  It works
% with the last two columns of the quadtree matrix, the 
% 0-1 flag control column and value column
%
% INPUT:
%            oldindmat   - (mxl) index matrix
%            data        - (nxn) data matrix
%            tolerance   - (1x1) rms tolerance
% OUPUT:
%            newindmat   - (mxl) new index matrix
  

% Get size of the input quadtree index matrix   
[ilin,icol] = size(oldindmat);


% loop over evey line in the index matrix
for k=1:ilin
    
    % Check if current quadtree line needs further partitioning: 
    if oldindmat(k,icol-3) == 0
        
      % Get corresponding chunk from data
      chunck = getchunck(oldindmat(k,:),data);
      % Get matrix index values for data chunck
      %[c1,c2] = find(chunck==0 | chunck);
      %[c1,c2] = find(chunck);  % crashes when element==0;
      [c1,c2] = find(chunck~=0 | chunck==0);
      % Make a vector out of data chunck
      chunck = chunck(:);
      % find if vector-indices of no-NaN-values     
      nn = find(isnan(chunck)==0);
      % Create a no-NaN-data-chunck-vector, and store vector indices
      chunck_noNaN = chunck(nn);
      
      c1 = c1(nn); c2 = c2(nn);
      
      % Check if non-nan-values cover more than half of square
      if length(chunck_noNaN) >= length(chunck)/4
          
         % CHECK IF BILINEAR FIT
	     if fittype == 2 & length(chunck_noNaN) >= 3
             % calculate bilin-plane
	         [m, G, rms] = fit_bilinplane(chunck_noNaN, [c1 c2]');
             % get median
             medvalue = median(chunck_noNaN);
             % output median value
	         m = [medvalue 0 0]'; 
            
         % Check if calculate median of square?             
         elseif fittype == 1  % CALCULATE MEDIAN OF SQUARE VALUES
            % get median
            medvalue = median(chunck_noNaN);
            % produce a vector of median values and calc. difference
	        tmp = ones(size(chunck_noNaN)) .* medvalue;
            dif = chunck_noNaN - tmp;
            % calculate rms of residual
            rms = sqrt( mean( dif(:).^2 ) );
            % output median value
	        m = [medvalue 0 0]';         

         else  % CALCULATE THE MEAN OF SQUARE VALUES:
            % calculate the mean of chunk values:
            meanvalue = mean(chunck_noNaN);      
            % create a vector with meanvalues
	        tmp = ones(size(chunck_noNaN)) .* meanvalue;
            % calculate residual
            dif = chunck_noNaN - tmp;
            % calculate rms of residual
            rms = sqrt( mean( dif(:).^2 ) );
            % assign the mean to output
	        m = [meanvalue 0 0]'; 
	     end
         
         
         % CHECK IF RMS IS SMALLER THAN THE TOLERANCE
         if rms <= tolerance
           % Assign vector m to index matrix and put '1' into 'check' column
	       oldindmat(k,icol-3:icol) = [ 1 m' ];
         
         % IF LARGER THAN TOLERANCE, THEN ASSIGN 0 AND MEAN/MEDIAN
         else
           oldindmat(k,icol-3:icol) = [ 0 m' ];
	     end
       
         
         
       % check if there are only NaN-values    
       elseif length(chunck_noNaN) < 1
         % assign NaN to square, and put '1' into 'check'-column
	     oldindmat(k,icol-3:icol) = [ 1 NaN NaN NaN ]; 
       else
         oldindmat(k,icol-3:icol) = [ 0 NaN NaN NaN ];  % this may change
       end
      
    end
end

% Update quadtree index matrix:
newindmat = oldindmat;






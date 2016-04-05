function chunck = getchunck(index, data);
% getchunck      - Gets a piece of data according to the quadtree index
%
% function chunck = getchunck(index, data);
%
% INPUT
%         index  = (1xp) p-4 quadtree index values (from one line
%                        of the inex matrix
%         data   = (nxn) data matrix
% 
% OUPUT
%         chunck = (kxk) chunk as indicated by 
%                        the quadtree index values
%


% Get length of real index values, the last three values are
% to be assigned with the median or something else, the fourth
% last value is the 'check' signal
len = length(index) - 4;

% Get size of data
[lin,col] = size(data);

% Get number of lines, or blocksize
blcksz = lin;

% initialize
lst = 1; cst = 1;

% Loop over every column of the 'real' part of the index matrix
for k=1:len
    blcksz = blcksz/2;
    switch index(k)          % four possible cases of index
      case 1
	    lst = lst; 
        cst = cst; 
      case 2	
	    lst = lst; 
        cst = cst + blcksz;
      case 3
	    lst = lst + blcksz; 
        cst = cst + blcksz;
      case 4
	    lst = lst + blcksz; 
        cst = cst;
    end
end
  

% pick out the chunck:
chunck = data( lst : lst+blcksz-1 , cst : cst+blcksz-1 );
  












function [assign_matrix,qfoc,pixxcrd,pixycrd,fill,cfoc]=Patch_vs_Pix(array,geo_par,ce,cn,sv);
%    function [assign_matrix]=Patch_vs_Pix(array,geo_par,ce,cn);
%    -relates Quadtrees to the corresponding interferogram-
%    HSudhaus 2008
%
% 1) Quadtree patch index is assigned to data pixels for further use
% 2) here the focal point of pixels in the quadtrees is calculated 
%    (in case of only partial filling with valid data this may be a better
%     representation of the data point location)
% 3) gives the percentage of valid values in quadtree ('fill')
% input:
% array:        interferogram (or whatever) (masked; -with NaN's)
% geo_par:      (1x5) [ig-width corner-north corner-east post-north post-east]
% ce, cn, sv :       (4xn) (4xn) & (1xn) quadtree coordinates and values 
%
% output:
% assign_matrix: (dimensions of array) pixel values give the quadtree
%                indices
% qfoc:          (nx2) focal point of pixels in quadtree box (may be used 
%                instead of quadtree 'cnt' coordinates)
% fill:          fill percentage of quadtree box
% cfoc:          also a centre point of quadtree boxes: here we only account 
%                for the 25% of pixel values closest to the quadtree value.
%                => focal point of pixels similar to the quadtree value 

% % position and geometry
% build coordinates for images
pixxcrd=meshgrid(1:size(array,1),1:size(array,2))*geo_par(5)/1000+geo_par(3)/1000;
pixycrd=meshgrid(1:size(array,2),1:size(array,1))'*geo_par(4)/1000+geo_par(2)/1000;
assign_matrix=zeros(size(array,2),size(array,1));
cfoc=zeros(size(ce,2),2);
qfoc=zeros(size(ce,2),2);
fill=zeros(size(ce,2),1);

array=array';
mask=array;
mask(isfinite(mask))=1;
tic
for k=1:length(ce)
        % find pixels in the k'th quadtree box
        xindex=find(pixxcrd>=ce(1,k) & pixxcrd<ce(2,k));
        yindex=find(pixycrd<cn(1,k) & pixycrd>=cn(3,k));
        assign_matrix(intersect(xindex,yindex))=k;
        patchpixspace=length(intersect(xindex,yindex)); %number of pix in k'th box
        dummy=array(intersect(xindex,yindex));
        %dummy(find(isfinite(dummy)))=length(find(isfinite(dummy)))/patchpixspace;% display pixel
	    %dummy(find(dummy==0))=NaN;% display pixel
        %dummy=length(find(isfinite(dummy)))/patchpixspace;% display patches
        %fill(intersect(xindex,yindex))=dummy(:)'; 
        %percentage of filling:
        fill(k)=length(find(isfinite(dummy)))/patchpixspace;
        %determine the focal of near mean pixel in a quadtree
        % pick three vectors from data: value-x coord-y coord
        val=array(intersect(xindex,yindex));
        val=(val(find(isfinite(val)))-sv(k)).^2;
        
        x_foc=pixxcrd(intersect(xindex,yindex)).*mask(intersect(xindex,yindex));
        x_foc=x_foc(find(isfinite(x_foc)));
        y_foc=pixycrd(intersect(xindex,yindex)).*mask(intersect(xindex,yindex));
        y_foc=y_foc(find(isfinite(y_foc)));
        % sort pixel after the values
        [val,indixe]=sort(val);
        x_foc=x_foc(indixe);
        y_foc=y_foc(indixe);
        % calculate the focus of the smaller values (25% of sorted values)
        cutoff=round(length(val)*0.25);
        cfoc(k,:)=[mean(x_foc(1:cutoff)) mean(y_foc(1:cutoff))];
        
        % focus of all valid points
        qfoc(k,:)=[mean(x_foc) mean(y_foc)];
end
toc
 if (0)
 figure(1)
% subplot(211)
 patch(ce,cn,fill');axis image;
 colormap gray
 colorbar
 caxis([0 1])
 title({': fill & center vs. focal of quadtrees','x: center; o: focus valid pixel; +: focus near pixel'})
 hold on
 plot(cnt(1,:),cnt(2,:),'xg','MarkerSize',5.5);
 hold on
 plot(qfoc(:,1),qfoc(:,2),'ob','MarkerSize',5.5);
 hold on
 plot(cfoc(:,1),cfoc(:,2),'+r','MarkerSize',5.5);

end


% apply data gaps

assign_matrix=assign_matrix'.*mask';




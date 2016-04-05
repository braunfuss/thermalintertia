187  function resi = parameterized_objectivesm(A,sol,lat,image1,image2,sv)
%  sol= 23;
% lat= 51.8;
% image1= 'quarzit10';
% image2= 'quarzit16';
%  

ds= A(1);
w= A(2);
d = 1 ;
 
r1 = (lat)/57.2957795 ;% latitude (and transformation to rad)
r2 = (sol)/57.2957795 ;% solar declination  (and transformation to rad)

Al= A(3);  %Albedo from 0 to 1
I1=image1; %morning image as array input
I2= image2;%midday image as array inputn
[m,n]= size (I1);
%n= size (I2); 



% maxi1= max(image1);
% maxi2= max(image2);
% 
% maxtot= [maxi1 maxi2];
% tmax= max (maxtot);
%tmax=35 %tmax is the maxiumum temperature of day at 2m 
T=  ((2*pi)/24)*sv; %calculate omega


b= sqrt((2 * pi)/8)* sqrt(1+(1/((tan(T))/(1-tan(T)))+1/(2*(tan(T))/ (1-tan(T)))^2));
amod=(2*1375*2 *(2/pi *sin(r1)* sin( r2)+1/(2* pi) *cos( r1) *cos(r2)* sin(2 *acos(tan( r1) *tan(r2))+2* acos(tan( r1)* tan(r2)))));



    
   

% calculate coefficents

%calculate matrix
% Btrix= repmat (b, m, n) ; %create matrix of b-coffecients
% amodtrix = repmat(amod, m, n); %create matrix of a-coffecients

z= amod* ((1-Al)); %create matrix of A-coffecients with apparent thermal inertia, 
deltat= sv;
acoff= z./(deltat); % acoff with thermal inertia
E= acoff./b; %create the image
Epos=abs(E); %as no negative ineratia exsist, correct all negative to positive values
I= Epos;

P= ((2.1*ds ^(1.2-0.02*((ds)/d)*w) * exp(-0.007* (((w*ds)/d)-20)^2) + ds^(0.8+0.02*(((ds)/d)*w)))^1/2 ) * (((0.2 * (w/d))*ds^2 ) /0.001* sqrt(100)); % the Thermal inertia due to the soil moiste (negative if the soil is wet)
%using numerical solution from Soil moisture retrieval from MODIS data in Northern China Plain using thermal inertia model
% d_pred= mean(I);
% I= d_pred;
% isscalar(I)
P = P/( 2.46*10^6);

Ptot= P+I;
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%backward

Eback = Ptot ;
acoff_b= Eback*b;
deltat_b = z./ acoff_b;
%I2_b = deltat_b - sv;

%back after xue and cracknell
delta = - (acoff/ b) + (1-Al)


%resi = I - P 
resi= sv - deltat_b;


%misfit= sum( (abs((resi)^2))^1/2)





 
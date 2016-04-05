 function resi = parameterized_objectiveraw(A,sol,lat,image1,image2,sv,mode)
%  sol= 23;
% lat= 51.8;
% image1= 'quarzit10';
% image2= 'quarzit16';
%  


d1= A(3);
d2= A(6);
hc1= A(2);
hc2= A(5);
hc1= A(2);
tc2= A(4);
tc1= A(7);

r1 = (lat)/57.2957795 ;% latitude (and transformation to rad)
r2 = (sol)/57.2957795 ;% solar declination  (and transformation to rad)

Al= A(1);  %Albedo from 0 to 1
I1=image1; %morning image as array input
I2= image2;%midday image as array inputn
[m,n]= size (I1);
%n= size (I2); 

 ct= 0.75 ;  % atmospheric transmittance

omega=  ((2*pi)/24)*sv; %calculate omega
DT= sv; 
tmax= max (image2);

amod=((2/pi *sin(r1)* sin( r2)+1/(2* pi) *cos( r1) *cos(r2)* sin(2 *acos(tan( r1) *tan(r2))+2* acos(tan( r1)* tan(r2)))));

% new TI

a= 2*1375*ct * amod* ((1-Al)/DT);

b= (tan(omega*tmax))/ (1 - tan (omega*tmax));
    
delta1= b/ (1+b);
delta2 = (atan (b *sqrt(2)))/ ((1+b*sqrt(2)));

I = a / (sqrt(omega)*sqrt(1+ (1/b)+ (1/(2*b^2))));


   I=  ((1-Al) * 1375*ct *  amod)  /  (sv * sqrt(1+1/b+1/ (b ^2)));



 z= amod* ((1-Al)); %create matrix of A-coffecients with apparent thermal inertia, 
 deltat= sv;
 acoff= z./(deltat); % acoff with thermal inertia



P = sqrt(d1*hc1*tc1) + sqrt(d2*hc2*tc1);

if mode == 1
Ptot= P;
end


if mode == 2
 Psum =  w1* sqrt(k1p1c1)   +    w2* sqrt(k2p2c2) +  w3* sqrt(k3p3c3)  ;

end



%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%backward

%B=  ((1-Al) * 1375*ct *  amod * (cos (omega *t2 -delta2) - cos(omega * t1 - delta1))) /  (sv * sqrt(1+2*b+2*b ^2));
B=  ((1-Al) * 1375*ct *  amod )/  (sv * sqrt(1+2*b+2*b ^2));

deltat= (((1-Al) * 1375*ct)  *  amod ) / (sqrt(omega *Ptot^2 + sqrt(2*omega)*B*Ptot+B^2));

% Eback = Ptot ;
% acoff_b= Eback*b;
% deltat_b = z./ acoff_b;
% %I2_b = deltat_b - sv;
%  variante 2, summation of thermal proper.


% %back after xue and cracknell
% delta = - (acoff/ b) + (1-Al)


%resi = I - P 
resi= sv - deltat;



%misfit= sum( (abs((resi)^2))^1/2)

end



 
function[V]=plate(x,s,H,D,mu1,mu2,nt)
%
%	Calculates displacement for a fault
%       in a layer of thickness H that slips from the surface to a depth D
%       See Segall, 2010, p. 129
%
%	input:
%
%	x       - distance from fault 
%	s       - fault slip rate 
%	H       - half width of compliant zone
%	D       - depth to bottom of the fault D<H
%	mu1     - rigidity of the layer
%	mu2     - rigidity of the half space
%
%	output:
%
%	V	- y-component of displacement
%
%  setup the needed constants
%
	kap = (mu1-mu2)/(mu1+mu2);
        fac = s/pi;
        sum = fac*atan(D/x);
        for n=1:nt;
          sum = sum + fac*kap^n*(atan((D-2.*n*H)/x)+atan((D+2.*n*H)/x));
        end
        V=sum;
        end

function[V]=comply(x,s,h,d,mu1,mu2,nt)
%
%	Calculates displacement for a fault
%       imbedded in a zone lof lower rigidity
%       See Segall, 2010, p. 124
%
%	input:
%
%	x       - distance from fault 
%	s       - fault slip rate 
%	h       - half width of compliant zone
%	d       - depth to top of fault
%	mu1     - rigidity outside of the compliant zone
%	mu2     - rigidity inside of the fault
%
%	output:
%
%	V	- y-component of velocity
%
%  setup the needed constants
%
	kap = (mu1-mu2)/(mu1+mu2);
        fac = s/pi;
        sum=0.;
        if(x < -h) 
          for n=0:nt;
          sum = sum + fac*(1-kap)*kap^n*atan((x-2.*n*h)/d);
          end
        elseif(x > h) 
          for n=0:nt;
          sum = sum + fac*(1-kap)*kap^n*atan((x+2.*n*h)/d);
          end
        else
          sum=fac*atan(x/d);
          for n=1:nt;
          sum = sum + fac*kap^n*(atan((x-2.*n*h)/d)+atan((x+2.*n*h)/d));
          end
        end
        V=sum;
        end

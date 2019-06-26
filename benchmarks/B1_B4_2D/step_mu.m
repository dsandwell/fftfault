function[V]=step_mu(x,s,d,mu1,mu2)
%
%	Calculates displacement for a fault bounded by material
%       of two different rigidities
%       See Segall, 2010, p. 119
%
%	input:
%
%	x       - distance from fault 
%	s       - fault slip 
%	d       - depth to top of fault
%	mu1     - rigidity on left side of fault
%	mu2     - rigidity on right side of fault
%
%	output:
%
%	V	- y-component of displacement
%
%  setup the needed constants
%
        if(x < 0.) 
          V=2*s*(mu2/(mu1+mu2))*atan(d/x)/pi;
        elseif(x == 0.) 
          V=0.;
        else
          V=2*s*(mu1/(mu1+mu2))*atan(d/x)/pi;
        end

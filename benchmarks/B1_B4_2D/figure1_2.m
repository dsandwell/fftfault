%
%  test 2-D  half space and plate cases
%
   mu1=1;	% normal rigidity
   h=5; 	% 1/2 thickness of compliant zone
   H=40;	% elastic plate thickness
   d=20;	% shallow locking depth
   nt=400;	% number of terms in series
   s=1.;	% slip
   dx=.5;	% data spacing
%
%  setup the x-vector and storage for models
%
   x=-100:dx:100;
   ni=length(x);
   v_uniform=0.*x;
   v_step=0.*x;
%
%  compile maxwell with ni=16 nj=8192
%
   !maxwell 1 -20 0 0 0. 1 ss_segs1.dat 0 xm1.grd ym1.grd zm1.grd -40 1.e19 .25 1
   !maxwell 1 -20 0 0 99999. 1 ss_segs1.dat 0 xm2.grd ym2.grd zm2.grd -40 1.e19 .25 1
   [xm,ym,vm1]=grdread2('ym1.grd');
   [xm,ym,vm2]=grdread2('ym2.grd');
%
%  extract the maxwell profiles
%
   v_uniform_m=vm1(8,2048-floor(ni/2):2048+floor(ni/2));
   v_step_m=vm2(8,2048-floor(ni/2):2048+floor(ni/2));
   figure(1)
   mu2=0.0;
   for i=1:ni;
   v_uniform(i)=plate(x(i),s,H,d,mu1,mu1,nt);
   v_step(i)=plate(x(i),s,H,d,mu1,mu2,nt);
   end
   s_uniform=diff(v_uniform)/d/dx;
   s_step=diff(v_step)/d/dx;
   xs=x(1:ni-1)+.5*dx;
%
%  plot the results
%
   figure(1)
   clf
%
%  half space
%
   subplot(2,2,1);plot(x/d,v_uniform,x/d,v_uniform_m)
   xlim([-2,2]);grid;
   xlabel('x/d')
   ylabel('displacement')
   title('fault in a half space')
   subplot(2,2,2);plot(x/d,v_uniform-v_uniform_m)
   xlim([-2,2]);grid;
   xlabel('x/d')
   ylabel('error')
%
%  plate
%
   subplot(2,2,3);plot(x/d,v_step,x/d,v_step_m)
   xlim([-2,2]);grid;
   title('fault in a layer over a fluid  mu2/mu1=0')
   xlabel('x/d')
   ylabel('displacement')
   subplot(2,2,4);plot(x/d,v_step-v_step_m)
   xlim([-2,2]);grid;
   xlabel('x/d')
   ylabel('error')
%
%  print the results
%
print -depsc figure1_2.eps

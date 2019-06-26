%
%  benchmarks 3 and 4 have lateral variable rigidity
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
%  make a uniform model just to get the size
%  compile maxwell with ni=16 nj=8192
%
   !maxwell 1 -20 -2 0 0. 1 ss_segs1.dat 0 xm1.grd ym1.grd zm1.grd -40 1.e19 .25 1
   [xm,ym,vm1]=grdread2('ym1.grd');
%
%  second fault bounding two media
%
%  make the rigidity grid
%
   mu2=0.5;
   rmu3=ones(size(vm1));
   [nim,njm]=size(vm1);
   for j=1:njm;
    if(j < 2049)
      rmu3(:,j)=mu1;
    else
      rmu3(:,j)=mu2;
    end
   end
%
%  write the rigidity image and compute the model
%
   grdwrite2(xm,ym,rmu3,'rmu3.grd');
   !maxwell 1 -20 -2 0 0. 1 ss_segs3.dat 0 xm3.grd ym3.grd zm3.grd -40 1.e19 .25 1
   [xm,ym,vm3]=grdread2('ym3.grd');
   v_step_m=vm3(8,2048-floor(ni/2):2048+floor(ni/2));
   for i=1:ni;
   v_uniform(i)=step_mu(x(i),s,d,mu1,mu1);
   v_step(i)=step_mu(x(i),s,d,mu1,mu2)-step_mu(x(i),s,2,mu1,mu2);
   end
   s_uniform=diff(v_uniform)/d/dx;
   s_step=diff(v_step)/d/dx;
   xs=x(1:ni-1)+.5*dx;
%
   figure(1)
   subplot(2,2,1);plot(x/d,v_step,x/d,v_step_m+0.05)
   xlim([-2,2]);grid
   xlabel('x/d')
   ylabel('displacement')
   title('fault bounded by two media mu2/mu1=0.5')
   subplot(2,2,2);plot(x/d,v_step-(v_step_m+0.05))
   ylim([-.5,.5])
   xlim([-2,2]);grid
   xlabel('x/d')
   ylabel('error')
%
%  third fault in a compliant zone
%
   mu2=.2;
   for i=1:ni;
   v_uniform(i)=comply(x(i),s,h,d,mu1,mu1,nt);
   v_step(i)=comply(x(i),s,h,d,mu1,.2,nt);
   end
   s_uniform=diff(v_uniform)/d/dx;
   s_step=diff(v_step)/d/dx;
   xs=x(1:ni-1)+.5*dx;
%
   !maxwell 1 -99998 -20 0 0. 1 ss_segs1.dat 0 xm4.grd ym4.grd zm4.grd -99999 1.e19 .25 1
   [xm,ym,vm4]=grdread2('ym4.grd');
   v_uniform_m=vm4(8,2048-floor(ni/2):2048+floor(ni/2));
%
%  make the rigidity grid
%
   mu2=0.2;
   rmu4=ones(size(vm1));
   [nim,njm]=size(vm1);
   for j=1:njm;
    if(abs(j-2048) < 11 )
      rmu4(:,j)=.2;
    else
      rmu4(:,j)=mu1;
    end
   end
%
%  write the rigidity image and compute the model
%
   grdwrite2(xm,ym,rmu4,'rmu4.grd');
   !maxwell 1 -99998 -20 0 0. 1 ss_segs4.dat 0 xm5.grd ym5.grd zm5.grd -99999 1.e19 .25 1
   [xm,ym,vm5]=grdread2('ym5.grd');
   v_step_m=vm5(8,2048-floor(ni/2):2048+floor(ni/2));
   s_step_m=diff(v_step_m)/d/dx;
   subplot(2,2,3);plot(x/d,v_step,x/d,.530*v_step_m)
   xlim([-2, 2]); grid
   xlabel('x/d')
   ylabel('displacement')
   title('compliant fault zone mu2/mu1=.5')
   subplot(2,2,4);plot(x/d,v_step-.530*v_step_m)
   ylim([-.4,.4])
   xlim([-2, 2]); grid
   xlabel('x/d')
   ylabel('error')
%   subplot(2,1,2);plot(xs/d,s_uniform,xs/d,s_step,xs/d,0.530*s_step_m)
%   xlabel('x/d')
%   ylabel('strain')
   print -depsc figure3_4.eps

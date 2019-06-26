%
%  test 2-D layered cases
%
   clear
   H=30;	% elastic plate thickness
   dx=.5;	% data spacing
   z0=-2.;
   figure(1)
   clf
%
%  setup the x-vector and storage for models
%
   x=-200:dx:200;
   ni=length(x);
   v_uniform=0.*x;
   v_step=0.*x;
%
%  first test a point load on an elastic 1/2 space
%
  !point -9999 3300 1. -2. 0 xhs.grd yhs.grd zhs.grd
   [xm,ym,xhs]=grdread2('xhs.grd');
   [xm,ym,zhs]=grdread2('zhs.grd');
%
%  extract the maxwell profiles
%
   xhs_m=xhs(2048,2048-floor(ni/2):2048+floor(ni/2));
   zhs_m=zhs(2048,2048-floor(ni/2):2048+floor(ni/2));
%
%  plot the results
%
   z02=z0*z0;
   z_love=x.*0; 
   for i=1:ni;
   x0=x(i)-.5;
   r2=z02+x0*x0;
   r=sqrt(r2);
   z_love(i)=-(z02/(r*r2)+1.5/r)/(4.*pi);
   end
%
%  half space
%
   subplot(2,2,1);plot(x/H,zhs_m,x/H,z_love)
   grid
   xlim([-6,6])
   ylim([-.2,.02])
   xlabel('x/H')
   ylabel('displacement')
   title('point load on elastic half space')
   subplot(2,2,2);plot(x/H,zhs_m-z_love)
   grid
   xlim([-6,6])
   ylim([-.2,.02])
   xlabel('x/H')
   ylabel('error')
%
%  second test a point on a plate
%  for the thin plate test you need to go into the foint.f code and 
%  change the function so a thin elastic plate will be used.
%
   !point -20 3300 0. -2. 0 xps.grd yhs.grd zps.grd
   !point -20 3300 0. -2. 0 x_thin.grd y_thin.grd z_thin.grd

   [xm,ym,xps]=grdread2('xps.grd');
   [xm,ym,zps]=grdread2('zps.grd');
   [xm,ym,z_thin]=grdread2('z_thin.grd');
%
%  extract the maxwell profiles
%
   xps_m=xps(2048,2048-floor(ni/2):2048+floor(ni/2));
   zps_m=zps(2048,2048-floor(ni/2):2048+floor(ni/2));
   z_thin_m=z_thin(2048,2048-floor(ni/2):2048+floor(ni/2));
   figure(1)
% 
%  plot the results
%
%  subplot(2,2,3);plot(x/H,xps_m)
   subplot(2,2,3);plot(x/H,zps_m,x/H,z_thin_m)
   grid
   xlim([-6,6])
   ylim([-.2,.02])
   xlabel('x/H')
   ylabel('displacement')
   title('point load on elastic plate')
   subplot(2,2,4);plot(x/H,zps_m-z_thin_m)
   grid
   xlim([-6,6])
   ylim([-.2,.02])
   xlabel('x/H')
   ylabel('displacement difference')

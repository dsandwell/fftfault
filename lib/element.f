c
      subroutine element(x,y,x1,y1,x2,y2,dxx,sig,idble,F1,F2,F3,
     +                   fxx,fyy,fzz)
c
c  modified 04/13/07 to include gravity in common block
c  modified 04/15/07 to add real*8 L

      implicit real*8(a-h,o-z)
      real*8 L
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
c       create the force vector for this element
c
c       input:
c
c       x, y    - computation point      (km)
c       x1,y1   - start position         (km)
c       x2,y2   - end position           (km)
c       dxx     - grid spacing           (km)
c       sig     - source width in pixels (try 1)
c       idble   - (0-single couple, 1-double couple)
c       F1      - strike-slip
c       F2      - dip-slip
c       F3      - opening mode
c
c       output:
c
c       fxx     - x-component of force couple
c       fyy     - y-component of force couple
c       fzz     - z-component of force couple
c
c  set the x and y taper lengths
c
      sigy=sig
c
c  sigx  should be = 2 or perhaps 4
c
      sigx=2.0
c
c  compute the length and orientation of the fault
c
      Dx=(x2-x1) 
      Dy=(y2-y1) 
      L=sqrt(Dx*Dx+Dy*Dy) 
      theta=atan2(Dy,Dx) 
      st=sin(theta) 
      ct=cos(theta) 

c
c  rotate the vector into the model space
c
      x0=x-x1 
      y0=y-y1 
      xp=x0*ct+y0*st 
      yp=-x0*st+y0*ct 
 
c  compute the h and dh/dx functions
c
      h=exp(-0.5*((yp/sigy)**2))/(sqrt(2*pi)*sigy)/(dxx*dxx) 
      dh=-yp*exp(-0.5*((yp/sigy)**2))/(sqrt(2*pi)*sigy**3)/(dxx*dxx) 
c
c   compute the g and dgdx functions
c
      if(xp .gt. -sigx .and. xp .lt. sigx) then
         g=0.5*(1-cos(pi*(xp+sigx)/(2*sigx))) 
         dg=pi*sin(pi*(xp+sigx)/(2*sigx))/(4*sigx)
      else if(xp .ge. sigx .and. xp .le. L-sigx) then
         g=1. 
         dg=0.
      else if(xp .gt. L-sigx .and. xp .lt. L+sigx) then
         g=0.5*(1-cos(pi*(L+sigx-xp)/(2*sigx))) 
         dg=-pi*sin(pi*(L+sigx-xp)/(2*sigx))/(4*sigx)
      else
         g=0. 
         dg=0.
      endif
c
c extract components
c
c  primary couple
c
      fxx=g*dh*(-F1*ct+F3*st)
      fyy=g*dh*(F1*st+F3*ct)
      fzz=g*dh*F2 
c
c  optional double couple
c
      if(idble.eq.1) then
        fxx=fxx+dg*h*F1*st
        fyy=fyy+dg*h*F1*ct
      endif
      return
      end

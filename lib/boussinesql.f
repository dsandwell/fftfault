c
      subroutine boussinesql(kx,ky,z,H,cub,cvb,cwb,cdudz,cdvdz,cdwdz)
c
c  input 
c    kx  - x wavenumber        (1/km)
c    ky  - y wavenumber        (1/km)
c    z   - observation plane z < 0   (km)
c    H   - thickness of upper layer (km)
c
c  output
c    cub - x-displacement      (km/Pa)
c    cvb - y-displacement
c    cwb - z-displacement
c    cdwdz - derivative of w with respect to z
c
      implicit real*8 (a,b,d-h,o-z)
      implicit complex*16 (c)
      implicit real*8 (k)
      real*8 c1,c2
c
c  routine to compute the greens function for point load on
c  a layered half-space
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      if (kx.eq.0.and.ky.eq.0.) then
        cub=cmplx(0.,0.)
        cvb=cmplx(0.,0.)
        cwb=cmplx(0.,0.)
        cdudz=cmplx(0.,0.)
        cdvdz=cmplx(0.,0.)
        cdwdz=cmplx(0.,0.)
        return
      endif
c
c   compute the coefficients
c
      kh2=kx*kx+ky*ky
      kh=sqrt(kh2)
      B=2*pi*kh
      B2=B*B
      arg=B*z
      if(arg.lt.-50.) then
        ep=0.
        en=exp(50.)
      else
        ep=exp(arg)
        en=exp(-arg)
      endif
      call coefl(rlam1,rlam2,rmu1,rmu2,B,H,rho,grv,a1,b1,c1,d1,a2,c2)
c
      if(abs(z).lt.H) then
        arg1=alph*(a1*B*ep+b1*B*en+
     +       c1*(1+B*z)*ep-d1*(1-B*z)*en)
        arg2=alph*(a1*B*ep-b1*B*en+
     +       c1*(2+B*z-2/alph)*ep+d1*(2-B*z-2/alph)*en)
        arg3=alph*(a1*B*ep+b1*B*en+
     +       c1*(3+B*z-2/alph)*ep-d1*(3-B*z-2/alph)*en)
        arg4=alph*(a1*B*ep-b1*B*en+
     +       c1*(2+B*z)*ep+d1*(2-B*z)*en)

      else
        alph2=(rlam2+rmu2)/(rlam2+2*rmu2)
        arg1=alph2*(a2*B*ep+c2*(1+B*z)*ep)
        arg2=alph2*(a2*B*ep+c2*(2+B*z-2/alph2)*ep)
        arg3=alph2*(a2*B*ep+c2*(3+B*z-2/alph2)*ep)
        arg4=alph2*(a2*B*ep+c2*(2+B*z)*ep)
      endif
      cub=cmplx(0.,-2.*pi*kx*arg1)
      cvb=cmplx(0.,-2.*pi*ky*arg1)
      cwb=cmplx(-B*arg2,0.)
      cdudz=cmplx(0.,-2.*pi*kx*B*arg4)
      cdvdz=cmplx(0.,-2.*pi*ky*B*arg4)
      cdwdz=cmplx(-B2*arg3,0.)
      return
      end
c

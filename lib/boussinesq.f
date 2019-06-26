c
      subroutine boussinesq(kx,ky,z,cub,cvb,cwb,cdwdz)

c  modified 04/13/07 to include gravity in common block
c
c  input 
c    kx  - x wavenumber        (1/km)
c    ky  - y wavenumber        (1/km)
c    z   - observation plane   (km)
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
c
c  routine to compute the greens function for a fault element
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      if (kx.eq.0.and.ky.eq.0.) then
        cub=cmplx(0.,0.)
        cvb=cmplx(0.,0.)
        cwb=cmplx(0.,0.)
      else
        kh2=kx*kx+ky*ky
        kh=sqrt(kh2)
        B=2*pi*kh
        B2=B*B
        arg=B*z
        if(arg.lt.-50.) then
          eb=0.
        else
          eb=exp(arg)
        endif
        arg1=(1.-1./alph-B*z)/(2.*rmu1)
        arg2=(   1./alph-B*z)/(2.*rmu1)
        arg3=(1./alph-1.-B*z)/(2.*rmu1)
        cub=cmplx(0.,-2.*pi*kx*arg1*eb/B2)
        cvb=cmplx(0.,-2.*pi*ky*arg1*eb/B2)
        cwb=cmplx(-arg2*eb/B,0.)
        cdwdz=cmplx(-arg3*eb,0.)
      endif
      return
      end
c

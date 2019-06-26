c
      subroutine fterm(kx,ky,d1,d2,z,H2,m,ux,uy,uz,
     +                                    vy,vz,wz,
     +                                    c3x,c3y,c3z)
c
c  modified 04/13/07 to include gravity in common block
c
c  input
c    kx  - x wavenumber        (1/km)
c    ky  - y wavenumber        (1/km)
c    d1  - bottom of fault in source or image (km)
c    d2  - top of fault in source or image (km)
c    z   - observation plane   (km)
c    H2  - 2 x plate thickness
c    m   - image number
c
c  output
c    cux,cuy,cuz  - elements of force/displacement matrix
c    cvy,cvz,cwz               (km**2/Pa)
c    c3x,c3y,c3z  - non-zero vertical stress at surface z=0
c                              (km)
c
      implicit real*8(a,b,d-h,o-z)
      implicit complex*16 (c)
      implicit real*8 (k)
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      if (kx.eq.0.and.ky.eq.0.) return
c
c  generate the wavenumbers
c
      kh2=kx*kx+ky*ky
      kh=sqrt(kh2)
      B=2*pi*kh
      B2=4*pi*pi*kh2
      kxx=(kx*kx)/kh2
      kyy=(ky*ky)/kh2
      kxy=(kx*ky)/kh2
      fac=rc/B2
c
c  generate the coefficients
c
      a01=rd+kyy-kxx
      a02=-kxx
      a03=-2*kxy
      a04=-kxy
      a05=-kx/kh
      a06=a05
      a07=rd+kxx-kyy
      a08=-kyy
      a09=-ky/kh
      a10=a09
      a11=rd+1.
      a12=1.
c
c  generate and subtract the exponentials
c
      Bs1=B*abs(z-(d1+H2*m))
      Bs2=B*abs(z-(d2+H2*m))
      if(Bs1.gt.50.) then 
        es1=0.
      else
        es1=exp(-Bs1)
      endif
      zes1=Bs1*es1
      if(Bs2.gt.50.) then 
        es2=0.
      else
        es2=exp(-Bs2)
      endif
      zes2=Bs2*es2
c
c  modify these terms if rmu2 = 0.
c  use the series expansion
c
      if(rmu2.eq.0.0.and.m.ne.0) then
        BH2=B*H2
        if(BH2.gt.50.) then
          exBH2=0.
        else
          exBH2=exp(-BH2)
        endif
        eH2=1.-exBH2
        es1=es1/eH2
        es2=es2/eH2
        zes1=(Bs1+BH2*exBH2/eH2)*es1
        zes2=(Bs2+BH2*exBH2/eH2)*es2
      endif
      es21=es2-es1
      zes21=zes2-zes1
c
c  multiply the coefficients and the exponentials
c
      ux=fac*(a01*es21+a02*zes21)
      uy=fac*(a03*es21+a04*zes21)
      uz=fac*(a05*es21+a06*zes21)
      vy=fac*(a07*es21+a08*zes21)
      vz=fac*(a09*es21+a10*zes21)
      wz=fac*(a11*es21+a12*zes21)
c
c   compute the surface traction components
c
      rl2m=rlam1+2.*rmu1
c  
c  generate the exponentials
c
      Bd1=B*abs(z-(d1+H2*m))
      Bd2=B*abs(z-(d2+H2*m))
      if(Bd1.gt.50) then
        e1=0.
      else
        e1=exp(-Bd1)
      endif
      ze1=Bd1*e1
      if(Bd2.gt.50) then
        e2=0.
      else
        e2=exp(-Bd2)
      endif
      ze2=Bd2*e2
      if(rmu2.eq.0.0.and.m.ne.0) then
        e1=e1/eH2
        e2=e2/eH2
        ze1=(Bd1+BH2*exBH2/eH2)*e1
        ze2=(Bd2+BH2*exBH2/eH2)*e2
      endif
c
c  multiply the coefficients by the exponentials
c
      arg1=(rlam1/rl2m)*(e2-e1)+alph*(ze2-ze1)
      arg2=-(rmu1/rl2m+2*alph)*(e2-e1)-alph*(ze2-ze1)
      c3x=cmplx(0.,arg1*kx/(B*kh))/2.
      c3y=cmplx(0.,arg1*ky/(B*kh))/2.
      c3z=cmplx(arg2/B,0.)/2.
      return
      end
c

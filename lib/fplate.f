c    
       subroutine fplate(kx,ky,H,d1,d2,z,cux,cuy,cuz,
     +                                   cvx,cvy,cvz,
     +                                   cwx,cwy,cwz,
     +                                   cx,cy,cz)
c
c  modified 04/13/07 to include gravity in common block
c
c  input
c    kx  - x wavenumber        (1/km)
c    ky  - y wavenumber        (1/km)
c    H   - thickness of plate  (km)
c    d1  - bottom of fault d1 < d2 < 0. (km)
c    d2  - top of fault        (km)
c    z   - observation plane   (km)
c
c  output
c    cux,cuy,cuz  - elements of force/displacement matrix
c    cvx,cvy,cvz               (km**2/Pa)
c    cwx,cwy,cwz
c    cx,cy,cz  - non-zero vertical stress at surface z=0
c                              (km)
c
      implicit real*8(a,b,d-h,o-z)
      implicit complex*16 (c)
      implicit real*8 (k)
c
c  routine to compute the greens function for a fault element
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      cux=cmplx(0.,0.)
      cuy=cmplx(0.,0.)
      cuz=cmplx(0.,0.)
      cvx=cmplx(0.,0.)
      cvy=cmplx(0.,0.)
      cvz=cmplx(0.,0.)
      cwx=cmplx(0.,0.)
      cwy=cmplx(0.,0.)
      cwz=cmplx(0.,0.)
      cwz=cmplx(0.,0.)
      cx=cmplx(0.,0.)
      cy=cmplx(0.,0.)
      cz=cmplx(0.,0.)
      if (kx.eq.0.and.ky.eq.0.) return
c
c  compute the rigidity ratio 
c  there are three cases
c  case 1 - ratio=0 just need one source, one image
c  case 2 - ratio=1 can do infinite summation analytically
c  case 3 - 0 < ratio < 1 - need to use many terms in the summation
c
      ratio=(rmu1-rmu2)/(rmu1+rmu2)
      H2=abs(2*H)
c
c  use the wavenumber to limit mmax
c
      beta=sqrt(kx*kx+ky*ky)
      mmax=10./(beta*H2)+5
c
      if(ratio.eq.0) mmax=0
      if(ratio.eq.1) mmax=1
      do 100 m=-mmax,mmax
        fac=ratio**abs(m)
        sgn=1.0
        if(m.gt.0)sgn=-1.0
c
c   compute the sources
c
        call fterm(kx,ky,d1,d2,z,H2,m,uxs,uys,uzs,
     +                                vys,vzs,wzs,
     +                                c3x,c3y,c3z)
c
c   compute the images
c
        call fterm(kx,ky,-d1,-d2,z,H2,-m,uxi,uyi,uzi,
     +                                   vyi,vzi,wzi,
     +                                   c3x,c3y,c3z)
c
        cux=sgn*fac*cmplx(uxs+uxi,0)+cux
        cuy=sgn*fac*cmplx(uys+uyi,0)+cuy
        cuz=sgn*fac*cmplx(0,uzs+uzi)+cuz
c
        cvx=sgn*fac*cmplx(uys+uyi,0.)+cvx
        cvy=sgn*fac*cmplx(vys+vyi,0.)+cvy
        cvz=sgn*fac*cmplx(0.,vzs+vzi)+cvz
c
        cwx=sgn*fac*cmplx(0.,uzs-uzi)+cwx
        cwy=sgn*fac*cmplx(0.,vzs-vzi)+cwy
        cwz=sgn*fac*cmplx(wzs-wzi,0.)+cwz
c
c  we are still confused on what to do with these
c  terms so for now just keep m=0 and m=1 terms
c  this will work in the half space case
c
c       if(m.lt.0.or.m.gt.1) go to 100
c       if(m.ge.1) go to 100
        if(m.ne.0)go to 100
        cx=sgn*fac*c3x+cx
        cy=sgn*fac*c3y+cy
        cz=sgn*fac*c3z+cz
  100 continue
      return
      end
c

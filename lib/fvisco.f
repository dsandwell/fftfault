c    
       subroutine fvisco(kx,ky,H,d1,d2,z,An,rla,rmu,namx,
     +                                    cfkx,cfky,cfkz,
     +                                      cuk,cvk,cwk)
c
c  modified 04/13/07 to include gravity in common block
c  mkdified 04/18/08 to add stress at base of plate
c
c  input
c     kx  - x wavenumber        (1/km)
c     ky  - y wavenumber        (1/km)
c     H   - thickness of plate  (km)
c     d1  - bottom of fault d1 < d2 < 0. (km)
c     d2  - top of fault        (km)
c     z   - observation plane   (km)
c     An  - image coefficients
c     rla - lambda's
c     rmu - mu's
c     namx - number of non-zero coefficients
c     cfkx,cfky,cfkz - force vector
c
c  output
c     cuk,cvk,cwk - displacement vector
c
c  internal variables
c     cux,cuy,cuz  - elements of force/displacement matrix
c     cvx,cvy,cvz               (km**2/Pa)
c     cwx,cwy,cwz
c     cx,cy,cz  - non-zero vertical stressa (km)
c
      implicit real*8 (a,b,d-h,o-z)
      implicit complex*16 (c)
      implicit real*8 (k)
      real*8 An(1),rla(1),rmu(1)
c
c  routine to compute the greens function for a fault element
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      cuk=cmplx(0.,0.)
      cvk=cmplx(0.,0.)
      cwk=cmplx(0.,0.)
      cTTk=cmplx(0.,0.)
      cTBk=cmplx(0.,0.)
      if (kx.eq.0.and.ky.eq.0.) return
c
      H1=abs(H)
      H2=abs(2*H)
c
c  use the wavenumber and the number of coefficients An to limit mmax
c
      beta=sqrt(kx*kx+ky*ky)
      mmax=10./(beta*H2)+5
      mmax=min(mmax,namx)
c
c switch to plate model when rmu(1) is exactly zero
c
      if(rmu(1).eq.0.)mmax=1
c
      do 100 m=-mmax,mmax
      i=abs(m)
c
c   load the coefficients
c
      if(i.eq.0) then
        fac=1.
        rlam2=rlam1
        rmu2=rmu1
      else
        fac=An(i)
        rlam2=rla(i)
        rmu2=rmu(i)
      endif
      sgn=1.0
      if(m.gt.0)sgn=-1.0
c
c   compute the sources
c
      if(z.lt.d2.and.m.eq.0) then
c
c  need to use two parts for the primary source
c
      dm=z
      call fterm(kx,ky,d1,dm,z,H2,m,ux1,uy1,uz1,
     +                              vy1,vz1,wz1,
     +                              c1x,c1y,c1z) 
      call fterm(kx,ky,dm,d2,z,H2,m,ux2,uy2,uz2,
     +                              vy2,vz2,wz2,
     +                              c2x,c2y,c2z) 
      uxs=ux1-ux2
      uys=uy1-uy2
      uzs=uz1-uz2
      vys=vy1-vy2
      vzs=vz1-vz2
      wzs=wz1-wz2
      c3x=c1x-c2x
      c3y=c1y-c2y
      c3z=c1z-c2z
      else
      call fterm(kx,ky,d1,d2,z,H2,m,uxs,uys,uzs,
     +                              vys,vzs,wzs,
     +                              c3x,c3y,c3z)
      endif
c
c   compute the images
c
      call fterm(kx,ky,-d1,-d2,z,H2,-m,uxi,uyi,uzi,
     +                                 vyi,vzi,wzi,
     +                                 c3x,c3y,c3z)
c
      cux=sgn*fac*cmplx(uxs+uxi,0)
      cuy=sgn*fac*cmplx(uys+uyi,0)
      cuz=sgn*fac*cmplx(0,uzs+uzi)
c
      cvx=sgn*fac*cmplx(uys+uyi,0.)
      cvy=sgn*fac*cmplx(vys+vyi,0.)
      cvz=sgn*fac*cmplx(0.,vzs+vzi)
c
      cwx=sgn*fac*cmplx(0.,uzs-uzi)
      cwy=sgn*fac*cmplx(0.,vzs-vzi)
      cwz=sgn*fac*cmplx(wzs-wzi,0.)
c
c  update the displacement 
c
      cuk=cuk+(cfkx*cux+cfky*cuy+cfkz*cuz)
      cvk=cvk+(cfkx*cvx+cfky*cvy+cfkz*cvz)
      cwk=cwk+(cfkx*cwx+cfky*cwy+cfkz*cwz)
c
c   compute the unbalanced vertical stress at the top of the plate 
c   from the source and image.
c
      zro=0.0
      call fterm(kx,ky,d1,d2,zro,H2,m,uxs,uys,uzs,
     +                              vys,vzs,wzs,
     +                              c3x,c3y,c3z)
      cTTk=cTTk+2.*fac*(cfkx*c3x+cfky*c3y+cfkz*c3z)
c
c   compute the unbalanced vertical stress at the bottom of the plate 
c
      call fterm(kx,ky,d1,d2,-H1,H2,m,uxs,uys,uzs,
     +                              vys,vzs,wzs,
     +                              c3x,c3y,c3z)
      cTBk=cTBk+fac*(cfkx*c3x+cfky*c3y+cfkz*c3z)
c
      call fterm(kx,ky,-d1,-d2,-H1,H2,m,uxs,uys,uzs,
     +                              vys,vzs,wzs,
     +                              c3x,c3y,c3z)
      cTBk=cTBk+fac*(cfkx*c3x+cfky*c3y+cfkz*c3z)
c
  100 continue
c
c   load the coefficients for the Boussinesq problem use rla(1) and rmu(1)
c
      if(namx.eq.0) then
        rlam2=rlam1
        rmu2=rmu1
      else
        nlay=min(4,namx)
        rlam2=rla(nlay)
        rmu2=rmu(nlay)
      endif
c
c   compute the boussinesq for the top loading
c
      call boussinesql(kx,ky,z,H1,cub,cvb,cwb,cdudz,cdvdz,cdwdz)
c
c  compute the total displacement
c
      cuk=cuk+(cTTk+cTBk)*cub
      cvk=cvk+(cTTk+cTBk)*cvb
      cwk=cwk+(cTTk+cTBk)*cwb
c
c   compute the boussinesq for the top loading of a half space
c
      call boussinesq(kx,ky,z,cuhs,cvhs,cwhs,cdwdzhs)
c
c  subtract this component from the bottom load only
c
      cuk=cuk-cTBk*cuhs
      cvk=cvk-cTBk*cvhs
      cwk=cwk-cTBk*cwhs
c
      return
      end
c

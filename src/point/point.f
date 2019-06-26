c
      program point
c
c*****************   main program   ************************
c
c  Tests the full 3-D, time-dependent response of an elastic
c  plate over a viscoelastic half space [Smith and Sandwell, 2004,
c  Appendix A and Figure 6.
c
c  This program computes the three cases shown in Figure 6.
c  To execute a particular case you uncomment the appropriate
c  lines below and recompile/execute.
c
c  D. Sandwell and B Smith, Dec. 2003.
c
c***********************************************************
c
      implicit real*8(a,b,d-h,o-z)
      implicit complex*16 (c)
      real*8 kx,ky
      real*8 rln0,rlt0,ddx,ddy,rland,rdum
c
c  change ni and nj as needed
c
      parameter(ni=4096,nj=4096,nwork=32768,nj2=nj/2+1,ni2=ni/2+1)
      character*80 fxdisp,fydisp,fzdisp
      character*80 ch,cz,crho,cshr,cstr
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      real*4 fz(nj,ni)
      real*4 u(nj,ni),v(nj,ni),w(nj,ni)
      complex*8 fkz(nj2,ni)
      complex*8 uk(nj2,ni),vk(nj2,ni),wk(nj2,ni)
      dimension n(2)
      complex*8 work(nwork)
      equivalence (fz(1,1),fkz(1,1))
      equivalence (u(1,1),uk(1,1))
      equivalence (v(1,1),vk(1,1))
      equivalence (w(1,1),wk(1,1))
c
      pi=acos(-1.)
      grv=-9.8
c
c  zero the arrays fx,fy,fz
c
      do 30 i=1,ni
      do 30 j=1,nj
      fz(j,i)=0.
  30  continue
c
c  set the dimensions for fourt
c
      n(1)=nj
      n(2)=ni
c
c   get values from command line
c
      narg = iargc()
      if(narg.lt.8) then
        write(*,'(a)')'  '
        write(*,'(a)')
     &  'Usage: point H rho u2/u1 Zobs istr xd.grd yd.grd zd.grd'
        write(*,'(a)')
        write(*,'(a)')
     &  '       H       - depth to bottom of elastic layer '
        write(*,'(a)')
     &  '       rho     - density of halfspace '
        write(*,'(a)')
     &  '       u2/u1   - hs shear mod./layer shear mod. '
        write(*,'(a)')
     &  '       Zobs    - observation plane < 0 '
        write(*,'(a)')
     &  '       istress - (0)-disp. U,V,W or (1)-stress Txx,Tyy,Txy'
        write(*,'(a)')
     &  '       x,y,z.grd - output files of disp. or stress '
        write(*,'(a)')'  '
        stop
      else 
        call getarg(1,ch)
        call getarg(2,crho)
        call getarg(3,cshr)
        call getarg(4,cz)
        call getarg(5,cstr)
        read(ch,*)thk
        read(cz,*)zobs
        read(crho,*)rho
        read(cshr,*)shr
        read(cstr,*)istr
        call getarg(6,fxdisp)
        nc=index(fxdisp,' ')
        fxdisp(nc:nc)=char(0)
        call getarg(7,fydisp)
        nc=index(fydisp,' ')
        fydisp(nc:nc)=char(0)
        call getarg(8,fzdisp)
        nc=index(fzdisp,' ')
        fzdisp(nc:nc)=char(0)
      endif
c
c   set Young's modulus to 70 Gpa and Poisson's ratio to .25
c
      young=7.e10
      rlam1=2*young/5.
      rmu1=rlam1
      bulk=rlam1+2*rmu1/3.
      H=abs(thk)
c
c  compute the flexural rigidity using the thickness in m.
c
      DF=1.e9*young*H**3/11.25
c
c  allow rmu2 to vary but don't let the bulk
c  modulus change
c
      rmu2=rmu1*shr
      rlam2=bulk-2.*rmu2/3.
c
      dx=0.5
      width=dx*nj
      height=dx*ni
      alph=(rlam1+rmu1)/(rlam1+2*rmu1)
      rc=alph/(4.*rmu1)
      rd=(rlam1+3*rmu1)/(rlam1+rmu1)
      sig=sig/dx
      if(sig.lt.1)sig=1
c
c  put a point load in the center of the grid
c
      fz(nj2,ni2)=1./(ni*nj)/(dx*dx);
c
c  take the fourier transform of the force
c
      call fourt(fz,n,2,-1,0,work,nwork)
c
c  construct the boussinesq
c
      do 255 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 255 j=1,nj2
      kx=(j-1)/width
c
c ****** uncomment the appropriate lines below
c
c  Case 1 point load on elastic half space 
c         (Figure 6, dashed curve)
c
c     call boussinesq(kx,ky,zobs,cub,cvb,cwb,cdwdz)
c
c  Case 2 point load on elastic plate over half-space of different rigidity 
c         (Figure 6, gray curve for zero half-space rigidity)
c
      call boussinesql(kx,ky,zobs,H,cub,cvb,cwb,cdudz,cdvdz,cdwdz)
c
c  now either output displacement or stress
c
      uk(j,i)=rmu1*(fkz(j,i)*cub)
      vk(j,i)=rmu1*(fkz(j,i)*cvb)
      wk(j,i)=rmu1*(fkz(j,i)*cwb)
c
c   Case 3 point load on thin elastic plate over fluid half space
c          (Figure 6, black curve)
c
c     B2=4.*pi*pi*(kx*kx+ky*ky)*1.e-6
c     fac=DF*B2*B2+rho*9.8
c     wk(j,i)=-rmu1*fkz(j,i)/(fac*1.e3)
c
c  now compute the stress if requested. 
c
      if(istr.eq.1) then
        cux=cmplx(0.,2.*pi*kx)*uk(j,i)
        cvy=cmplx(0.,2.*pi*ky)*vk(j,i)
        cuy=cmplx(0.,2.*pi*ky)*uk(j,i)
        cvx=cmplx(0.,2.*pi*kx)*vk(j,i)
        cwz=rlam1*(cux+cvy)/(rlam1+2.*rmu1)
c
c  assume units are km so divide by 1000
c
        uk(j,i)=.001*((rlam1+2*rmu1)*cux+rlam1*(cvy+cwz))
        vk(j,i)=.001*((rlam1+2*rmu1)*cvy+rlam1*(cux+cwz))
        wk(j,i)=.001*(rmu1*(cuy+cvx))
      endif
 255  continue
c
c  do the inverse fft's
c
      call fourt(u,n,2,1,-1,work,nwork)
      call fourt(v,n,2,1,-1,work,nwork)
      call fourt(w,n,2,1,-1,work,nwork)
c
c  write 3 grd files some parameters must be real*8
c
      rln0=0.
      rlt0=0.
      ddx=dx
      ddy=dx
      rland=9998.
      rdum=9999.
      if(istr.eq.1) then
       rland=9998.d0*rmu1
       rdum=9999.d0*rmu1
      endif
      call writegrd(u,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,fxdisp,fxdisp)
      call writegrd(v,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,fydisp,fydisp)
      call writegrd(w,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,fzdisp,fzdisp)
      stop
      end

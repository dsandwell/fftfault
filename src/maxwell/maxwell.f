c
      program maxwell
c
c******************************************************************
c  REFERENCE:
c  Smith, B. and D. Sandwell, A three-dimensional semianalytic viscoelastic 
c  model for time-dependent analysis of the earthquake cycle,
c  J. Geophys. Res., v. 109, B12401, 2004.
c******************************************************************
c
c modified 04/13/07  add gravity to common block
c modified 04/15/08 to move grv to end of common block
c modified 04/15/08 to change the method of string terminator.  
c The trim code does not exist on c all computers so went back to the 
c old method with one minor change
c         nc=index(fxdisp,' ')
c         fxdisp(nc:nc)=char(0)

c modified 05/06/11 to add stress mask back in
c modified 02/15/12 to change idble to idbll (compatible with dipping code)

c******************************************************************

c
c  USAGE:
c  Program to calculate the surface displacement or stress
c  due to planar vertical fault consisting of many elements
c  where the slip varies on each element.  The model consists 
c  of an elastic plate of thickness H over a visco-elastic half space.
c  All elements slip between depths D1 and D2 where D1 must be
c  above the base of the plate. One can simulate either a single-couple
c  or double couple dislocation. The displacement or stress 
c  can be observed at any depth above the lower locking depth.
c
c  EXAMPLE:
c  An example of a double-couple fault extending from the base of the
c  plate to a depth of 20 km follows:
c
c******************************************************************
c  maxwell -50 -50 -20 0 99 1 all_segs.dat 0 xall.grd yall.grd zall.grd
c******************************************************************
c
c  The three components of surface displacement are stored
c  in three grd-files for use with GMT software.
c
c  Fault elements are stored in the file all_segs.dat
c
c******************************************************************
c  # dx  sig fault_orientation
c     1. 1.  90.
c  549.36 549.36   0.00 128.53 -40.00   0.00   0.00
c  549.36 549.62 128.53 132.51 -40.00   0.00   0.00
c  549.62 549.88 132.51 136.48 -40.00   0.00   0.00
c  549.88 550.26 136.48 142.45 -40.00   0.00   0.00
c  550.26 551.43 142.45 149.49 -40.00   0.00   0.00
c  551.43 552.47 149.49 154.55 -40.00   0.00   0.00
c******************************************************************
c
c  The first line is a comment line.  
c  The second line has; grid spacing(km), fault thickness(km), and average
c  fault orientation w.r.t the x-axis
c  Subsequent lines have the end points of the fault followed by slip
c  rates; strike-slip, dip-slip, and opening. Millions of elements
c  could be used without a change in memory or execution time.
c
c  A mirror fault is constructed to match the
c  the far-field boundary conditions. For an infinitely-long, straight fault,
c  this program generates the arctangent model. 
c
c*****************   main program   ************************
c
      implicit real*8 (a,b,d-h,o-z)
      implicit complex*16 (c)
      real*8 kx,ky,kh2
c
c**User: change ni and nj as needed*************************
      parameter(ni=4096,nj=4096,nwork=32768,nj2=nj/2+1,ni2=ni/2+1)
c     parameter(ni=16,nj=8192,nwork=32768,nj2=nj/2+1,ni2=ni/2+1)
c*************************************************************
      parameter (nl=140)
      character*80 felement,fxdisp,fydisp,fzdisp,frmu,tmpname
      character*80 cfac,cd1,cd2,cz,ct,cdbl,cstr
      character*80 cthk,ceta,cpois,cfd
      real*8 An(nl),rla(nl),rmu(nl)
c
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
c  the working arrays are all real*4, complex*8 to save memory
c
      real*4 fx(nj,ni),fy(nj,ni),fz(nj,ni),fm(nj,ni)
      real*4 dfx(nj,ni),dfy(nj,ni)
      real*4 u(nj,ni),v(nj,ni),w(nj,ni)
      real*4 rlamv(nj,ni),rmuv(nj,ni)
      real*4 exx(nj,ni),eyy(nj,ni),exy(nj,ni)
      complex*8 fkx(nj2,ni),fky(nj2,ni),fkz(nj2,ni)
      complex*8 dfkx(nj2,ni),dfky(nj2,ni)
      complex*8 uk(nj2,ni),vk(nj2,ni),wk(nj2,ni)
      complex*8 uk0(nj2,ni),vk0(nj2,ni),wk0(nj2,ni)
      complex*8 exxk(nj2,ni),eyyk(nj2,ni),exyk(nj2,ni)
      dimension n(2)
      complex*8 work(nwork)
      equivalence (fx(1,1),fkx(1,1))
      equivalence (fy(1,1),fky(1,1))
      equivalence (fz(1,1),fkz(1,1))
      equivalence (dfx(1,1),dfkx(1,1))
      equivalence (dfy(1,1),dfky(1,1))
      equivalence (u(1,1),uk(1,1))
      equivalence (v(1,1),vk(1,1))
      equivalence (w(1,1),wk(1,1))
      equivalence (exx(1,1),exxk(1,1))
      equivalence (eyy(1,1),eyyk(1,1))
      equivalence (exy(1,1),exyk(1,1))
c
c*********User: set these default model parameters************

      rho=3300.
      fr=0.6
      shear=3.0e10
      pois=0.25
      eta=1.e19
      thk=-50.
      fd=1.0
      grv=-9.8
      itermx=10
c*************************************************************
c
      pi=acos(-1.)
      spyr=86400*365.25
      iter = 0
c
c  zero the arrays fx,fy,fz
c
      do 30 i=1,ni
      do 30 j=1,nj
      fx(j,i)=0.
      fy(j,i)=0.
      fz(j,i)=0.
      rlamv(j,i)=0.
      rmuv(j,i)=0.
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
      if(narg.lt.11) then
        write(*,'(a)')'  '
        write(*,'(a)')
     &  'Usage: maxwell F D1 D2 Z T dble ele.dat istr U.grd V.grd W.grd'
        write(*,'(a)')
        write(*,'(a)')
     &  '       F       - factor to multiply output files'
        write(*,'(a)')
     &  '       D1, D2  - depth to bottom and top of fault (neg) '
        write(*,'(a)')
     &  '       Z       - depth of observation plane '
        write(*,'(a)')
     &  '       T       - time since earthquake (yr) '
        write(*,'(a)')
     &  '       dble    - (0-single couple, 1-double couple)'
        write(*,'(a)')
     &  '       ele.dat - file of: x1,x2,y1,y2,F1,F2,F3'
        write(*,'(a)')
     &  '       istress - (0)-disp. U,V,W'
        write(*,'(a)')
     &  '                 (1)-stress Txx,Tyy,Txy'
        write(*,'(a)')
     &  '                 (2)-stress Tnormal,Tshear,Tcoulomb'
        write(*,'(a)')
     &  '       x,y,z.grd - output files of disp. or stress '
        write(*,'(a)')
     &  '       H       - plate thickness (default: H=-50km) - optional'
        write(*,'(a)')
     &  '       eta     - viscosity (default: eta=1.e19) - optional'
        write(*,'(a)')
     &  '       pois	- poissons ratio (default: pois=0.25) - optional'
        write(*,'(a)')
     &  '       fd	- depth factor (default: fd=1) - optional'
        write(*,'(a)')'  '
        stop
      else 
        call getarg(1,cfac)
        call getarg(2,cd1)
        call getarg(3,cd2)
        call getarg(4,cz)
        call getarg(5,ct)
        call getarg(6,cdbl)
        call getarg(7,felement)
        call getarg(8,cstr)
        read(cfac,*)fac
        read(cd1,*)d1
        read(cd2,*)d2
        read(cz,*)zobs
        read(ct,*)timey
        time=spyr*timey
	read(cdbl,*)idble
        read(cstr,*)istr
	
        call getarg(9,fxdisp)
        nc=index(fxdisp,' ')
        fxdisp(nc:nc)=char(0)
        call getarg(10,fydisp)
        nc=index(fydisp,' ')
        fydisp(nc:nc)=char(0)
        call getarg(11,fzdisp)
        nc=index(fzdisp,' ')
        fzdisp(nc:nc)=char(0)
        if(narg.eq.15) then
          call getarg(12,cthk)
          call getarg(13,ceta)
          call getarg(14,cpois)
          call getarg(15,cfd)
          read(cthk,*)thk
          read(ceta,*)eta
          read(cpois,*)pois
          read(cfd,*)fd

        endif	  
c
c   scale d1 by fd for double couple models only
c
          if(idble.eq.1) d1=d1*fd
          write(*,*)'H,eta,pois,d1,d2 = ',thk,eta,pois,d1,d2
        endif
	  if(thk.gt.d1.or.d1.gt.d2.or.d2.gt.0.or.
     +     zobs.lt.d1) then
         write(*,'(a)')' depths  must be  negative H < d1 < d2 '
         stop
      endif
c
c  open the input file and load the force arrays
c
      open(unit=5,file=felement,status='old')
      read(5,*)cd1
c
c  read the fault constants and possibly shear grid
c
      read(5,*) dx,sig,psi,itermx,frmu
c
c   read the grid of shear modulus if itermx > 0
c
      if(itermx.eq.0) then
         rmu1 = shear
         rlam1=2.0*rmu1*pois/(1.-2.*pois)
      else
         nc=index(frmu,' ')
         frmu(nc:nc)=char(0)
         call readgrd(rmuv,nx,ny,rln0,rlt0,ddx,ddy,rdum,title,frmu)
         if(nx.ne.nj.or.ny.ne.ni) then
           write(*,'(a)')'dims of shear grid to not match prog dims '
           stop
         endif
c
c  mirror the shear grid
c
         do 15 iy=1,ni
         do 15 jx=1,nj2
         rmuv(nj+1-jx,iy)=rmuv(jx,iy)
   15    continue
c
c compute the mean of the shear and remove it from the grid
c calculate the mean and variable part of lambda
c
         sum=0.
         do 20 i=1,ni
         do 20 j=1,nj
         sum=sum+rmuv(j,i)
   20    continue
         rmu1=sum/(ni*nj)
         rlam1=2.0*rmu1*pois/(1.-2.*pois)
         do 25 i=1,ni
         do 25 j=1,nj
         rmuv(j,i)=rmuv(j,i)-rmu1
         rlamv(j,i)=2.0*rmuv(j,i)*pois/(1.-2.*pois)
   25    continue
      endif
c
c  compute the force grids
c
      width=dx*nj
      height=dx*ni
      if(pois.ge.0.5) then
        write(*,'(a)')' error in Poisson ratio '
        stop
      endif
      alph=(rlam1+rmu1)/(rlam1+2*rmu1)
      rc=alph/(4.*rmu1)
      rd=(rlam1+3*rmu1)/(rlam1+rmu1)
      sig=sig/dx
c     if(sig.lt.1)sig=1
c
c  read the elements
c
      nF2=0
      nF3=0
   50 read(5,*,end=999)x1,x2,y1,y2,F1,F2,F3
c
c is either F2 or F3 being used?
c
      if(F2.ne.0.0)nF2=nF2+1
      if(F3.ne.0.0)nF3=nF3+1
      x1=x1/dx
      x2=x2/dx
c
c  invert the y-positions to allign with i-index
c
      y1=ni-y1/dx
      y2=ni-y2/dx


c  change idble to idbll to make compatible with maxwell_ssdip in elment
      idbll=idble
c
c  figure out the part of the array to add the new forces
c
      ipd=3*sig+2
      jx0=min(x1,x2)-ipd
      jxf=max(x1,x2)+.5+ipd
      iy0=min(y1,y2)-ipd
      iyf=max(y1,y2)+.5+ipd
      do 100 iy=iy0,iyf
      do 110 jx=jx0,jxf
        if(jx.le.0.or.jx.gt.nj) go to 110
        if(iy.le.0.or.iy.gt.ni) go to 110
        x=jx
        y=iy
        call element(x,y,x1,y1,x2,y2,dx,sig,idbll,F1,F2,F3,fxx,fyy,fzz)
c
c remove the x-forces if the fault is single couple
c
        fx(jx,iy)=fx(jx,iy)+fxx
        fy(jx,iy)=fy(jx,iy)+fyy
        fz(jx,iy)=fz(jx,iy)+fzz
        if(idble.eq.0) fx(jx,iy)=0.0
 110  continue
 100  continue
      go to 50
 999  close(unit=5)
c
c  send a warning about F2 and F3
c
      if(nF2.gt.0.or.nF3.gt.0) write(*,'(a)')
     &  ' warning: dip-slip (F2) and opening (F3) assume single couple'

c
c  mirror the source in the x-direction
c  this will make the finite displacement BC's match
c  one could also use a cosine transform
c
      do 150 iy=1,ni
      do 150 jx=1,nj2
      fx(nj+1-jx,iy)=-fx(jx,iy)
      fy(nj+1-jx,iy)= fy(jx,iy)
      fz(nj+1-jx,iy)= fz(jx,iy)
 150  continue
c
c   compute the magnitude of the force for masking the stress
c
      do 155 iy=1,ni
      do 155 jx=1,nj
      fxt=fx(jx,iy)
      fyt=fy(jx,iy)
      fzt=fz(jx,iy)
      f22=fxt*fxt+fyt*fyt+fzt*fzt
      fm(jx,iy)=0.0
      if(f22.gt.0.05) fm(jx,iy)=1.
 155  continue
c
c  take the fourier transform of the forces
c
      call fourt(fx,n,2,-1,0,work,nwork)
      call fourt(fy,n,2,-1,0,work,nwork)
      call fourt(fz,n,2,-1,0,work,nwork)
c
c  zero the force update
c
      do 158 i=1,ni
      do 158 j=1,nj2
      dfkx(j,i)=cmplx(0.,0.)
      dfky(j,i)=cmplx(0.,0.)
  158 continue
c
c  make the coefficients for the visco-elastic half space
c
      call coefan(eta,time,nl,An,namx,rla,rmu)
c
c make the starting model and save it
c
      do 160 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 160 j=1,nj2
      kx=(j-1)/width
      cfkx=fkx(j,i)
      cfky=fky(j,i)
      cfkz=fkz(j,i)
c
c  calculate the strain at 0.63*d2 
c  because this represents the depth-averaged strain
c  see notes at http://topex.ucsd.edu/geodynamics/13fault_disp.pdf
c
      zobs1=0.50*d2
      call fvisco(kx,ky,thk,d1,d2,zobs1,An,rla,rmu,namx,
     +                                  cfkx,cfky,cfkz,
     +                                    cuk,cvk,cwk)
      uk0(j,i)=fac*rmu1*cuk/(ni*nj)
      vk0(j,i)=fac*rmu1*cvk/(ni*nj)
      wk0(j,i)=fac*rmu1*cwk/(ni*nj)
      uk(j,i)=uk0(j,i)
      vk(j,i)=vk0(j,i)
      wk(j,i)=wk0(j,i)
  160 continue
c
c  loop over the iterations
c
      do 200 iter=1,itermx
c
c  compute the 2-D strain
c
      do 165 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 165 j=1,nj2
      kx=(j-1)/width
      exxk(j,i)=1.e-6*cmplx(0.,2*pi*kx)*uk(j,i)
      eyyk(j,i)=1.e-6*cmplx(0.,2*pi*ky)*vk(j,i)
      exyk(j,i)=1.e-6*0.5*(cmplx(0.,2*pi*ky)*uk(j,i)
     +              +cmplx(0.,2*pi*kx)*vk(j,i))
  165 continue
c
c  take the inverse transform of the 2-D strain so we 
c  can multiply by the elastic constants
c
      call fourt(exx,n,2,1,-1,work,nwork)
      call fourt(eyy,n,2,1,-1,work,nwork)
      call fourt(exy,n,2,1,-1,work,nwork)
c
c   write the strain array
c
      rln0=0.
      rlt0=0.
      ddx=dx
      ddy=dx
      rland=1.e13
      rdum=1.e13
      tmpname="exy.grd"
      nc=index(tmpname,' ')
      tmpname(nc:nc)=char(0)
      call writegrd(exy,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,tmpname,tmpname)      
c
c  now compute the stress tensor from just the variable part
c
      do 170 i=1,ni
      do 170 j=1,nj
      exxv=exx(j,i)
      eyyv=eyy(j,i)
      exyv=exy(j,i)
      exx(j,i)=(rlamv(j,i)+2*rmuv(j,i))*exxv+rlamv(j,i)*eyyv
      eyy(j,i)=(rlamv(j,i)+2*rmuv(j,i))*eyyv+rlamv(j,i)*exxv
      exy(j,i)=2*rmuv(j,i)*exyv
  170 continue
c
c  transform the stress tensor so we can take derivative
c
      call fourt(exx,n,2,-1,0,work,nwork)
      call fourt(eyy,n,2,-1,0,work,nwork)
      call fourt(exy,n,2,-1,0,work,nwork)
c
c compute an update to the horizontal body forces
c set the low-pass cosine filter
c     
      rnyquist=1./(2.*dx)
      rmx=1.0*rnyquist
      rmn=0.1*rnyquist
      do 180 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 180 j=1,nj2
      kx=(j-1)/width
c
c  generate the low-pass filter for the force update
c
      rkh=sqrt(kx*kx+ky*ky)
      if(rkh.lt.rmn) then
        sfac = 1.
      elseif (rkh.gt.rmx) then
        sfac= 0.
      else
        sfac=0.5*(cos(pi*(rkh-rmn)/(rmx-rmn))+1.)
      endif
c      if(i.eq.1) write(*,*)kx,ky,rkh,sfac
c
c  the update is the divergence of the 2-D stress tensor
c  need to scale by km/meters for the derivative
c  to understand the derivatives one should write this in index notation
c  the update has units of force per volume
c
      ctermx1 = cmplx(0.,2*pi*kx)*exxk(j,i)
      ctermx2 = cmplx(0.,2*pi*ky)*exyk(j,i)
      dfkx(j,i) = sfac*1.e06*(ctermx1 + ctermx2)/rmu1
      ctermy1 = cmplx(0.,2*pi*ky)*eyyk(j,i)
      ctermy2 = cmplx(0.,2*pi*kx)*exyk(j,i)
      dfky(j,i) = sfac*1.e06*(ctermy1 + ctermy2)/rmu1
  180 continue
c
c  update the solution with the force perturbation
c
      do 190 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 190 j=1,nj2
      kx=(j-1)/width
      cfkx=dfkx(j,i)
      cfky=dfky(j,i)
      cfkz=cmplx(0.,0.)
c
c  calculate the strain at 0.63*d2 
c  because this represents the depth-averaged strain
c  see notes at http://topex.ucsd.edu/geodynamics/13fault_disp.pdf
c  also use -2dx as the upper depth for strain computation
c
      zobs1=0.50*d2
      if(iter.ge.itermx) zobs1=zobs
      call fvisco(kx,ky,thk,d1,-2.*dx,zobs1,An,rla,rmu,namx,
     +                                  cfkx,cfky,cfkz,
     +                                    cuk,cvk,cwk)
      uk(j,i)=uk0(j,i)+rmu1*cuk/(ni*nj)
      vk(j,i)=vk0(j,i)+rmu1*cvk/(ni*nj)
      wk(j,i)=wk0(j,i)+rmu1*cwk/(ni*nj)
  190 continue
c
      write(*,*)'iteration #',iter
c
c***************************
  200 continue
c
c  compute the final model at the desired level in two parts
c
      do 210 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 210 j=1,nj2
      kx=(j-1)/width
c
c  original fault contribution between d1 and d2
c
      cfkx=fkx(j,i)
      cfky=fky(j,i)
      cfkz=fkz(j,i)
      call fvisco(kx,ky,thk,d1,d2,zobs,An,rla,rmu,namx,
     +                                  cfkx,cfky,cfkz,
     +                                    cuk,cvk,cwk)
      uk0(j,i)=fac*rmu1*cuk/(ni*nj)
      vk0(j,i)=fac*rmu1*cvk/(ni*nj)
      wk0(j,i)=fac*rmu1*cwk/(ni*nj)
c
c contribution to variable rigidity between d1 and 0.0
c
      cfkx=dfkx(j,i)
      cfky=dfky(j,i)
      cfkz=cmplx(0.,0.)
      call fvisco(kx,ky,thk,d1,0.0,zobs,An,rla,rmu,namx,
     +                                  cfkx,cfky,cfkz,
     +                                    cuk,cvk,cwk)
      uk(j,i)=uk0(j,i)+rmu1*cuk/(ni*nj)
      vk(j,i)=vk0(j,i)+rmu1*cvk/(ni*nj)
      wk(j,i)=wk0(j,i)+rmu1*cwk/(ni*nj)
  210 continue
c
c  compute the stress if requested. 
c
      do 257 i=1,ni
      ky=-(i-1)/height
      if(i.ge.ni2) ky= (ni-i+1)/height
      do 257 j=1,nj2
      kx=(j-1)/width
      if(istr.ge.1) then
        cux=cmplx(0.,2.*pi*kx)*uk(j,i)
        cvy=cmplx(0.,2.*pi*ky)*vk(j,i)
        cuy=cmplx(0.,2.*pi*ky)*uk(j,i)
        cvx=cmplx(0.,2.*pi*kx)*vk(j,i)
        cwz=-rlam1*(cux+cvy)/(rlam1+2.*rmu1)
c
c  assume units are km so divide by 1000
c  need another factor of 1000 because slip is in mm/yr
c
        uk(j,i)=1.e-6*((rlam1+2*rmu1)*cux+rlam1*(cvy+cwz))
        vk(j,i)=1.e-6*((rlam1+2*rmu1)*cvy+rlam1*(cux+cwz))
        wk(j,i)=1.e-6*(rmu1*(cuy+cvx))
      endif
 257  continue
c
c  do the inverse fft's
c
      call fourt(u,n,2,1,-1,work,nwork)
      call fourt(v,n,2,1,-1,work,nwork)
      call fourt(w,n,2,1,-1,work,nwork)
c
c  compute the dummy value.  we'll make it very big.
c
      rland=1.e13
      rdum=1.e13
c
c  compute the coulomb stress if requested
c
      if(istr.eq.2) then
       do 260 i=1,ni
        do 260 j=1,nj
        txx=u(j,i)
        tyy=v(j,i)
        txy=w(j,i)
        call coulomb(txx,tyy,txy,fr,psi,rnorm,rshr,rcoul)
        u(j,i)=rnorm
        v(j,i)=rshr
        w(j,i)=rcoul
c
c  mask the stress in the fault zone make it VERY big 1.0e12
c
       if(fm(j,i).gt.0.) then
c        if(fm(j,i).eq.1.) then
          u(j,i)=1.0e12
          v(j,i)=1.0e12
	  w(j,i)=1.0e12
        endif
 260  continue
      endif

c
c  write 3 grd files 
c
      rln0=0.
      rlt0=0.
      ddx=dx
      ddy=dx
      call writegrd(u,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,fxdisp,fxdisp)
      call writegrd(v,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,fydisp,fydisp)
      call writegrd(w,nj,ni,rln0,rlt0,ddx,ddy,
     +              rland,rdum,fzdisp,fzdisp)
      
      stop
      end

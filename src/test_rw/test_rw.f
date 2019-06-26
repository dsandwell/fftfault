c
      program test_rw
c
c*****************   main program   ************************
c
c  reading and writing of grd files
c
c***********************************************************
c
      implicit real*8(a,b,d-h,o-z)
      real*8 rln0,rlt0,ddx,ddy,rland,rdum
      integer*4 nx,ny
c
c  change ni and nj as needed
c
      parameter(ni=2048,nj=2048,nwork=32768)
      character*80 uin,uout,title
c
      real*4 u(ni,nj)
c
c  zero the arrays u
c
      do 30 i=1,ni
      do 30 j=1,nj
      u(j,i)=0.
  30  continue
c
      narg = iargc()
      if(narg.lt.2) then
        write(*,'(a)')'  '
        write(*,'(a)')
     &  'Usage: test_rw ui.grd uo.grd '
        write(*,'(a)')
        stop
      else 
        call getarg(1,uin)
        nc=index(uin,' ')
        uin(nc:nc)=char(0)
        call getarg(2,uout)
        nc=index(uout,' ')
        uout(nc:nc)=char(0)
      endif
c
      call readgrd(u,nx,ny,rln0,rlt0,ddx,ddy,rdum,title,uin)
      call writegrd(u,nx,ny,rln0,rlt0,ddx,ddy,
     +              rland,rdum,title,uout)
      stop
      end

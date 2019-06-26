c
      subroutine coefan(reta,timei,nmax,An,namx,rla,rmu)
c
c  modified 04/13/07 to include gravity in common block
c
c  input
c    reta - viscosity (Pa S)
c    time - time (s)
c    nmax - max number of coefficients to compute
c           should not exceed 140 due to factorial overflow
c
c  output
c    An   - coefficients
c    namx - number of An coefficients needed
c    rla  - lambda coresponding to each coefficient
c    rmu  - mu corresponding to each coefficient
c
      implicit real*8 (a-h,o-z)
      real*8 reta,timei,An(1),rla(1),rmu(1)
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
c  make sure nmax is never greater than 140 or the factorial will overflow
c
      if(nmax.gt.140) then
      write(*,'(a)')"**** factorial overflow when nmax > 140"
      nmax=140
      endif
c
c
c scale both a and time to prevent overflows
c
      scale=1.e11
      bulk=rlam1+2*rmu1/3.
      fac=1.
      time=timei/scale
      a=scale*rmu1/(2.*reta)
      at=a*time
      eat=0.0
      if(at.lt.200) eat=exp(-at)
      An(1)=(1.-eat)
      Bnsave=An(1)/a
c
c  do all of the terms
c
      do 50 n=2,nmax
      if(n.gt.2) fac=fac*(n-1)
      term=-eat*(time**(n-1))/a
      Bn=term+(n-1)*Bnsave/a
      Bnsave=Bn
      An(n)=Bn*(a**n)/fac
c
c  zero terms when less than 1.e-6
c
      if(An(n).le.1.e-06) then 
       An(n)=0.
      endif
  50  continue
c
c  compute the corresponding elastic constants
c
      namx=nmax
      do 100 n=1,nmax
      if(namx.eq.nmax.and.An(n).eq.0.) namx=n-1
      c1=An(n)**(1./n)
      rat=(1-c1)/(1+c1)
      rmu(n)=rmu1*rat
c
c  don't let rmu(n) = 0. unless at > 100 maxwell times
c  if rmu() = 0. this triggers the plate model
c
      if(at.le.100.and.rmu(n).eq.0) rmu(n)=1.
c
c make sure the bulk modulus remains constant
c
      rla(n)=bulk-2.*rmu(n)/3.
 100  continue
      return
      end

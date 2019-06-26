c
      subroutine coulomb(txx,tyy,txy,fr,pssi,rn,rs,rcl)
c
c  modified 07/19/07 maxwell_E.f to allow variations in pssi
c  modified 04/13/07 to include gravity in common block
c
c  input
c    txx - xx-component of stress (Pa)
c    tyy - yy-component of stress (Pa)
c    txy - xy-component of stress (Pa)
c    tzz - zz-component of stress (Pa)
c    fr  - coefficient of friction
c    psi - fault orientation CCW from east (deg)
c
c  output
c    rn   -  normal stress on fault
c    rs   -  shear stress on fault
c    rcl  -  coulomb stress in Pa
c       
      implicit real*8(a-h,o-z)
      common/plate/rlam1,rlam2,rmu1,rmu2,rho,rc,rd,alph,pi,grv
c
      rad=pi/180.
      sp=sin(pssi*rad)
      s2p=sin(2.*pssi*rad)
      cp=cos(pssi*rad)
      c2p=cos(2.*pssi*rad)
      rn=txx*sp*sp-2*txy*sp*cp+tyy*cp*cp
      rs=0.5*(tyy-txx)*s2p+txy*c2p
c
c  compute the coulomb stress
c
c  note, normal stress is taken as negative, so subtracting normal stress
c  leads to adding:  shear + normal  (change 10/8/03)

      rcl=rs+fr*rn
      return
      end
c

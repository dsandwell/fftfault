#!/bin/csh -f
#
#  This script tests the maxwell and maxwell programs.
#  They should be compiled with ni = 4096 nj = 4096
#  You will need the file all_segs.dat which is a
#  digitized plate boundary as well as a file 
#  shear_xy_filtered.grd which is a file of shear
#  modulus.
#
ln -s 01_rheology/shear_xy_filtered.grd .
#
#  slip on all segments elastic half space (t=0)
#
time ../../bin/maxwell 1 -30 -10 0 0 0 all_segs_no_iter.dat 0 xm1.grd ym1.grd zm1.grd -30 1.e19 .25 1
time ../../bin/maxwell 1 -30 -10 0 0 0 all_segs.dat 0 xm1_v.grd ym1_v.grd zm1_v.grd -30 1.e19 .25 1
grdmath ym1_v.grd ym1.grd SUB = ym1_diff.grd
#
#
#  slip on all segments elastic plate (t=99999)
#
time ../../bin/maxwell 1 -30 -10 0 999999 0 all_segs_no_iter.dat 0 xm2.grd ym2.grd zm2.grd -30 1.e19 .25 1
time ../../bin/maxwell 1 -30 -10 0 999999 0 all_segs.dat 0 xm2_v.grd ym2_v.grd zm2_v.grd -30 1.e19 .25 1
grdmath xm2_v.grd xm2.grd SUB = xm2_diff.grd
grdmath ym2_v.grd ym2.grd SUB = ym2_diff.grd
grdmath zm2_v.grd zm2.grd SUB = zm2_diff.grd
#
#  One sets the number of iterations in the all_segs.dat file.  For the second case we have the following 
#  characteristics for the displacement and differences between 10 and 4 iterations
#
#  comp   min    max  std  d_min d_max d_std  d_std/std
#  U     -4.93  4.93 .497  -.02  .02  .002    .004
#  V    -21.15 21.19 15.15 -.05  .05  .005    .0003
#  W     -2.72  4.00 .144  -.002 .001 .0001   .0009
#


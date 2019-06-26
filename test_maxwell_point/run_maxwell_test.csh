#!/bin/csh -f
#
#  This script tests the maxwell program.
#  It should be compiled with ni = 4096, nj = 4096
#  You will need the file all_segs.dat which is a
#  digitized plate boundary.
#
#  Note, that these figures were produced from 
#  a cut version of the files.  The full output files display
#  a mirror of the solution for columns 2049 - 4096.
#  This mirror is created in the program to simulate
#  the step in y-velocity across the plate boundary.
#  for modeling shallow slip on limited faults, this
#  mirror is not needed and could be commented out in the source code.
#
gzip -d shear_xy_filtered.grd.gz
gzip -d ym4_save.grd.gz
#
#  top-to-bottom slip on all segments elastic half space (t=0)
#
time ../bin/maxwell 1 -50 -1 0 0 0 all_segs.dat 0 xm3.grd ym3.grd zm3.grd -50 1.e19 .25 1
#
#  top-to-bottom slip on all segments elastic plate (t=9999)
#
time ../bin/maxwell 1 -50 -1 0 9999 0 all_segs.dat 0 xm4.grd ym4.grd zm4.grd -50 1.e19 .25 1
#
gmt grdinfo ym4.grd
gmt grdmath ym4.grd ym4_save.grd SUB = diff.grd
gmt grdinfo diff.grd
gzip ym4_save.grd
gzip shear_xy_filtered.grd
rm *.grd

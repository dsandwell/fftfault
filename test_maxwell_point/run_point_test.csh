#!/bin/csh -f
##
#  test the code for a point load. 
#
gzip -d zd_save.grd.gz
#
time ../bin/point -30 3300 0.0 -2. 0 xd.grd yd.grd zd.grd
#
gmt grdinfo zd.grd
gmt grdmath zd.grd zd_save.grd SUB = diff.grd
gmt grdinfo diff.grd
#
rm xd.grd yd.grd zd.grd diff.grd
gzip zd_save.grd

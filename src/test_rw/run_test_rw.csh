#
../../bin/test_rw zd.grd zd_out.grd
gmt grdmath zd.grd zd_out.grd SUB = diff.grd
gmt grdinfo diff.grd
rm zd_out.grd diff.grd

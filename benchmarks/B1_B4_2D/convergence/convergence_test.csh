#
#  script to examine the convergence rate of BM3
#
rm iter.dat
ln -s ../rmu3.grd .
maxwell_v 1 -20 -2 0 0. 1 ss_segs20.dat 0 xm3.grd ym20.grd zm3.grd -40 1.e19 .25 1
foreach iter (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
maxwell_v 1 -20 -2 0 0. 1 ss_segs$iter.dat 0 xm3.grd ym$iter.grd zm3.grd -40 1.e19 .25 1
@ iterm = $iter - 1
grdmath ym$iter.grd ym20.grd  SUB = diff$iter.grd
grdinfo -L1 diff$iter.grd | grep z_min >> iter.dat
end



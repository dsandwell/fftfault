#
#   script to make three stress components for a simple fault geometry
#
maxwell 1. -50 -7 -5 9999 0 seg_test.dat 1 txx_xy.grd tyy_xy.grd txy_xy.grd

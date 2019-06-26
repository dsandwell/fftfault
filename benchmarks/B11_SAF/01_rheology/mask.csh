#
#  script to make a single mask
#
grdmask $1.xy -NNaN/NaN/$2 -G$1.grd -R-136/-100/22/50 -I.01

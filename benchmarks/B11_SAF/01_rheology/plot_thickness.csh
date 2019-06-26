#
# script to make a thickness map for the writeup
#
set R=-R-125/-114/32/40
#
makecpt -Cpolar -T20/100/10 -D -Z > thk.cpt
#
grdgradient thickness_ll.grd -A45 -Nt.4 -Ggrad.grd
grdimage thickness_ll.grd -Igrad.grd -Cthk.cpt $R -Jm1.5 -P -K > thk.ps
psxy segs.ll -J -R -W3,yellow -O -K >> thk.ps
grdcontour thickness_ll.grd -J -R -C10 -A20 -O -K >> thk.ps
pscoast -R -J -Df -W2p -B2WSen -O -K >> thk.ps
psscale -Cthk.cpt -R -J -DJMR+w6+o-3.0/4 -B20+l"elastic thickness (km)" -O -V >> thk.ps
ps2raster thk.ps -Tf -A
rm thk.ps

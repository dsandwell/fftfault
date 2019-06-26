#
#  script to image the various stress components
#
grdcut $1.grd -Gjunk.grd -R0/1024/0/1024
grdmath junk.grd 50000 DIV = new.grd
makecpt -Cpolar -T-2/2/.1 -Z -D > str.cpt
grdgradient new.grd -A315 -Nt.1 -Ggrad.grd
grdimage new.grd -Igrad.grd -Jx.008 -B100/100/SWen -Cstr.cpt -P -X.7 -Y.7 > $1.ps

#
#  script to image the various stress components
#
grdmath $1.grd 1000000 DIV = new.grd
makecpt -Cpolar -T-2/2/.1 -Z -D > str.cpt
grdgradient new.grd -A315 -Nt.7 -Ggrad.grd
grdimage new.grd -Igrad.grd -Jm.5 -B1/1/SWen -Cstr.cpt -P -X.7 -Y.7 > $1.ps

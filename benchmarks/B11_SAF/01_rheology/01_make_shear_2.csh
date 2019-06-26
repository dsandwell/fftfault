#!/bin/csh
#
#  make a model for shear modulus and transform into the POR space
#
#kml2gmt polygons_2.kml > polygons_2.gmt
#
# split all the polygons into different files
#
ln -s save_xy_2/* .
set R=-R-136/-100/22/50
set I=-I.01
#
#  make all the masks
#
mask.csh full 60
mask.csh cb 44
mask.csh ccr 51.5
mask.csh etr 74.5
mask.csh gv 64.5
mask.csh la 58
mask.csh pr 82
mask.csh sg 61.5
mask.csh sn 102
mask.csh st 35
mask.csh vb 74.5
mask.csh wbr 45
mask.csh wmd 60.5
mask.csh wtr 58
#
#  now combine them all
#
cp full.grd shear_ll.grd
grdmath  cb.grd shear_ll.grd AND = shear_ll.grd
grdmath ccr.grd shear_ll.grd AND = shear_ll.grd
grdmath etr.grd shear_ll.grd AND = shear_ll.grd
grdmath  gv.grd shear_ll.grd AND = shear_ll.grd
grdmath  la.grd shear_ll.grd AND = shear_ll.grd
grdmath  pr.grd shear_ll.grd AND = shear_ll.grd
grdmath  sg.grd shear_ll.grd AND = shear_ll.grd
grdmath  sn.grd shear_ll.grd AND = shear_ll.grd
grdmath  st.grd shear_ll.grd AND = shear_ll.grd
grdmath  vb.grd shear_ll.grd AND = shear_ll.grd
grdmath wbr.grd shear_ll.grd AND = shear_ll.grd
grdmath wmd.grd shear_ll.grd AND = shear_ll.grd
grdmath wtr.grd shear_ll.grd AND = shear_ll.grd
#
#  filter the thickness grid for display
#
cp shear_ll.grd tmp.grd
grdfilter tmp.grd -D1 -Fg50 -Gthickness_ll.grd -V
#
#
#  divide by 2 to make shear modulus
#
grdmath shear_ll.grd 2 DIV = shear_ll.grd
#
#  now make this into an llr grid and project into POR
#
grd2xyz shear_ll.grd > shear_ll.lls
trans_pole 1 1 285.6 50.1 276 54 < shear_ll.lls > tmp.xys
awk '{print $7+900,$6+1050,$3}' < tmp.xys > shear_ll.xys
#
#  make this into a grid and extend tp 4096 in the y direction
#
xyz2grd shear_ll.xys -R0/4096/0/4096/ -I4/4 -r -Gtmp1.grd
grdmath tmp1.grd 30 AND = shear_xy.grd
#
#  filter over about a 50 km wavelength
#
grdfilter shear_xy.grd -D0 -I1/1 -Fg51 -Gtmp1.grd -V
grdmath tmp1.grd 1.e9 MUL = shear_xy_filtered.grd
#
#  clean up a bit
#
mv shear_xy_filtered.grd ..
mv thickness_ll.grd ..
rm shear_ll.lls
rm *.xy*
rm *.grd
rm *tmp*
mv ../thickness_ll.grd .
mv ../shear_xy_filtered.grd .

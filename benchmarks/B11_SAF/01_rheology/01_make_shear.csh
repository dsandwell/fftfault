#!/bin/csh
#
#  make a model for shear modulus and transform into the POR space
#
#kml2gmt polygons.kml > polygons.gmt
#
# split all the polygons into different files
#
ln -s save_xy/* .
set R=-R-136/-100/22/50
set I=-I.01
#
#  make all the masks
#
grdmask full.xy	$R $I -r -N30/30/30 -Gfull.grd
grdmask oc.xy  $R $I -r -NNaN/NaN/40 -Goc.grd
grdmask sngv.xy  $R $I -r -NNaN/NaN/40 -Gsngv.grd
grdmask st.xy  $R $I -r -NNaN/NaN/20 -Gst.grd
grdmask br.xy  $R $I -r -NNaN/NaN/20 -Gbr.grd
#
#  now combine them all
#
grdmath oc.grd full.grd AND = tmp1.grd
grdmath sngv.grd tmp1.grd AND = tmp2.grd
grdmath st.grd tmp2.grd AND = tmp1.grd
grdmath br.grd tmp1.grd AND = shear_ll.grd
rm tmp*.grd
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
rm shear_ll.lls
rm *.xy*
rm *.grd
rm *tmp*
mv ../shear_xy_filtered.grd .

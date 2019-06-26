#
#  plot teh three components of velocity as well as the 
#  velocity differences and contours of shear modulus
#
rm figure11a.ps
set CR=-R/700/1400/400/1650
set R=-R/0/700/0/1250
set I=-I1/1
set J=-Jx.006i
gmtset PS_MEDIA tabloid 
gmtset PS_MEDIA 
#
#  first cut all the grids and reset the origins
#
gmt grdcut shear_xy_filtered.grd $CR -Gs.grd
gmt grdedit s.grd $R
gmt grdmath s.grd 1.e9 DIV = s.grd
gmt grdcut xm2_v.grd $CR -GU.grd
gmt grdedit U.grd $R
gmt grdcut ym2_v.grd $CR -GV.grd
gmt grdedit V.grd $R
gmt grdcut zm2_v.grd $CR -GW.grd
gmt grdedit W.grd $R
gmt makecpt -Cpolar -T-5/5/+n -D > X.cpt
awk '{if(NR > 2) print("> \n",$1-700,$3-400,"\n",$2-700,$4-400)}' < all_segs.dat > segs.xy
awk '{ print($1-200,$2-400)}' < coast.por.dat > coast.xy
#
#  make the U image
#
gmt makecpt -Cpolar -T-5/5/+n -D > U.cpt
gmt grdimage U.grd $J $R -CU.cpt -K > figure11a.ps
gmt psbasemap $J $R -B200WSne:.U: -K -O >> figure11a.ps
gmt psxy segs.xy $J $R -W.5p -O -K >> figure11a.ps
gmt psxy coast.xy $J $R -Sc.02 -Ggray -O -K >> figure11a.ps
gmt psscale -CU.cpt $J $R -Dg560/800+w2.i -B2 -O -K >> figure11a.ps
#
#  make the V image
#
gmt makecpt -Cpolar -T-20/20/+n -D > V.cpt
gmt grdimage V.grd $J $R -CV.cpt -X5.5i -K -O >> figure11a.ps
gmt psbasemap $J $R -B200WSne:.V: -K -O >> figure11a.ps
gmt psxy segs.xy $J $R -W.5p -O -K >> figure11a.ps
gmt psxy coast.xy $J $R -Sc.02 -Ggray -O -K >> figure11a.ps
gmt psscale -CV.cpt $J $R -Dg560/800+w2.i -B5 -O -K >> figure11a.ps
#
#  make the W image
#
gmt makecpt -Cpolar -T-5/5/+n -D > W.cpt
gmt grdimage W.grd $J $R -CW.cpt -X5.5i -K -O >> figure11a.ps
gmt psbasemap $J $R -B200WSne:.W: -K -O >> figure11a.ps
gmt psxy segs.xy $J $R -W.5p -O -K >> figure11a.ps
gmt psxy coast.xy $J $R -Sc.02 -Ggray -O -K >> figure11a.ps
gmt psscale -CW.cpt $J $R -Dg560/800+w2.i -B2 -O -K >> figure11a.ps


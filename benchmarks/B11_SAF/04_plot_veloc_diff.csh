#
#  plot the three components of velocity as well as the 
#  velocity differences and contours of shear modulus
#
rm figure11b.ps
set CR=-R/700/1400/400/1650
set R=-R/0/700/0/1250
set I=-I1/1
set J=-Jx.006i
gmtset PS_MEDIA tabloid 
#
#  transform the rheology boundaries into xy-coordinates
#ln -s rheology/save_xy/*.xy .
#trans_pole 1 0 285.6 50.1 276 54 < br.xy | awk '{if(NR > 1) print $7+200,$6+650}' > br_por.xy
#
#  first cut all the grids and reset the origins
#
gmt grdcut shear_xy_filtered.grd $CR -Gs.grd
gmt grdedit s.grd $R
gmt grdmath s.grd 1.e9 DIV = s.grd
gmt grdcut xm2_diff.grd $CR -GU.grd
gmt grdedit U.grd $R
gmt grdcut ym2_diff.grd $CR -GV.grd
gmt grdedit V.grd $R
gmt grdcut zm2_diff.grd $CR -GW.grd
gmt grdedit W.grd $R
gmt makecpt -Cpolar -T-5/5/+n -D > X.cpt
awk '{if(NR > 2) print("> \n",$1-700,$3-400,"\n",$2-700,$4-400)}' < all_segs.dat > segs.xy
awk '{ print($1-200,$2-400)}' < coast.por.dat > coast.xy
#
#  make the U image
#
gmt makecpt -Cpolar -T-5/5/+n -D > U.cpt
gmt grdimage U.grd $J $R -CU.cpt -K > figure11b.ps
gmt psbasemap $J $R -B200WSne:."delta U":  -K -O >> figure11b.ps
gmt psxy segs.xy $J $R -W.5p -O -K >> figure11b.ps
gmt psxy coast.xy $J $R -Sc.02 -Ggray -O -K >> figure11b.ps
#gmt psxy br_por.xy $J $R -Gp23@20 -L -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+31 $J $R -W2p,cyan -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+37 $J $R -W2p,cyan,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+39.9 $J $R -W2p,cyan,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+29 $J $R -W2p,magenta -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+23 $J $R -W2p,magenta,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+20.1 $J $R -W2p,magenta,"dotted" -O -K -V >> figure11b.ps
gmt psscale -CU.cpt $J $R -Dg560/800+w2.i -B2 -O -K >> figure11b.ps
#
#  make the V image
#
gmt makecpt -Cpolar -T-5/5/+n -D > V.cpt
gmt grdimage V.grd $J $R -CV.cpt -X5.5i -K -O >> figure11b.ps
gmt psbasemap $J $R -B200WSne:."delta V": -K -O >> figure11b.ps
gmt psxy segs.xy $J $R -W.5p -O -K >> figure11b.ps
gmt psxy coast.xy $J $R -Sc.02 -Ggray -O -K >> figure11b.ps
gmt grdcontour s.grd -C+31 $J $R -W2p,cyan -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+37 $J $R -W2p,cyan,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+39.9 $J $R -W2p,cyan,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+29 $J $R -W2p,magenta -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+23 $J $R -W2p,magenta,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+20.1 $J $R -W2p,magenta,"dotted" -O -K -V >> figure11b.ps
gmt psscale -CV.cpt $J $R -Dg560/800+w2.i -B2 -O -K >> figure11b.ps
#
#  make the W image
#
gmt makecpt -Cpolar -T-1/1/+n -D > W.cpt
gmt grdimage W.grd $J $R -CW.cpt -X5.5i -K -O >> figure11b.ps
gmt psbasemap $J $R -B200WSne:."delta W": -K -O >> figure11b.ps
gmt psxy segs.xy $J $R -W.5p -O -K >> figure11b.ps
gmt psxy coast.xy $J $R -Sc.02 -Ggray -O -K >> figure11b.ps
gmt grdcontour s.grd -C+31 $J $R -W2p,cyan -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+37 $J $R -W2p,cyan,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+39.9 $J $R -W2p,cyan,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+29 $J $R -W2p,magenta -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+23 $J $R -W2p,magenta,"dotted" -O -K -V >> figure11b.ps
gmt grdcontour s.grd -C+20.1 $J $R -W2p,magenta,"dotted" -O -K -V >> figure11b.ps
gmt psscale -CW.cpt $J $R -Dg560/800+w2.i -B.5 -O -K >> figure11b.ps


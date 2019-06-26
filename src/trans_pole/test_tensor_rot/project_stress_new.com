
#%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#% Back Project stress to lat/long
#%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# crop grid
grdcut txx_xy.grd -Gtxxjunk.grd -R0/1024/0/2048
grdcut tyy_xy.grd -Gtyyjunk.grd -R0/1024/0/2048
grdcut txy_xy.grd -Gtxyjunk.grd -R0/1024/0/2048

# make xyz files for stress components
grd2xyz txxjunk.grd > txxjunk.xyz
grd2xyz tyyjunk.grd > tyyjunk.xyz
grd2xyz txyjunk.grd > txyjunk.xyz


# backshift x- ( -400 )  and y- (-850) km from 0-0 model space
# since we reverse x and y here we need to reverse Txx and Tyy and chaneg the sign of Txy
awk '{print ($2-850), ($1-400), $3}' < tyyjunk.xyz > txx.xyz
awk '{print -$3}' < txyjunk.xyz > txy.xyz
awk '{print $3}' < txxjunk.xyz > tyy.xyz
paste txx.xyz txy.xyz tyy.xyz > T.xyzzz

#~~~~~~~~~~~~~~~~~~~~~ Commands below are for scaler stress projection ~~~~~~~~~~~~~~~~~~~

# transform back to geographic coordinates

trans_pole -2 3 285.6 50.1 276 54 < T.xyzzz > T.llzzz

# prepare file for surface

awk '{print -(360-$6), $7, $8}' < T.llzzz > txx.xyz
awk '{print -(360-$6), $7, $9}' < T.llzzz > txy.xyz
awk '{print -(360-$6), $7, $10}' < T.llzzz > tyy.xyz

# run gmt surface for x and y surface interpolation

surface txx.xyz -Gtxx_ll.grd -R-127/-110.3330/28/41.5 -I.01/.01 -V
surface txy.xyz -Gtxy_ll.grd -R-127/-110.3330/28/41.5  -I.01/.01 -V
surface tyy.xyz -Gtyy_ll.grd -R-127/-110.3330/28/41.5 -I.01/.01 -V
 
rm *junk*  


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
#awk '{print ($1-400), ($2-850), $3}' < txxjunk.xyz > txx.xyz
#awk '{print ($1-400), ($2-850), $3}' < tyyjunk.xyz > tyy.xyz
#awk '{print ($1-400), ($2-850), $3}' < txyjunk.xyz > txy.xyz
awk '{print ($2-850), ($1-400), $3}' < txxjunk.xyz > txx.xyz
awk '{print ($2-850), ($1-400), $3}' < tyyjunk.xyz > tyy.xyz
awk '{print ($2-850), ($1-400), $3}' < txyjunk.xyz > txy.xyz



#~~~~~~~~~~~~~~~~~~~~~ Commands below are for scaler stress projection ~~~~~~~~~~~~~~~~~~~

# transform back to geographic coordinates

trans_pole -2 1 285.6 50.1 276 54 < txx.xyz > txx.dat
trans_pole -2 1 285.6 50.1 276 54 < txy.xyz > txy.dat
trans_pole -2 1 285.6 50.1 276 54 < tyy.xyz > tyy.dat

# prepare file for surface

awk '{print -(360-$4), $5, $3}' < txx.dat > txx.xyz
awk '{print -(360-$4), $5, $3}' < txy.dat > txy.xyz
awk '{print -(360-$4), $5, $3}' < tyy.dat > tyy.xyz


# run gmt surface for x and y surface interpolation

surface txx.xyz -Gtxx_ll.grd -R-127/-110.3330/28/41.5 -I.01/.01 -V
surface txy.xyz -Gtxy_ll.grd -R-127/-110.3330/28/41.5  -I.01/.01 -V
surface tyy.xyz -Gtyy_ll.grd -R-127/-110.3330/28/41.5 -I.01/.01 -V

 
rm *junk*  

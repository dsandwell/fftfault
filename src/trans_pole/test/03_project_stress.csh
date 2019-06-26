
#%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#% Back Project stress to lat/long
#%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# crop grid
grdcut txx.grd -Gtxxjunk.grd -R0/1024/0/2048
grdcut tyy.grd -Gtyyjunk.grd -R0/1024/0/2048
grdcut txy.grd -Gtxyjunk.grd -R0/1024/0/2048

# make xyz files for stress components
grd2xyz txxjunk.grd > txxjunk.xyz
grd2xyz tyyjunk.grd > tyyjunk.xyz
grd2xyz txyjunk.grd > txyjunk.xyz


# backshift x- ( -400 )  and y- (-850) km from 0-0 model space
awk '{print ($1-400), ($2-850), $3}' < txxjunk.xyz > txx.xyz
awk '{print ($1-400), ($2-850), $3}' < tyyjunk.xyz > tyy.xyz
awk '{print ($1-400), ($2-850), $3}' < txyjunk.xyz > txy.xyz



#~~~~~~~~~~~~~~~~~~~~~ Commands below are for velocity vector projection ~~~~~~~~~~~~~~~~~~~

# prepare the file for trans_pole (here's example of velocity vector convention here)

# print ykm xkm vy vx 00 00 00 for trans_pole velocity (vx, vy)
# print ykm xkm vz for trans_pole scalar (vz)

paste vx.xyz vy.xyz vz.xyz > vxyz.xyz
awk '{print $2, $1, $6, $3, 0.00, 0.00, 0.00}' < vxyz.xyz > vx_vy.xyz
awk '{print $2, $1, $9}' < vxyz.xyz > vz.xyz


# transform back to geographic coordinates

trans_pole -2 2 285.6 50.1 276 54 < vx_vy.xyz > ve_vn.dat
trans_pole -2 1 285.6 50.1 276 54 < vz.xyz > vu.dat

# should give Podlong Podlat vy vx 0 0 0 lon lat ve vn se sn 0 
# should give Podlong Podlat vz lon lat  
# prepare file for xyz2grd

awk '{print -(360-$8), $9, $10}' < ve_vn.dat > ve.xyz
awk '{print -(360-$8), $9, $11}' < ve_vn.dat > vn.xyz
awk '{print -(360-$4), $5, $3}' <  vu.dat > vu.xyz


# run gmt surface for x and y surface interpolation

surface ve.xyz -Gvjunk.grd -R-127/-110.3330/28/41.5 -I.01/.01 -V
grdsample vjunk.grd -Gve.grd -T

surface vn.xyz -Gvjunk.grd -R-127/-110.3330/28/41.5  -I.01/.01 -V
grdsample vjunk.grd -Gvn.grd -T

surface vu.xyz -Gvjunk.grd -R-127/-110.3330/28/41.5 -I.01/.01 -V
grdsample vjunk.grd -Gvu.grd -T

 
rm *junk*  

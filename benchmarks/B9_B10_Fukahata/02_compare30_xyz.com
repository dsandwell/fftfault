#
#  get the grd file and tweek the bounds
#
cp maxwell_30/*inf.grd .
cp maxwell_30/*00.grd .
#
# U
#
surface U_30.xyz -R-300/300/-300/300 -I1 -r -V -GU_30.grd
grdmath Uinf.grd U00.grd SUB = tmp.grd
grdedit -R-500/524/-500/524  tmp.grd 
grdsample tmp.grd -RU_30.grd -GU.grd
grdtrack U_30.xyz -GU.grd > U_30.xyzz
grdmath U_30.grd U.grd SUB = U_diff.grd
#
#  V
#
surface V_30.xyz -R-300/300/-300/300 -I1 -r -V -GV_30.grd
grdmath Vinf.grd V00.grd SUB = tmp.grd
grdedit -R-500/524/-500/524  tmp.grd 
grdsample tmp.grd -RV_30.grd -GV.grd
grdtrack V_30.xyz -GV.grd > V_30.xyzz
grdmath V_30.grd V.grd SUB = V_diff.grd
#
#  W
#
surface W_30.xyz -R-300/300/-300/300 -I1 -r -V -GW_30.grd
grdmath Winf.grd W00.grd SUB = tmp.grd
grdedit -R-500/524/-500/524  tmp.grd 
grdsample tmp.grd -RW_30.grd -GW.grd
grdtrack W_30.xyz -GW.grd > W_30.xyzz
grdmath W_30.grd W.grd SUB = W_diff.grd

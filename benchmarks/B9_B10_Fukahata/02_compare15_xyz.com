#
#  get the grd file and tweek the bounds
#
cp maxwell_15/*inf.grd .
cp maxwell_15/*00.grd .
#
# U
#
surface U_15.xyz -R-300/300/-300/300 -I1 -r -V -GU_15.grd
grdmath Uinf.grd U00.grd SUB = tmp.grd
grdedit -R-500/524/-500/524  tmp.grd 
grdsample tmp.grd -RU_15.grd -GU.grd
grdtrack U_15.xyz -GU.grd > U_15.xyzz
grdmath U_15.grd U.grd SUB = U_diff.grd
#
#  V
#
surface V_15.xyz -R-300/300/-300/300 -I1 -r -V -GV_15.grd
grdmath Vinf.grd V00.grd SUB = tmp.grd
grdedit -R-500/524/-500/524  tmp.grd 
grdsample tmp.grd -RV_15.grd -GV.grd
grdtrack V_15.xyz -GV.grd > V_15.xyzz
grdmath V_15.grd V.grd SUB = V_diff.grd
#
#  W
#
surface W_15.xyz -R-300/300/-300/300 -I1 -r -V -GW_15.grd
grdmath Winf.grd W00.grd SUB = tmp.grd
grdedit -R-500/524/-500/524  tmp.grd 
grdsample tmp.grd -RW_15.grd -GW.grd
grdtrack W_15.xyz -GW.grd > W_15.xyzz
grdmath W_15.grd W.grd SUB = W_diff.grd

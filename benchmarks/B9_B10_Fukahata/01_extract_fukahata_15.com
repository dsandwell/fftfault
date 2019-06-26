#
#   extract the numbers from the infinite time, Yuki
#   files
#
grep 100000 post2.dat | awk '{printf(" %s %s %s \n", $3, $2, -$5/1000.) }' > U_15.xyz
grep 100000 post2.dat | awk '{printf(" %s %s %s \n", $3, $2, -$4/1000.) }' > V_15.xyz
grep 100000 post2.dat | awk '{printf(" %s %s %s \n", $3, $2, -$6/1000.) }' > W_15.xyz

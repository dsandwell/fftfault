#
#   first test the line mode forward (lon, lat), inverse (lon,lat) and inverse (y, x)
#
sed 's/nan nan/371 371/' < coastll.dat | trans_pole 1 0 285.6 50.1 281 54 > coastll_trans.dat
awk '{print $4, $5}' < coastll_trans.dat | trans_pole -1 0 285.6 50.1 281 54 > coastll_trans_trans.dat
awk '{print $6, $7}' < coastll_trans.dat | trans_pole -2 0 285.6 50.1 281 54 > coastll_trans_trans2.dat
#
#  next test the scalar mode
#
awk '{print $2, $1, $3}' < hector.dat | trans_pole 1 1 285.6 50.1 281 54 > hector_trans.dat
awk '{print $4, $5, $3}' < hector_trans.dat | trans_pole -1 1 285.6 50.1 281 54 > hector_trans_trans.dat
awk '{print $6, $7, $3}' < hector_trans.dat | trans_pole -2 1 285.6 50.1 281 54 > hector_trans_trans2.dat
#
#  next test the vector mode
#
awk '{print $3, $2, $4, $5, $6, $7, $8}' < scecv3_gps.dat | trans_pole 1 2 285.6 50.1 281 54 > scec_trans.dat
awk '{print $8, $9, $10, $11, $12, $13, $14}' < scec_trans.dat | trans_pole -1 2 285.6 50.1 281 54 > scec_trans_trans.dat
awk '{print $15, $16, $10, $11, $12, $13, $14}' < scec_trans.dat | trans_pole -2 2 285.6 50.1 281 54 > scec_trans_trans2.dat
#
# next transform the stress tensor
#
trans_pole 1 3 285.6 50.1 281 54 < stress.dat > stress_trans.dat 
awk '{print $6, $7, $8, $9, $10}' < stress_trans.dat | trans_pole -1 3 285.6 50.1 281 54 > stress_2.dat
awk '{print $11, $12, $8, $9, $10}' < stress_trans.dat | trans_pole -2 3 285.6 50.1 281 54 > stress_3.dat


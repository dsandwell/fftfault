#
#  project and plot all the stress data using the old scalra approach
#
rm *.ps
project_stress_new.com
plot_stress_xy.com txx_xy
plot_stress_xy.com txy_xy
plot_stress_xy.com tyy_xy
plot_stress_ll.com txx_ll
plot_stress_ll.com txy_ll
plot_stress_ll.com tyy_ll

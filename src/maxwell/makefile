#
#	Makefile for maxwell 
#
FFT     = ../../lib/libfftfault.a
FFLAGS= -O3  -Bstatic -m64 
FC = gfortran

maxwell:		maxwell.o 
	$(FC) $(FFLAGS) maxwell.o \
		$(FFT)  -L$(NETCDFHOME)/lib -lnetcdf -L$(GMTHOME)/lib -lgmt -o ../../bin/maxwell
	rm *.o

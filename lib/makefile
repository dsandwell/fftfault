#
# creates fftfault library from C and fortran code
#
#INC = -I/opt/local/include -I/opt/local/include/gmt
INC = -I/usr/local/include -I/usr/local/include/gmt
CFLAGS = $(INC)  -O2 -m64
FFLAGS =  -O3 -m64
FC = gfortran
#
OBJECTS=	boussinesq.o 	boussinesql.o	coefl.o		fourt.o\
		fplate.o	readgrd.o	writegrd.o       element.o\
		coefan.o	fterm.o		fvisco.o	coulomb.o\
		fourtd.o
liba:	$(OBJECTS)
	ar rv libfftfault.a $(OBJECTS)
	rm *.o
	chmod 644 libfftfault.a
	ranlib libfftfault.a

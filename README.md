# fftfault
A three-dimensional semianalytic viscoelastic model for time-dependent analysis of the earthquake cycle
****************************************************************
MAXWELL V2.2 -  December, 2017
    
    Instructions for using the maxwell program.  The
    mathematical formulation is provided in the references.
****************************************************************
RREFERENCES:

    Smith, B. and D. Sandwell, A three-dimensional semianalytic viscoelastic 
    model for time-dependent analysis of the earthquake cycle, 
    J. Geophys. Res., v. 109, B12401, 2004.

    Sandwell, D. and B. Smith-Konter, 2018. Maxwell: A Semi-analytic 4-D Code 
    for Earthquake Cycle Modeling of Transform Fault Systems, 
    Computers & Geosciences, 114, pp.84-97.
    
***************************************************************
INSTALLATION:
Get the complete tar distribution with test cases at:
http://topex.ucsd.edu/body_force/viscoelastic/maxwellV2.2.tar
or use this GITHUB repository https://github.com/dsandwell/fftfault

After unpacking the tar file one should compile and test the code.  
Instructions are provided in INSTALL_TEST.txt. You will need C and Fortran compilers.  Also the reading and writing 
of grid files uses the GMT library.  There are two FORTRAN callable 
subroutines lib/readgrd.c and lib/writegrd.c with versions for GMT5 and GMT4. You may need to modify all the makefiles to have the correct paths to the 
GMT distribution.  Also you could replace these routines with your favorite 
grid file format. After running the test  one can redo all the benchmarks provided 
in this manuscript although  you will need Matlab and GMT5 to make all the figures.
***************************************************************
USAGE OF MAIN PROGRAM MAXWELL:

The main program calculates 3-D surface displacements or stress due to slip across 
a vertical fault consisting of many elements - slip varies on each element. The 
model consists of an elastic plate of thickness H overlying a viscoelastic half-
space. All fault elements slip between depths D1 and D2 above the base of the 
elastic plate.  The model simulates both single-couple and double couple 
dislocations for either deep continuous slip (secular models) or shallow coseismic 
slip (episodic models).  

The program has 11 required and 4 optional command line arguments as follows:

Usage: maxwell F D1 D2 Z T dble ele.dat istr U.grd V.grd W.grd [H eta pois fd]

       F  - Factor to multiply output files used primarily for computing 
            displacement taking place over multiple years.  
   
       D1 D2  - Depth to bottom (D1) and top of fault (D2).  Both
            values should be negative, since z is positive upward in the model.
            (H < D1 < D2 < 0).          
    
       Z  - Depth of observation plane (negative). The observation plane
            must also be above the bottom of the fault (D1 < Z).  Thus stress
            and displacement can be computed from the base of the fault to the 
            surface of the earth.

       T  - Time since earthquake (yrs).  For secular models, T=9999 (infinity).
            For episodic models that simulate earthquake events, this parameter          
            should be set to the number of years that have passed since that 
            event. 
   
       dble - Double or single couple option: 0-single couple,
            1-double couple. For secular models representing deep slip,
            a single couple can be used.  For episodic or coseismic
            models, a double couple should be used. (Note:  if a single-couple 
            is used then a "mirror" fault segment is inserted in the model 
            grid to balance the overall moment of the model.)
   
       ele.dat - Element file containing two header records followed by any 
            number of fault element records. Execution time is largely 
            independent of the number of fault elements.  Elements must be 
            longer than 4 times the grid spacing (dx).

            Header records:
            # dx  sig fault_orient  (note slip is in mm)
              1.  1. 90
                         where dx = grid spacing (default = 1km)
                         sig = source width in pixels (default = 1)
                         fault_orient = general fault orientation 
                         (degrees from x-axis) Used only for Coulomb 
                         stress calculation.
            Fault element records: x1 x2 y1 y2 F1 F2 F3
            x1 x2 = start stop fault element grid location in km
            y1 y2 = start stop fault element grid location in km
            F1 F2 F3 = strike-slip, dip-slip, and opening in mm
            (left-lateral strike-slip is positive.)

            Header records for maxwell_v
            # dx  sig fault_orient itermx shear_grid
              1.  1. 90 10 rmu.grd
                        itermx = number of iterations used for variability calculation
                        rmu.grd - name of the file containing the shear modulus grid

 Example ele.dat file:
 
  dx  sig fault_orient (note slip is in mm) #iter rigidity_grid
  
  1  1 82.05 0 rigidity.grd
  
  549.36 549.36   0.00 128.53 -40.00   0.00   0.00  
  549.36 549.62 128.53 132.51 -40.00   0.00   0.00  
  549.62 549.88 132.51 136.48 -40.00   0.00   0.00  
  549.88 550.26 136.48 142.45 -40.00   0.00   0.00  
  550.26 551.43 142.45 149.49 -40.00   0.00   0.00  
  551.43 552.47 149.49 154.55 -40.00   0.00   0.00  
  552.47 552.85 154.55 160.52 -40.00   0.00   0.00  
  552.85 553.23 160.52 166.48 -40.00   0.00   0.00  
  553.23 554.26 166.48 171.54 -40.00   0.00   0.00  
  554.26 555.95 171.54 175.70 -40.00   0.00   0.00  

       istress -  Displacement/stress output option:
            (0)-displacement U,V,W
            (1)-stress Txx,Tyy,Txy
            (2)-stress Tnormal,Tshear,Tcoulomb
     
       x,y,z.grd - Names for output files of displacement or stress. 
    
The following are optional parameters to override the default values 
set in the source code:
   
       H  - Elastic plate thickness (default: H=-50km) 
   
       eta - Half-space viscosity (default: eta=1.e19 Pas) 
          
       pois - Poisson ratio (default: pois=0.25) 
          
       fd - Locking depth factor (default: fd=1) 
            This parameter only applies for double couple
            models and is used for easy manipulation of a set
            of locking depths for multiple faults.  For fd > 1,
            all locking depths will be multiplied by fd and
            thus become deeper. 

 
****************************************************************
LIMITATIONS OF MODEL:

Vertical Fault Plane:  The present model only accommodates a purely vertical
fault plane, as the mathematical formulation uses a vertically-integrated point-
source Green's function to simulate a fault plane.   For the general case of 
dipping faults, this integration could be numerically performed, although we have 
not incorporated this feature into our code.  

Uniform observation depth:  The output generated by the model is in the form of 
3 grd grids representing one of three output options:  

  (0)-displacement U,V,W
  (1)-Stress Txx,Tyy,Txy
  (2)-Stress Tnormal,Tshear,Tcoulomb

All three grids are results of deformation occurring at a specified observation 
depth (Z).  The model should be run at a variety of output depths to create a full 
3-D image of displacement or stress above the base of the fault plane. 

****************************************************************


/* Fortran callable routine to compute the Boussinesq coefficients 
for an elastic layer over a half space */

/* modified 04/13/07 to include gravity as input parameter */

#include <math.h>

int coefl_(l1i,l2i,u1i,u2i,mi,hi,rho,grv,A1,B1,C1,D1,A2,C2)

/* input parameters */

   double *l1i;          /* lambda 1 */
   double *l2i;          /* lambda 2 */
   double *u1i;          /* shear 1 */
   double *u2i;          /* shear 2 */
   double *mi;           /* wavenumber */
   double *hi;           /* layer thickness */
   double *rho;		/* density */
   double *grv;		/* gravity */

/* output parameters */

   double *A1;           /* coefficient A1 */
   double *B1;           /* coefficient B1 */
   double *C1;           /* coefficient C1 */
   double *D1;           /* coefficient D1 */
   double *A2;           /* coefficient A2 */
   double *C2;           /* coefficient C2 */

{
  double T33,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12;
  double p,g,l1,l2,u1,u2,m,h;
  double arg2,arg4,exp2,exp4;
  double alpha1,mh,denom_common,D11,D22;
  double denom1,denom2,denom_pg,A1x,B1x,C1x,D1x;
  double eta1,alpha2,eta2,m2,mhs,e2,ne2,e4,ne4,emh,Dx1,Dx2;
  double denom_old,denom_new,denom_pgW;

  p=*rho*1.e3;
  g=-fabs(*grv);
  T33=1.0; 
  l1=*l1i;
  l2=*l2i;
  u1=*u1i;
  u2=*u2i;
  m=*mi;
  h=*hi;


/* branch to appropriate case */

  if (h == 0.) {	/*  halfspace  */

#include "../include/halfspace.h"

  }
  else if(p == 0.) {	/*  layer over halfspace, no gravity */

#include "../include/layered.h" 

  }
  else if(u2 == 0.) {    /*  layer over halfspace, with gravity */

#include "../include/plate.h"
 
  }
  else {		/*  thick plate with gravity */

#include "../include/layered_pg.h"    /* this has simplified coefficients, fixed exp */

  }

}

/************************************************************************
* readgrd routine to read and write  a grd file in pixel registration   *
************************************************************************/
/************************************************************************
* Creator: David T. Sandwell    Scripps Institution of Oceanography    *
* Date   : 06/23/95             Copyright, David T. Sandwell           *
************************************************************************/
/************************************************************************
* Modification history:                                                 *
*   Revised for GMT3.4 December 28, 2002 - David Sandwell               *
*   Revised for GMT4.2 May 10, 2007      - David Sandwell               *
************************************************************************/

# include "gmt.h"
# include <stdlib.h>
# include <stdio.h>
# include <math.h>
# include <string.h>

/************************************************************************/
int readgrd_(rdat,nx,ny,rlt0,rln0,dlt,dln,rdum,title,filein)

  float *rdat;            /* real array for output */
  int *nx;                /* number of x points */
  int *ny;                /* number of y points */
  double *rlt0;            /* starting latitude */
  double *rln0;            /* starting longitude */
  double *dlt;             /* latitude spacing */
  double *dln;             /* longitude spacing */
  double *rdum;            /* dummy value */
  char  *title;           /* title */
  char  *filein;          /* filename of input file */
  
  {
   int i, j;
   int argc2 = 1;
   char *argv2[2] = {"dummy",0};
   struct GRD_HEADER grd;

/* execute GMT_begin */
   argc2 = GMT_begin (argc2, argv2);

/*  read the header */
   if (GMT_read_grd_info (filein, &grd)) {
      fprintf (stderr, "Error opening file %s\n", filein);
      exit (EXIT_FAILURE);
   }

/*  read the grid */
   if(GMT_read_grd(filein, &grd, rdat, 0.0, 0.0, 0.0, 0.0, GMT_pad, FALSE )) {
     fprintf (stderr, "Error reading file %s\n", filein);
     exit (EXIT_FAILURE);
   }

/* set all the parameters for output */
   *nx = grd.nx;
   *ny = grd.ny;
   *dlt  = -grd.y_inc;
   *dln  =  grd.x_inc;
   if(grd.node_offset == 1) {
     *rlt0 = grd.y_max;
     *rln0 = grd.x_min; 
   }
   else {
     *rlt0 = grd.y_max + 0.5*grd.y_inc;
     *rln0 = grd.x_min - 0.5*grd.x_inc; 
   }
   *rdum = floor(grd.z_max + 1.);
   strncpy(title,grd.title,GRD_TITLE_LEN); 

/* calculate rdum and reset the dummy values. */
   for (i = 0; i < *nx * *ny; i++) {
       if( isnan (rdat[i]) ) rdat[i] = *rdum; 
   }
  }

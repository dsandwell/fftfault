/************************************************************************
* readgrd routine to read and write a grd file in pixel registration    *
************************************************************************/
/************************************************************************
* Creator: David T. Sandwell    Scripps Institution of Oceanography    *
* Date   : 06/23/95             David T. Sandwell                      *
************************************************************************/
/************************************************************************
* Modification history:                                                 *
*   Revised for GMT3.4 December 28, 2002 - David Sandwell               *
*   Revised for GMT4.2 May 10, 2007      - David Sandwell               *
*   Revised for GMT5.x March 20, 2013    - Paul Wessel                  *
*   Revised for GMT5.3 November 1, 2016  - David Sandwell               *
************************************************************************/

# include "gmt.h"
# include <math.h>
# include <string.h>

/************************************************************************/
int readgrd_(float *rdat, int *nx, int *ny, double *rlt0, double *rln0, \
    double *dlt, double *dln, double *rdum, char *title, char *filein)
{
	/* dat	  = real array for input must have the proper dimensions
	 * nx	  = number of x points 
	 * ny	  = number of y points
	 * rlt0	  = starting latitude
	 * rln0	  = starting longitude
	 * dlt	  = latitude spacing
	 * dln	  = longitude spacing
	 * rdum	  = dummy value
	 * title  = title
	 * filein = filename of input file
	 */

	uint64_t node, nm;
	void    *API = NULL; /* GMT control structure */
        struct  GMT_GRID *A = NULL;   /* Grid structure for header and data of input file */

        /* Begin: Initializing new GMT5 session */
	 if ((API = GMT_Create_Session ("readgrd", 0U, 0U, NULL)) == NULL) return EXIT_FAILURE;

        /* Get header from the grid extract the needed variables */
	if ((A = GMT_Read_Data (API, GMT_IS_GRID, GMT_IS_FILE, GMT_IS_SURFACE, GMT_GRID_HEADER_ONLY, NULL, filein, NULL)) == NULL) return EXIT_FAILURE;
        *nx = A->header->nx;
        *ny = A->header->ny;
	*dlt = -A->header->inc[GMT_Y];
	*dln =  A->header->inc[GMT_X];
	if (A->header->registration == GMT_GRID_PIXEL_REG) {
		*rlt0 = A->header->wesn[GMT_YHI];
		*rln0 = A->header->wesn[GMT_XLO]; 
	}
	else {
		*rlt0 = A->header->wesn[GMT_YHI] + 0.5 * A->header->inc[GMT_Y];
		*rln0 = A->header->wesn[GMT_XLO] - 0.5 * A->header->inc[GMT_X]; 
	}
	*rdum = floor (A->header->z_max + 1.0);

        /* Read the grid and set the NaN's to rdum and copy into the grid from the calling program */
        if (GMT_Read_Data (API, GMT_IS_GRID, GMT_IS_FILE, GMT_IS_SURFACE, GMT_GRID_DATA_ONLY, NULL, filein, A) == NULL) return EXIT_FAILURE;
	nm = (uint64_t)(A->header->nx * A->header->ny);
	for (node = 0; node < nm; node++) {
		if(isnan ((double)A->data[node])) 
                        rdat[node]= (float)*rdum; 
                else 
                        rdat[node] = A->data[node];
	}

        if (GMT_Destroy_Session (API)) return EXIT_FAILURE;     /* Remove the GMT machinery */
	return EXIT_SUCCESS;
}

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
*   Revised for GMT5.x March 20, 2013    - Paul Wessel                  *
*   Revised for GMT5.3 November 1, 2016  - David Sandwell               *
*   Revised for GMT6.1 July 11, 2020     - David Sandwell               *
************************************************************************/

# include "gmt.h"
# include <math.h>
# include <string.h>

/************************************************************************/
int writegrd_(float *rdat, int *nx, int *ny, double *rlt0, double *rln0, \
    double *dlt, double *dln, double *rland, double *rdum, char *title, \
    char *fileout)
{
	/* dat	   = real array for output
	 * nx	   = number of x points
	 * ny	   = number of y points
	 * rlt0	   = starting latitude
	 * rln0	   = starting longitude
	 * dlt	   = latitude spacing
	 * dln	   = longitude spacing
	 * rlan	   = land value
	 * rdum	   = dummy value
	 * title   = title
	 * fileout = filename of output file
	 */
	
	uint64_t node, nm;
        uint64_t dim[4] = {0, 0, 0, 0};
        double wesn[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        double inc[2] = {0.0, 0.0};
	void    *API = NULL; /* GMT control structure */
	struct  GMT_GRID *Out = NULL;   /* Grid structure for header and data of output file */

	/* Begin: Initializing new GMT5 session */
        if ((API = GMT_Create_Session ("writegrd", 0U, 0U, NULL)) == NULL) return EXIT_FAILURE;

	/* Calculate header parameters */
	dim[GMT_X] = *nx;
	dim[GMT_Y] = *ny;
        dim[GMT_Z] = GMT_GRID_PIXEL_REG;
	wesn[GMT_XHI] = *rln0 + *nx * *dln;
	wesn[GMT_XLO] = *rln0;
	if (wesn[GMT_XHI] < wesn[GMT_XLO]) {
		wesn[GMT_XLO] = wesn[GMT_XHI];
		wesn[GMT_XHI] = *rln0;
	}
	inc[GMT_X] = fabs (*dln);
	inc[GMT_Y] = fabs (*dlt);
	wesn[GMT_YHI] = *rlt0 + *ny * *dlt;
	wesn[GMT_YLO] = *rlt0;
	if (wesn[GMT_YHI] < wesn[GMT_YLO]) {
		wesn[GMT_YLO] = wesn[GMT_YHI];
		wesn[GMT_YHI] = *rlt0;
	}

	if ((Out = GMT_Create_Data (API, GMT_IS_GRID, GMT_IS_SURFACE, GMT_GRID_ALL, dim, wesn, inc, \
                GMT_GRID_PIXEL_REG, 0, NULL)) == NULL) return EXIT_FAILURE;
	
	/*  Set dummy and land values to NaN. */
	nm = ((uint64_t)dim[GMT_X]) * ((uint64_t)dim[GMT_Y]);
	for (node = 0;  node < nm; node++) {
		if ((rdat[node] == *rdum) || (rdat[node] == *rland)) rdat[node] = (float)NAN;
                Out->data[node] = rdat[node];
	}

        if (GMT_Set_Comment (API, GMT_IS_GRID, GMT_COMMENT_IS_TITLE, "writegrd", Out)) return EXIT_FAILURE;
    	if (GMT_Write_Data (API, GMT_IS_GRID, GMT_IS_FILE, GMT_IS_SURFACE, GMT_GRID_ALL, NULL, fileout, Out)) return EXIT_FAILURE;

	if (GMT_Destroy_Session (API)) return EXIT_FAILURE;     /* Remove the GMT machinery */
	
	return EXIT_SUCCESS;
}
/************************************************************************/

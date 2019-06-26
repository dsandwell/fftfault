/***************************************************************************
*  Program to project a longitude, latitude, and either a scalar           *
*  or vector, into the pole of deformation POD co-ordinate system.         *
*  The inverse transformation is also performed.                           *
****************************************************************************/

/***************************************************************************
 * Creator:  David Sandwell                                                *
 *           (Scripps Institution of Oceanography)                         *
 * Date   :  11/16/08                                                      *
 ***************************************************************************/

/***************************************************************************
 * Modification history:                                                   *
 * DATE                                                                    *
 * 09/13/11  - added code to do tensor rotation                            *
****************************************************************************/

#include <stdio.h>
#include <string.h> 
#include <math.h>
#include <stdlib.h>
#define PI 3.1415926535897932
#define Re 6371.

char    *USAGE = " \n Usage: "
"trans_pole dir dim lonp latp lonc latc < indata > outdata  \n\n"
"           dir (1) forward (-1) inverse (lon, lat) (-2) inverse (y, x)	\n"
"           dim (0) lon, lat  - coastline file or fault segment file - out of bounds lon or lat signifies a line gap \n"
"               (1) lon, lat, scalar - point values of topography or some other scalar \n"
"               (2) lon, lat, Ve, Vn, Se, En, Ren \n"
"               (3) lon, lat, Txx, Txy, Tyy \n"
"           lonp longitude of pole	\n"
"           latp latitude of pole	\n"
"           lonc longitude of center of Cartesian space	\n"
"           latc latitude of center of Cartesian space	\n"
"           indata ascii file of 2, 3, 7, 5 columns to be transformed	\n"
"           outdata ascii output file of 6, 7, 14 or 10 columns	\n"
" \n"
" example: trans_pole 1 2 287 51 243 32  < SCEC3.dat > SCEC3_trans.dat \n";

int main (int argc, char **argv) {

	double rn[3],rp[3],rq[3],rt[3]; /* unit vectors - north, rot_pole, point, trans_point */
	double rnq[3],rqp[3],rc[3],rcross,rdot;
	double d[16];
	double t2[3][3],t3[3][3],c[3][3],s[3][3],tmp[3][3];
	double rln,rlt,rht;
	double w2,w3,rlat,rlon,ve,vn,se,sn,ren,txx,txy,tyy;
	double d2rad = PI/180.;
	double deg2km = Re*PI/180.;
	double lonp,latp,lonc,latc;
	double cg,sg,gam,v_e,v_n;
	char input[1024];
	int dir,dim,i,iyx=0;
	int cross_mat()	;
	int cross_v() ;
	int cross3();
	void trans_ellips();

/* zero the double buffer */
	for(i=0;i<14;i++) d[i]=0.;

/* make sure usage is correct */
	if (argc != 7) {
	  fprintf (stderr,"%s\n", USAGE);
	  exit(-1); }

/* get the arguments from the command line */
	dir = atoi(argv[1]);
	if(dir == -2){
	  iyx = 1;
	  dir = -1;
	}
	if(dir != 1 && dir != -1) {
	  fprintf (stderr," dir must be 1 or -1 \n");
	  exit(-1); 
	}
	dim = atoi(argv[2]);
	if(dim < 0 && dim > 3) {
	  fprintf (stderr," dim must be 0, 1, 2, or 3 \n");
	  exit(-1); 
	}
	lonp= fmod(atof(argv[3])+360.,360.)*d2rad;
	latp= atof(argv[4])*d2rad;
	lonc= atof(argv[5]);
	latc= atof(argv[6]); 

/* compute the unit vectors for the north pole and rotation pole */
	rn[0]=0.;rn[1]=0.;rn[2]=1;
	rp[0]=cos(latp)*cos(lonp);
	rp[1]=cos(latp)*sin(lonp);
	rp[2]=sin(latp);
       
/* compute the rotation matrices */
	w2=-dir*(PI/2.-latp);
	w3=-dir*(lonp);

	t2[0][0]= cos(w2); t2[0][1]=0.      ; t2[0][2]=sin(w2);
	t2[1][0]=0.      ; t2[1][1]=1.      ; t2[1][2]=0.     ;
	t2[2][0]=-sin(w2); t2[2][1]=0.      ; t2[2][2]=cos(w2);

	t3[0][0]= cos(w3); t3[0][1]=-sin(w3); t3[0][2]=0.     ;
	t3[1][0]= sin(w3); t3[1][1]= cos(w3); t3[1][2]=0.     ;
	t3[2][0]=0.      ; t3[2][1]=0.      ; t3[2][2]=1.     ;

/* multiply the rotation matrices */

	if(dir == -1){
	   cross_mat(t3,t2,c);
	}
	else {
	   cross_mat(t2,t3,c);
	}

/* read the complete record of data  */
	while(fgets(input,sizeof(input),stdin)){

/* this is a coastline field */
	  if(dim == 0) {
	    sscanf(input," %lf %lf ",&rln,&rlt);
	    d[2]=0.;
		  
/* if iyx is set then this is an inverse transformation from yx coordinates */
		if(iyx == 1) {
			rlt = latc + rlt/deg2km;
			rln = lonc - rln/(deg2km*cos(latc*d2rad));
		}
		  
/* check for line break */
	    if(rlt > 90. || rlt < -90. || rln < -180. || rln > 360.){
	      d[0]=rln; d[1]=rlt; d[2]=0.; d[3]=0.; d[4]=0.; d[5]=0.;
	      d[6]=0.; d[7]=rln; d[8]=rlt; d[14]=0.0; d[15]=0.0;
	      printf(" %lf %lf %lf %lf %lf %lf %lf \n",d[0],d[1],d[2],d[7],d[8],d[14],d[15]);
	      continue;
	    }
	  }

/* this is a scalar field */
	  if(dim == 1) {
	    sscanf(input," %lf %lf %lf ",&rln,&rlt,&rht);
	    d[2]=rht;
/* if iyx is set then this is an inverse transformation from yx coordinates */
		if(iyx == 1) {
			rlt = latc + rlt/deg2km;
			rln = lonc - rln/(deg2km*cos(latc*d2rad));
		}
	  }

/* this is a vector field */
	  if(dim == 2) {
		sscanf(input," %lf %lf %lf %lf %lf %lf %lf ",&rln,&rlt,&ve,&vn,&se,&sn,&ren);
	    d[2]=ve; d[3]=vn; d[4]=se; d[5]=sn; d[6]=ren;
/* if iyx is set then this is an inverse transformation from yx coordinates */
		if(iyx == 1) {
			rlt = latc + rlt/deg2km;
			rln = lonc - rln/(deg2km*cos(latc*d2rad));
		}
	  }

/* this is a tensor field */
	  if(dim == 3) {
		sscanf(input," %lf %lf %lf %lf %lf ",&rln,&rlt,&txx,&txy,&tyy);
	    d[2]=txx; d[3]=txy; d[4]=tyy;
/* if iyx is set then this is an inverse transformation from yx coordinates */
		if(iyx == 1) {
			rlt = latc + rlt/deg2km;
			rln = lonc - rln/(deg2km*cos(latc*d2rad));
		}
	  }


/* everything needs this part of the code */

		d[0]=fmod(rln+360.,360);
	    d[1]=rlt;
		rlat=d[1]*d2rad;
		rlon=d[0]*d2rad;
	    rq[0]=cos(rlat)*cos(rlon);
	    rq[1]=cos(rlat)*sin(rlon);
	    rq[2]=sin(rlat);

/* transform to POD frame */
	    cross_v(c,rq,rt);

/* rotate the velocity vector and covariance matrix */
	    if(dim == 2 || dim == 3) {

/* compute all the cross products and dot product to get the rotation angle */
	      if(dir==1){
              cross3(rn,rq,rnq);
              cross3(rq,rp,rqp);
              }
              else {
              cross3(rn,rt,rnq);
              cross3(rt,rp,rqp);
              }
              cross3(rnq,rqp,rc);
              rdot=rnq[0]*rqp[0]+rnq[1]*rqp[1]+rnq[2]*rqp[2];
              rcross=sqrt(rc[0]*rc[0]+rc[1]*rc[1]+rc[2]*rc[2]);

/*  the PI - is needed to match the old trans_vec code - no clue why */
              gam=(PI-atan2(rcross,rdot));
		}

/* do the velocity rotation */
		if(dim == 2) {
			sg=sin(gam);
			cg=cos(gam);
			v_e=-(ve*cg-vn*sg);
			v_n= (ve*sg+vn*cg);
			trans_ellips(gam,&sn,&se,&ren);
	        d[9]=v_e; d[10]=v_n; d[11]=se; d[12]=sn; d[13]=ren;
		}
		
		if(dim == 3) {
                	if(dir < 0.) gam = -gam;
/* do the stress tensor rotation */
			sg=sin(gam);
			cg=cos(gam);
			
/* transpose of rotation matrix */
			t3[0][0]= cg; t3[0][1]=sg; t3[0][2]=0.  ;
			t3[1][0]= -sg; t3[1][1]= cg; t3[1][2]=0.  ;
			t3[2][0]=0. ; t3[2][1]=0. ; t3[2][2]=1.  ;

/* stress tensor */
			s[0][0]= txx; s[0][1]= txy; s[0][2]=0.   ;
			s[1][0]= txy; s[1][1]= tyy; s[1][2]=0.   ;
			s[2][0]= 0. ; s[2][1]= 0. ; s[2][2]=1.   ;

/* do the rotation t3 s t3' */
			cross_mat(s,t3,tmp);
			t3[0][1]=-sg;
			t3[1][0]= sg;
			cross_mat(t3,tmp,s);
			d[9]=s[0][0]; d[10]=s[0][1]; d[11]=s[1][1];
			
		}
		/* reconstruct the lon and lat and output */
		d[7] = fmod(atan2(rt[1],rt[0])/d2rad+360.,360.);
		d[8] = asin(rt[2])/d2rad;
		d[14] = deg2km*(lonc - d[7])*cos(latc*d2rad);
		d[15] = deg2km*(d[8] - latc);
		if(dir == -1){
			d[14] = 0.;
			d[15] = 0.;
		}
		
	    if(dim == 0 || dim == 1) printf(" %lf %lf %lf %lf %lf %lf %lf \n",d[0],d[1],d[2],d[7],d[8],d[14],d[15]);
	    if(dim == 2) printf(" %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf \n",d[0],d[1],d[2],d[3],d[4],d[5],d[6],d[7],d[8],d[9],d[10],d[11],d[12],d[13],d[14],d[15]);
		if(dim == 3) printf(" %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf \n",d[0],d[1],d[2],d[3],d[4],d[7],d[8],d[9],d[10],d[11],d[14],d[15]);
        }
	return 0;
}

/*****************************************************************/
int cross_mat(a,b,c)
double a[3][3],b[3][3],c[3][3];
{
	int i,j,k;
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
		{
			c[i][j]=0.;
			for(k=0;k<3;k++)
			{
				c[i][j]=c[i][j]+a[i][k]*b[k][j] ;
			}
		}
	}
	return 0;
}
/*****************************************************************/
int cross_v(a,v_in,v_out)
double a[3][3],v_in[3],v_out[3];
{
	int i,j;
	for(i=0;i<3;i++)
	{
		v_out[i]=0.;
		for(j=0;j<3;j++)
		{
			v_out[i]=v_out[i]+a[i][j]*v_in[j];
		}
	}
	return 0;
}
/*****************************************************************/
void trans_ellips(bqp,sig_n,sig_e,corr)
double bqp,*sig_n,*sig_e,*corr;
{
	
	float a,d,w,alfa,beta,e,f,sig_n2,sig_e2;

/* calculating required coeficients and invariants */
	sig_n2=*sig_n*(*sig_n);
	sig_e2=*sig_e*(*sig_e);
	e=2.*(*corr)*(*sig_n)*(*sig_e);
	f=sig_e2-sig_n2;
	d=sig_e2+sig_n2;
	w=sqrt(f*f+e*e);
	alfa=(asin(e/w))/2.;


/* transformation */
	beta=alfa-bqp;
	a=w*cos(2.0*beta);
	*sig_n=sqrt((d+a)/2.0);
	*sig_e=sqrt((d-a)/2.0);
	*corr=(sin(2.0*beta)*w)/((*sig_n)*(*sig_e)*2.);
}
/*****************************************************************/

/************************************************************************
* cross3 is a routine to take the cross product of 3-D vectors         *
*************************************************************************/

int cross3(a,b,c)
double *a, *b, *c;     /* input and output vectors  having 3 elements */ 
{

       c[0]= a[1]*b[2]-a[2]*b[1];
       c[1]=-a[0]*b[2]+a[2]*b[0];
       c[2]= a[0]*b[1]-a[1]*b[0];

       return 0;
}

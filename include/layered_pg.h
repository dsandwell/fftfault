
/*  set up common expressions   */

	alpha1=(l1+u1)/(l1+2*u1);
	eta1=(l1+u1)/(3*l1+4*u1);
	alpha2=(l2+u2)/(l2+2*u2);
	eta2=(l2+u2)/(3*l2+4*u2);

	m2=m*m;
	mh=m*h;
	mhs=mh*mh;

        arg2=-2.*mh;
        arg4=-4.*mh;
        ne2=0.0;
        ne4=0.0;
	if(arg2 > -50.) ne2=exp(arg2);
	if(arg4 > -50.) ne4=exp(arg4);

	Dx1=  u1*u1*(l1+u1)*(l1+u1)*(l2+3*u2)*(ne4-2*ne2*(1+2*mhs)+1)+u2*u2*(l1*l1)*(4*u1+u2+l2)*(ne4+2*ne2*(1+2*mhs)+1)+u1*u2*(u1*u2*((l2+u2)*(3*ne4+2*ne2*(5+2*mhs)+3*1)-2*u1*(3*ne4+2*ne2*(1-2*mhs)-5*1)-2*l1*(5*ne4+2*ne2*(1-4*mhs)-7*1))+4*u2*(l1*(l2+u2)*(ne4+2*ne2*(1+mhs)+1)-2*l1*l1*(ne4+ne2*(1+mhs)))-2*l2*(l1+u1)*(l1+2*u1)*(ne4-1));

	Dx2=   -u1*u1*l2*(l1+u1)*(ne4-4*mh*ne2-1)-u2*u2*l1*(l2+u2)*(ne4+4*mh*ne2-1)+u1*u2*(u1*(4*l2*(ne4+1)-3*(l1+u1)*(ne4-4*mh*ne2-1))+u2*(4*l1*(ne4-2*mh*ne2+1)-(l2+u2)*(3*ne4+4*mh*ne2-3*1))+2*u1*u2*(3*ne4-4*mh*ne2+5*1)+2*l1*l2*(ne4+1));

	denom_common=m*m*m*m*(l1+u1)*(l2+u2)/T33/((l1+2*u1)*(l1+2*u1))/((l2+2*u2)*(l2+2*u2));
	denom_old=-2*u1*m/(l1+2*u1)*Dx1;
	denom_pgW=p*g*Dx2;
	denom_new=denom_common*(denom_old+denom_pgW); 		


	A1x=   u1*u1*l2*(l1+u1)*(2*u1*mh*mh*ne2-l1*(1-ne2*(1-2*mh+2*mh*mh)))-u2*u2*l1*(l2+u2)*(l1*(1+ne2*(1-2*mh+2*mh*mh)))-u1*u2*(u1*(4*l1*l2-8*u1*u2*ne2*(1-mh*mh)+3*(l1+u1)*(l1*(1-ne2*(1-2*mh+2*mh*mh))-2*u1*mh*mh*ne2))+u2*(4*l1*l1*(1-ne2*(mh-mh*mh))+l1*(l2+u2)*(3+ne2*(3-2*mh+4*mh*mh)))+2*u1*u2*(l1*(5-2*ne2*(1+mh-2*mh*mh))+2*u1*ne2*(1-mh*mh)+(l2+u2)*ne2*(2+mh*mh))+2*l1*l1*l2); 


	*A1=1.0/denom_new*(m*m*(l2+u2)/((l1+2*u1)*(l1+2*u1))/((l2+2*u2)*(l2+2*u2)))*A1x; 
	B1x=   u1*u1*l2*(l1+u1)*(l1*(1+2*mh*(1+mh)-ne2)+2*u1*mh*mh)-u2*u2*l1*(l2+u2)*(l1*(1+2*mh*(1+mh)+ne2))+u1*u2*(6*u1*u1*u1*mh*mh+u1*(3*u1*l1*(1+2*mh*(1+2*mh)-ne2)+3*l1*l1*(1+2*mh*(1+mh)-ne2)+4*l1*l2*ne2)-u2*(l1*(l2+u2)*(3+2*mh*(1+2*mh)+3*ne2)+4*l1*l1*(mh*(1+mh)-ne2))+2*u1*u2*(2*u1*(1-mh*mh)+l1*(2-2*mh*(1+2*mh)+3*ne2)-(l2+u2)*(2+mh*mh))+2*l1*l1*l2*ne2);

		*B1=1.0/denom_new*(ne2*m*m*(l2+u2)/((l1+2*u1)*(l1+2*u1))/((l2+2*u2)*(l2+2*u2)))*B1x;

C1x=   u1*u1*l2*(l1+u1)*(1-ne2*(1-2*mh))+u2*u2*l1*(l2+u2)*(1+ne2*(1-2*mh))+u1*u2*(u1*(3*(l1+u1)*(1-ne2*(1-2*mh)))+u2*(2*l1*(2+ne2*(1-2*mh))+(l2+u2)*(3+ne2*(1-2*mh)))+2*u1*u2*(5+ne2*(1-2*mh))+2*l2*(l1+2*u1));

*C1=1.0/denom_new*(m*m*m*(l1+u1)*(l2+u2)/((l1+2*u1)*(l1+2*u1))/((l2+2*u2)*(l2+2*u2)))*C1x;

D1x=   u1*u1*l2*(l1+u1)*(1+2*mh-ne2)-u2*u2*l1*(l2+u2)*(1+2*mh+ne2)+u1*u2*(u1*(3*(l1+u1)*(1+2*mh-ne2))-u2*(2*l1*(1+2*mh-2*ne2)+(l2+u2)*(1+2*mh+3*ne2))-2*u1*u2*(1+2*mh-3*ne2)+2*l2*(l1+2*u1)*ne2);

*D1=1.0/denom_new*(ne2*m*m*m*(l1+u1)*(l2+u2)/((l1+2*u1)*(l1+2*u1))/((l2+2*u2)*(l2+2*u2)))*D1x;

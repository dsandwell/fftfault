      alpha1 = (l1+u1)/(l1+2.0*u1);
      mh = m*h;
      arg2=-2.*m*h;
      arg4=-4.*m*h;
      exp2=0.;
      exp4=0.;
      if(arg2 > -50.) exp2=exp(arg2);
      if(arg4 > -50.) exp4=exp(arg4);

      denom_common = -m*m*m*m*pow(l1+u1,2.0)/pow(l1+2.0*u1,2.0)/T33;

      D11 = exp4-2.0*exp2*(1.0+2.0*mh*mh)+1.0;
      D22 = exp4-4.0*m*h*exp2-1.0;

      denom1 = 2.0*u1*alpha1*m*D11;
      denom2 = p*g*D22;

      denom_pg = denom_common*(denom1+denom2);

      A1x = (l1+u1)*(2.0*u1*mh*mh*exp2 -l1*(1-exp2*(1-2*mh+2*mh*mh)));
      *A1 = 1/denom_pg*(m*m/pow(l1+2.0*u1,2.0))*A1x;

      B1x = (l1+u1)*(2*u1*mh*mh+l1*(1+2*mh*(1+mh)-exp2));
      *B1 = 1/denom_pg*(exp2*m*m/(pow(l1+2.0*u1,2.0)))*B1x; 

      C1x = (1-exp2*(1-2*mh));
      *C1 = 1/denom_pg*(alpha1*alpha1*m*m*m)*C1x;

      D1x = (1+2*mh-exp2);
      *D1 = 1/denom_pg*(exp2*alpha1*alpha1*m*m*m)*D1x;

      *A2=0.;
      *C2=0.;

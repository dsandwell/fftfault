% matlab program to invert coefficient matrix to obtain coeffiecients in of
% Galerkin vector for case of layered half-space under vertical load


% set up symbolic variables

syms m h l1 l2 u1 u2 alpha1 alpha2 eta1 eta2 X T33

%l2=l1;
%u2=u1;
alpha1=(l1+u1)/(l1+2*u1);
a1=alpha1;
eta1=(l1+u1)/(3*l1+4*u1);
alpha2=(l2+u2)/(l2+2*u2);
a2=alpha2;
eta2=(l2+u2)/(3*l2+4*u2);

% set up common terms in brackets

mh=m*h;
ep=exp(m*h);
en=exp(-m*h);

ia1=1/alpha1;
ie1=1/eta1;
ia2=1/alpha2;
ie2=1/eta2;

ma1=u1*alpha1;
ma2=u2*alpha2;


X=2*u1*alpha1*m*m;

Y=[1; 0; 0; 0; 0; 0;];

M=[ X*m        X*m       X*(3-ie1)             -X*(3-ie1)           0          0;
    m         -m         (2-ia1)                (2-ia1)             0          0;
    ma1*m*en  -ma1*m*ep  ma1*(2-mh-ia1)*en      ma1*(2+mh-ia1)*ep  -ma2*m*en  -ma2*(2-mh-ia2)*en;
    ma1*m*en   ma1*m*ep  ma1*(3-mh-ie1)*en     -ma1*(3+mh-ie1)*ep  -ma2*m*en  -ma2*(3-mh-ie2)*en;
    a1*m*en    a1*m*ep   a1*(1-mh)*en          -a1*(1+mh)*ep       -a2*m*en   -a2*(1-mh)*en;
    a1*m*en   -a1*m*ep   a1*(2-mh-(2*ia1))*en   a1*(2+mh-2*ia1)*ep -a2*m*en   -a2*(2-mh-(2*ia2))*en];



Z=M\Y;

simplify(Z);

A1=Z(1);
B1=Z(2);
C1=Z(3);
D1=Z(4);
A2=Z(5);
C2=Z(6);

denom=det(M)

diary coef_l.c

ccode(simplify(A1))
ccode(simplify(B1))
ccode(simplify(C1))
ccode(simplify(D1))
ccode(simplify(A2))
ccode(simplify(C2))

diary off

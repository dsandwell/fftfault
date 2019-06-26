%
%   make elements for SCEC BM7
%
x0=200;
y0=200;
r0=100;
i=0:2:359;
thet1=i*pi/180.;
thet2=(i+2)*pi/180.;
y1=y0+r0*sin(thet1);
x1=x0+r0*cos(thet1);
y2=y0+r0*sin(thet2);
x2=x0+r0*cos(thet2);
%
nt=length(x1);
sy=ones(1,nt);
su=zeros(1,nt);
so=zeros(1,nt);
ele=[x1',x2',y1',y2',sy',su',so'];
%
ele

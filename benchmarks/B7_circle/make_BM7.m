%
%   run SCEC BM7
%
%   compile maxwell with ni=nj=4096
%
%  elastic plate with fault from top to bottom - strikeslip
%
! maxwell 1.  -50. 0. -0. 99999 1 ele_BM7.dat 0 xBM7.grd yBM7.grd zBM7.grd -50. 1.e18 .25 1
%
[xm,ym,x0]=grdread2('xBM7.grd');
[xm,ym,y0]=grdread2('yBM7.grd');
[xm,ym,z0]=grdread2('zBM7.grd');
%
%  cut the relevant areas
%
x=x0(200:1400,200:1400);
y=y0(200:1400,200:1400);
z=z0(200:1400,200:1400);
r=sqrt(x.*x+y.*y);
proy=y(600,:);
proz=z(600,:);
rpro=1:1201;
rpro=(rpro-600)/4.;
%
%  generate the exact model
%
ni=length(rpro);
proym=proy;
for i=1:ni;
  if(rpro(i)/100 < 1.0025)
    proym(i)=rpro(i)/100;
  else 
    proym(i)=0;
  end
end
%
clf
orient landscape
colormap('gray');
subplot(2,3,1),imagesc(r),colorbar,title('tangential displacement'),axis image
%subplot(2,2,2),imagesc(z),colorbar,title('vertical displacement'),axis image
subplot(2,3,2),plot(rpro/100,-proy,rpro/100,proym),xlabel('r/R'),ylabel('displacement')
axis([0,1.5,-.1,1.1])
axis square
grid
subplot(2,3,3),plot(rpro/100,proym+proy),xlabel('r/R'),ylabel('error')
axis([0,1.5,-.6,.6])
axis square
grid
%subplot(2,2,4),plot(rpro,proz),xlabel('distance'),ylabel('vertical displacement')
%axis([0,300,-.01,.01])
%grid
print -depsc figure7.eps

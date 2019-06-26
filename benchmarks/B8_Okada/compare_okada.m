%
%
%
clear
%
clf
[xd,xy,U] = grdread2('U00.grd');
[xd,xy,V] = grdread2('V00.grd');
[xd,xy,W] = grdread2('W00.grd');
[xd,xy,UK] = grdread2('UOK30.grd');
[xd,xy,VK] = grdread2('VOK30.grd');
[xd,xy,WK] = grdread2('WOK30.grd');
figure(1)
orient tall
colormap('gray');
subplot(3,1,1);imagesc(flipud(UK),[-.25,.25]);colorbar;title('U Okada');axis([400,600,400,650])
axis square
subplot(3,1,2);imagesc(flipud(VK),[-.5,.5]);colorbar;title('V');axis([400,600,400,650])
axis square
subplot(3,1,3);imagesc(flipud(WK),[-.08,.08]);colorbar;title('W');axis([400,600,400,650])
axis square
print -depsc figure8a.eps
figure(2)
orient tall
colormap('gray');
subplot(3,1,1);imagesc(flipud(UK-U),[-.25,.25]);colorbar;title('U Okada-Maxwell');axis([400,600,400,650])
axis square
subplot(3,1,2);imagesc(flipud(VK-V),[-.5,.5]);colorbar;title('V');axis([400,600,400,650])
axis square
subplot(3,1,3);imagesc(flipud(WK-W),[-.08,.08]);colorbar;title('W');axis([400,600,400,650])
axis square
print -depsc figure8b.eps
%
figure(3)
orient tall
ntot=201*201;
O=reshape(UK(400:600,400:600),ntot,1);
S=reshape(U(400:600,400:600),ntot,1);
std(O)
mean(O-S)
std(O-S)/max(max(O))
%subplot(3,1,1);plot(UK,U,'k.');title('U-displacement');axis equal
subplot(3,1,1);plot(O,S,'k.');title('U-displacement'); axis equal;
axis([-.3,.3,-.3,.3]);
grid;xlabel('Okada');ylabel('Maxwell')
text(-.2,.2,'std/max = 0.0072')
O=reshape(VK(400:600,400:600),ntot,1);
S=reshape(V(400:600,400:600),ntot,1);
std(O)
mean(O-S)
std(O-S)/max(max(O))
subplot(3,1,2);plot(O,S,'k.');title('V-displacement');axis equal
axis([-.6,.6,-.6,.6]);grid;xlabel('Okada');ylabel('Maxwell')
text(-.4,.4,'std/max = 0.0327')
O=reshape(WK(400:600,400:600),ntot,1);
S=reshape(W(400:600,400:600),ntot,1);
std(O)
mean(O-S)
std(O-S)/max(max(O))
subplot(3,1,3);plot(O,S,'k.');title('W-displacement');axis equal
axis([-.1,.1,-.1,.1]);grid;xlabel('Okada');ylabel('Maxwell')
text(-.06,.06,'std/max = 0.0099')
print -depsc figure8c.eps


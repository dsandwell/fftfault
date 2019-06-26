%
%
%
clear
%
clf
[xd,xy,U] = grdread2('U.grd');
[xd,xy,V] = grdread2('V.grd');
[xd,xy,W] = grdread2('W.grd');
[xd,xy,UK] = grdread2('U_15.grd');
[xd,xy,VK] = grdread2('V_15.grd');
[xd,xy,WK] = grdread2('W_15.grd');
figure(1)
orient tall
colormap('gray');
subplot(3,1,1);imagesc(flipud(UK),[-.10,.10]);colorbar;title('U Fukahada');axis([0,600,0,600])
axis square
subplot(3,1,2);imagesc(flipud(VK),[-.15,.15]);colorbar;title('V');axis([0,600,0,600])
axis square
subplot(3,1,3);imagesc(flipud(WK),[-.10,.10]);colorbar;title('W');axis([0,600,0,600])
axis square
print -depsc figure9a.eps
figure(2)
orient tall
colormap('gray');
subplot(3,1,1);imagesc(flipud(UK-U),[-.10,.10]);colorbar;title('U Fukahata-Maxwell');axis([0,600,0,600])
axis square
subplot(3,1,2);imagesc(flipud(VK-V),[-.15,.15]);colorbar;title('V');axis([0,600,0,600])
axis square
subplot(3,1,3);imagesc(flipud(WK-W),[-.10,.10]);colorbar;title('W');axis([0,600,0,600])
axis square
print -depsc figure9b.eps
%
figure(3)
orient tall
ntot=401*401;
O=reshape(UK(100:500,100:500),ntot,1);
S=reshape(U(100:500,100:500),ntot,1);
%std(O)
%mean(O-S)
std(O-S)/max(max(O))
subplot(3,1,1);plot(O,S,'k.');title('U-displacement');axis equal;
axis([-.15,.15,-.15,.15]);grid;xlabel('Fukahata');ylabel('Maxwell')
text(-.1,.1,'std/max = 0.064')
O=reshape(VK(100:500,100:500),ntot,1);
S=reshape(V(100:500,100:500),ntot,1);
%std(O)
%mean(O-S)
std(O-S)/max(max(O))
subplot(3,1,2);plot(O,S,'k.');title('V-displacement');axis equal;
axis([-.15,.15,-.15,.15]);grid;xlabel('Fukahata');ylabel('Maxwell')
text(-.1,.1,'std/max = 0.031')
O=reshape(WK(100:500,100:500),ntot,1);
S=reshape(W(100:500,100:500),ntot,1);
%std(O)
%mean(O-S)
std(O-S)/max(max(O))
subplot(3,1,3);plot(O,S,'k.');title('W-displacement');axis equal;
axis([-.15,.15,-.15,.15]);grid;xlabel('Fukahata');ylabel('Maxwell')
text(-.1,.1,'std/max = 0.064')
print -depsc figure9c.eps


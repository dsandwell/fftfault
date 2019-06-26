%
%
%
clear
figure(1)
orient tall
%
clf
U = grdread('U00.grd');
V = grdread('V00.grd');
W = grdread('W00.grd');
subplot(3,1,1);imagesc(flipud(U),[-.25,.25]);colorbar;title('U - 00 Tm')
subplot(3,1,2);imagesc(flipud(V),[-.5,.5]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W),[-.08,.08]);colorbar;title('W')
pause
%
clf
U = grdread('U01.grd');
V = grdread('V01.grd');
W = grdread('W01.grd');
subplot(3,1,1);imagesc(flipud(U),[-.25,.25]);colorbar;title('U - 01 Tm')
subplot(3,1,2);imagesc(flipud(V),[-.5,.5]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W),[-.08,.08]);colorbar;title('W')
pause
%
clf
U = grdread('U02.grd');
V = grdread('V02.grd');
W = grdread('W02.grd');
subplot(3,1,1);imagesc(flipud(U),[-.25,.25]);colorbar;title('U - 02 Tm')
subplot(3,1,2);imagesc(flipud(V),[-.5,.5]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W),[-.08,.08]);colorbar;title('W')
pause
%
clf
U = grdread('U05.grd');
V = grdread('V05.grd');
W = grdread('W05.grd');
subplot(3,1,1);imagesc(flipud(U),[-.25,.25]);colorbar;title('U - 05 Tm')
subplot(3,1,2);imagesc(flipud(V),[-.5,.5]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W),[-.08,.08]);colorbar;title('W')
pause
%
clf
U = grdread('U10.grd');
V = grdread('V10.grd');
W = grdread('W10.grd');
subplot(3,1,1);imagesc(flipud(U),[-.25,.25]);colorbar;title('U - 10 Tm')
subplot(3,1,2);imagesc(flipud(V),[-.5,.5]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W),[-.08,.08]);colorbar;title('W')
pause
%
clf
U = grdread('Uinf.grd');
V = grdread('Vinf.grd');
W = grdread('Winf.grd');
subplot(3,1,1);imagesc(flipud(U),[-.25,.25]);colorbar;title('U - inf Tm')
subplot(3,1,2);imagesc(flipud(V),[-.5,.5]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W),[-.08,.08]);colorbar;title('W')
%

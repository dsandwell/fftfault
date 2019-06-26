%
%
%
clear
figure(1)
%
clf
U0 = grdread('U00.grd');
V0 = grdread('V00.grd');
W0 = grdread('W00.grd');
U = grdread('Uinf.grd');
V = grdread('Vinf.grd');
W = grdread('Winf.grd');
subplot(3,1,1);imagesc(flipud(U-U0),[-.1,.1]);colorbar;title('U - inf Tm')
subplot(3,1,2);imagesc(flipud(V-V0),[-.1,.1]);colorbar;title('V')
subplot(3,1,3);imagesc(flipud(W-W0),[-.1,.1]);colorbar;title('W')
figure(2)
imagesc(flipud(W-W0),[-.1,.1]);colorbar;title('W')
%

%
%   plot the velocity results
%
[xm,ym,u0]=grdread2('xm1.grd');
[xm,ym,v0]=grdread2('ym1.grd');
[xm,ym,w0]=grdread2('zm1.grd');
[xm,ym,u9]=grdread2('xm2.grd');
[xm,ym,v9]=grdread2('ym2.grd');
[xm,ym,w9]=grdread2('zm2.grd');
%
% plot all the panels
%
orient tall
subplot(2,3,1),imagesc(flipud(u0)),colorbar
axis equal
axis([700,1400,2200,3700])
colormap('gray')
subplot(2,3,2),imagesc(flipud(v0)),colorbar,title('elastic halfspace')
axis equal
axis([700,1400,2200,3700])
subplot(2,3,3),imagesc(flipud(w0)),colorbar
axis equal
axis([700,1400,2200,3700])
subplot(2,3,4),imagesc(flipud(u9)),colorbar
axis equal
axis([700,1400,2200,3700])
subplot(2,3,5),imagesc(flipud(v9)),colorbar,title('elastic plate')
axis equal
axis([700,1400,2200,3700])
subplot(2,3,6),imagesc(flipud(w9)),colorbar
axis equal
axis([700,1400,2200,3700])

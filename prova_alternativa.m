clear, clc, close all

%% dati iniziali
rri = [-1169.7791 -8344.5289 977.8062 ]';
vvi = [4.2770 -1.9310 -4.9330 ]';

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% conversioni
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, 'rad');
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% directTransfer
[at, et, i_t, OMt, omt, delta_t,delta_th, deltav1, deltav2, deltavtot] = directTransfer(rri, rrf, vvi, vvf);

%% plot
Terra_3D

plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'g')
plotOrbit(at, et, i_t, OMt, omt, 0, 2*pi, 1e-3, 'rad', 'k')

plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
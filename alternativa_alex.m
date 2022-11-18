clear, clc, close all

%% dati iniziali
rri = [1e4 2e4 1e4]';
vvi = [-2.5 -2.5 3]';

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% conversione
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, 'rad');
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% calcolo apocentri
th1 = 0;
th2 = pi;

[rr1, vv1] = par2car(ai, ei, i_i, OMi, omi, th1, 'rad');
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, th2, 'rad');

%% directTransfer
[at, et, i_t, OMt, omt, deltaV, deltaT] = directTransfer_opt(rr1, rr2, vv1, vv2);
[~, k] = min(deltaV);

%% plot
Terra_3D

plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b')
plotOrbit(at(k), et(k), i_t, OMt, omt(k), 0, 2*pi, 1e-3, 'rad', 'k')

plot3(rr1(1), rr1(2), rr1(3), 'ko');
plot3(rr2(1), rr2(2), rr2(3), 'ko');
plot3(rri(1), rri(2), rri(3), 'ro');
plot3(rrf(1), rrf(2), rrf(3), 'ro');

delta_V = deltaV(k)

delta1 = TOF(ai, ei, thi, th1);
delta2 = TOF(af, ef, th2, thf);
deltaT_tot = deltaT(k) + delta1 + delta2
deltaT_tot / 60^2
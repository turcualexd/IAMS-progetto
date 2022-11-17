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

%% conversioni
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, 'rad');
[ai, ei, i_i, OMi, omi, ~] = car2par(rri, vvi, 'rad');

%% directTransfer

% trovo dati punto di arrivo
rraf_norm = af * ( 1 + ef);
rr_arrivo = rraf_norm * rrf/norm(rrf); 

%orbita trasferimento 
[at, et, i_t, OMt, omt, delta_t, delta_th] = directTransfer(rri, rr_arrivo);
[rrt, vvt] = par2car(at, et, i_t, OMt, omt, 0, 'rad');

% mi metto su un'orbita che mi porti sull'apocentro della finale
% trovo apocentro dell'orbita finale

[rra, vva] = par2car(af,ef, i_f, OMf, omf, pi, 'rad');
[at2, et2, i_t2, OMt2, omt2, delta_t2, delta_th2] = directTransfer(rrt, rra);

%% plot
Terra_3D

quiver3(0,0,0,1,0,0, 1e4);
quiver3(0,0,0,0,1,0, 1e4);
quiver3(0,0,0,0,0,1, 1e4);

plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r') % iniziale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b') % finale
zoom
plotOrbit(at, et, i_t, OMt, omt, -delta_th, 0, 1e-3, 'rad', 'k') % inserzione T1
plotOrbit(at2, et2, i_t2, OMt2, omt2, 0, 2*pi, 1e-3, 'rad', 'g') % inserzione T2



plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
plot3(rrt(1), rrt(2), rrt(3), 'ro');
plot3(rra(1), rra(2), rra(3), 'bo');

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
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% directTransfer

% trovo dati punto di arrivo primo trasferimento
rrpf_norm = af * ( 1 - ef ) + 1e4;
rr_arrivo = rrpf_norm * rrf/norm(rrf); 

%orbita trasferimento 
[at, et, i_t, OMt, omt, delta_t, delta_th] = directTransfer(rri, rr_arrivo);
[rrt, vvt] = par2car(af, ef, i_t, OMf, omf, delta_th, 'rad');

% mi metto su un'orbita di immissione diretta sulla finale

[rr_trasf2, vv_trasf2] = par2car(at, et, i_t, OMt, omt, pi, 'rad');

[at2, et2, it2, OMt2, omt2, delta_tt2, delta_tht2,  deltav1t2, deltav2t2, deltavtott2] = directTransfer(rrt, rr_trasf2, vvt, vv_trasf2);

%% plot
Terra_3D

zoom

quiver3(0,0,0,1,0,0, 1e4);
quiver3(0,0,0,0,1,0, 1e4);
quiver3(0,0,0,0,0,1, 1e4);

% plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r') % iniziale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b') % finale

plotOrbit(at, et, i_t, OMt, omt, -delta_th, 0, 1e-3, 'rad', 'k') % inserzione punto 2
% plotOrbit(at2, et2 , it2, OMt2, omt2, 0, pi, 1e-3, 'rad', 'g') % inserzione
% 
% 
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rr_arrivo(1), rr_arrivo(2), rr_arrivo(3), 'ro');
%plot3(rrt(1), rrt(2), rrt(3), 'ro');
plot3(rrf(1), rrf(2), rrf(3), 'ko');


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
rrt1_norm = ( af * (1 - ef^2) )/(1 + ef * cos(thf + pi));
rr_arrivo1 = rrt1_norm * rrf/norm(rrf); 

%orbita trasferimento 1
[at, et, i_t, OMt, omt, delta_t1, delta_th] = directTransfer(rri, rr_arrivo1);
[tilde, vv_arrivo1] = par2car(at, et, i_t, OMt, omt, 0, 'rad');

% mi metto su un'orbita che mi porti sull'orbita finale

[at2, et2, i_t2, OMt2, omt2, delta_t2, delta_th2] = directTransfer(rr_arrivo1, -rr_arrivo1);

i_t2 = i_t;
OMt2 = OMt;
omt2 = omt;

%% calcolo delle velocità

% primo delta v
% vvi = [-2.5 -2.5 3]';
% vv_arrivo1 è velocità primo punto orbita
delta_v1_vect = vv_arrivo1 - vvi;
delta_v1 = norm(delta_v1_vect);

% secondo delta v
[tilde, vv_arrivo2] = par2car(at, et, i_t, OMt, omt, delta_th, 'rad');
[tilde, vv_arrivo3] = par2car(at2, et2, i_t2, OMt2, omt2, 0, 'rad');

delta_v2_vect = vv_arrivo3 - vv_arrivo2;
delta_v2 = norm(delta_v2_vect);

% terzo delta v

[tilde, vv_arrivo4] = par2car(at2, et2, i_t2, OMt2, omt2, pi, 'rad');
[tilde, vv_arrivo5] = par2car(af, ef, i_f, OMf, omf, pi + thf, 'rad');

delta_v3_vect = vv_arrivo5 - vv_arrivo4;
delta_v3 = norm(delta_v3_vect);

% delta v totale

delta_v_totale = delta_v1 + delta_v2 + delta_v3;

%% calcolo tempistica

delta_t_tot = delta_t1 + delta_t2 + TOF(af, ef, pi + thf , thf);
delta_t_tot_ore = delta_t_tot/3600;

%% plot

Terra_3D

quiver3(0,0,0,1,0,0, 1e4);
quiver3(0,0,0,0,1,0, 1e4);
quiver3(0,0,0,0,0,1, 1e4);

% plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r') % iniziale
plotOrbit(af, ef, i_f, OMf, omf, pi + thf, 2*pi + thf, 1e-3, 'rad', 'b') % finale

plotOrbit(at, et, i_t, OMt, omt, -delta_th, 0, 1e-3, 'rad', 'k') % inserzione T1
plotOrbit(at2, et2, i_t2, OMt2, omt2, 0, pi, 1e-3, 'rad', 'g') % inserzione T2

plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
plot3(rr_arrivo1(1), rr_arrivo1(2), rr_arrivo1(3), 'go');
plot3(-rr_arrivo1(1), -rr_arrivo1(2), -rr_arrivo1(3), 'go');



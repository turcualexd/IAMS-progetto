clear, clc , close all

%% Dati
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

%% Tangente
deltaV = 1.3;
rrt = rrf;
vvt = vvf;

[at, et, i_t, OMt, omt, tht] = tangente(rrt, vvt, deltaV);

%% Plot
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b')
plotOrbit(at, et, i_t, OMt, omt, 0, 2*pi, 0.001, 'rad', 'g')

plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');

plot3(rrt(1), rrt(2), rrt(3), 'ro');

[rr_temp, vv_temp] = par2car(at, et, i_t, OMt, omt, tht);
plot3(rr_temp(1), rr_temp(2), rr_temp(3), 'go');

%% Cambio piano
[om_cp, th_cp_vect] = changeOrbitalPlane_mod(i_f, OMf, omf, i_i, OMi);
th_cp = th_cp_vect(2);
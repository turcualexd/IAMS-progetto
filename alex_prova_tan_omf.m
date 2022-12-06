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

%% Cambio piano
[om_cp, th_cp_vect] = changeOrbitalPlane_mod(i_f, OMf, omf, i_i, OMi);
th_cp = th_cp_vect(2);

%% Tangente
deltaV = 1;

[a_cp, e_cp, i_cp, OM_cp, om_cp, thi1, thf2] = tan_omf(ai, ei, i_i, OMi, omi, om_cp, deltaV);

%% Plot
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b')
plotOrbit(a_cp, e_cp, i_cp, OM_cp, om_cp, 0, 2*pi, 0.001, 'rad', 'g')
plotOrbit(a_cp, e_cp, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'k')

plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
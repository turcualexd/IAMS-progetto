clear; clc; close all

%% dati iniziali

rr = [-1169.7791 -8344.5289 977.8062 ]';
vvf = [4.2770 -1.9310 -4.9330 ]';

[ai, ei, ii, OMi, omi, thi] = car2par(rr, vvf, 'rad');

%% dati finali

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, "rad");

%% raggiungere pericentro iniziale 

deltaT1 = TOF(ai, ei, thi, 2*pi);

%% bitangente PP fino dati orbita finale

[DeltaV1, DeltaV2, deltaT2, om_pre_cambio_piano, om_t, at, et] = bitangentTransfer(ai, ei, af, ef, 'pp', omi);

[rrpt, vvpt] = par2car(at, et, ii, OMi, om_t, 0, "rad");
[rrat, vvat] = par2car(at, et, ii, OMi, om_t, pi, "rad");

%% cambio piano

pt = 2;

[DeltaV3_vett, omcp, theta_cp_vett] = changeOrbitalPlane(af, ef, ii, OMi, om_pre_cambio_piano, i_f, OMf);

% prendo il delta v minore
DeltaV3 = DeltaV3_vett(pt);
theta_cp = theta_cp_vett(pt);

% mi sposto sull'orbita fino al cambio piano
deltaT3 = TOF(af, ef, 0, theta_cp);

[rrcp, vvcp] = par2car(af, ef, i_f, OMf, omcp, theta_cp, "rad");

%% cambio anomalia del pericentro

pt = 1;

[DeltaV4, theta_cwi_vett, theta_cwf_vett] = changePericenterArg(af, ef, omcp, omf);

theta_cwi = theta_cwi_vett(pt);
theta_cwf = theta_cwf_vett(pt);

deltaT4 = TOF(af, ef, theta_cp, theta_cwi);

[rrcw, vvcw] = par2car(af, ef, i_f, OMf, omf, theta_cwf, "rad");

%% raggiungo punto finale

deltaT5 = TOF(af, ef, theta_cwf, thf);

%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4);

deltat_tot = deltaT1 + deltaT2 + deltaT3 + deltaT4 + deltaT5; % tempo in secondi

deltat_tot_h = deltat_tot/3600; % tempo in ore

%% plot

Terra_3D

plotOrbit(ai, ei, ii, OMi, omi, thi, 0, 0.001, 'rad', 'r'); % orbita iniziale
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r--');
plotOrbit(at, et, ii, OMi, om_t, 0, pi, 0.001, 'rad', 'b'); % arco bitangente
plotOrbit(af, ef, ii, OMi, om_pre_cambio_piano, 0, theta_cp, 0.001, 'rad', 'k'); % arrivo su cambio piano
plotOrbit(af, ef, i_f, OMf, omcp, theta_cp, theta_cwi, 0.001, 'rad', 'm'); % cambio pericentro
plotOrbit(af, ef, i_f, OMf, omf, theta_cwf - 2*pi, thf, 0.001, 'rad', 'g'); % orbita finale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'g--');

plot3(rr(1), rr(2), rr(3), 'ro'); % punto iniziale
plot3(rrpt(1), rrpt(2), rrpt(3), 'r*'); % bitangente 1
plot3(rrat(1), rrat(2), rrat(3), 'b*'); % bitangente 2
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*'); % cambio piano
plot3(rrcw(1), rrcw(2), rrcw(3), 'm*'); % cambio anomalia
plot3(rrf(1), rrf(2), rrf(3), 'go'); % punto finale

legend('Earth', 'Initial Orbit', '', 'Bitangent Transfer', 'Transfer Orbit', 'Change Plane', 'Final Orbit', '', 'Initial Point', 'manuver 1', 'manuver 2', 'manuver 3', 'manuver 4', 'final point')


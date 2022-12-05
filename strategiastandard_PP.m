clear; clc; close all

%% dati iniziali
rr = [-1169.7791 -8344.5289 977.8062 ]';
vv = [4.2770 -1.9310 -4.9330 ]';
[ai, ei, ii, OMi, omi, thi] = car2par(rr, vv, 'rad');
Terra_3D
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
hold on
plot3(rr(1), rr(2), rr(3), 'ko');

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'g')
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rr2(1), rr2(2), rr2(3), 'ko');


%% raggiungere pericentro iniziale 

deltaT1 = TOF(ai, ei, thi, 2*pi);

%% bitangente PP fino a distanza apocentro finale, circolarizzazione


[DeltaV1, DeltaV2, deltaT2, omt, om_t, at, et] = bitangentTransfer(ai, ei, af, ef, 'pp', omi);

% arco bitangente
plotOrbit(at, et, ii, OMi, om_t, 0, 2*pi, 0.001, 'rad', 'b')

[rrpt, vvpt] = par2car(at, et, ii, OMi, om_t, 0, "rad");
plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
[rrat, vvat] = par2car(at, et, ii, OMi, om_t, pi, "rad");
plot3(rrat(1), rrat(2), rrat(3), 'k*');

plotOrbit(af, ef, ii, OMi, om_t, 0, 2*pi, 0.001, 'rad', 'k')

%% cambio piano

% theta_cp è punto di cambio piano
[DeltaV3, om2, theta_cp] = changeOrbitalPlane(af, ef, ii, OMi, omi, i_f, OMf);
% prendo il delta v minore
DeltaV3 = DeltaV3(2);
theta_cp = theta_cp(2);

% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltaT3 = TOF(af, ef, pi, theta_cp);

plotOrbit(af, ef, i_f, OMf, om2, 0, 2*pi, 0.001, 'rad', 'm')
[rrcp, vvcp] = par2car(af, ef, i_f, OMf, om2, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');

%% cambio anomalia del pericentro

[DeltaV4, theta_cwi, theta_cwf] = changePericenterArg(af, ef, om2, omf);
theta_cwi = theta_cwi(1);
theta_cwf = theta_cwf(1);
deltaT4 = TOF(af, ef, theta_cp, theta_cwi);

%plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'c')
[rrcw, vvcw] = par2car(af, ef, i_f, OMf, omf, theta_cwf, "rad");
plot3(rrcw(1), rrcw(2), rrcw(3), 'k*');

%% raggiungo punto finale

deltaT5 = TOF(af, ef, theta_cwf, thf);


%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4);

deltat_tot = deltaT1 + deltaT2 + deltaT3 + deltaT4 + deltaT5; %tempo in secondi

deltat_tot_h = deltat_tot/3600 %tempo in ore


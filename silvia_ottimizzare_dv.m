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

plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b')
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rr2(1), rr2(2), rr2(3), 'ko');

%% raggiungere pericentro iniziale 

deltaT1 = TOF(ai, ei, thi, 2*pi);

%% bitangente PA fino a distanza apocentro finale, circolarizzazione

rp1 = ai*(1-ei);
rp2 = rp1;
ra2 = 29100;
a2 = (rp2 + ra2)/2;
e2 = (ra2 - rp2)/(ra2 + rp2);
mu = 398600;
DeltaV1 = sqrt(2*mu*((1/rp1)-(1/(2*a2)))) - sqrt(2*mu*((1/rp1)-(1/(2*ai))));

% arco bitangente
plotOrbit(a2, e2, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')

%% raggiungo apocentro dell'orbita ellittica 2

deltaT2 = TOF(a2, e2, 0, pi);


%% terza ellittica con rp3 uguale a ra2
rp3 = ra2;
ra3 = 50000;
a3 = (rp3 + ra3)/2;
e3 = (ra3- rp3)/(ra3 + rp3);
mu = 398600;
DeltaV2 = sqrt(2*mu*((1/rp3)-(1/(2*a3)))) - sqrt(2*mu*((1/rp3)-(1/(2*a2))))

% arco bitangente
plotOrbit(a3, e3, ii, OMi, omi+pi, 0, 2*pi, 0.001, 'rad', 'r')

%% cambio piano

% theta_cp è punto di cambio piano
[DeltaV3, om3, theta_cp] = changeOrbitalPlane(a3, e3, ii, OMi, omi+pi, i_f, OMf);
% prendo il delta v minore
DeltaV3 = DeltaV3(2);
theta_cp = theta_cp(2);

% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltaT4 = TOF(a3, e3, 0, theta_cp);

plotOrbit(a3, e3, i_f, OMf, om3, 0, 2*pi, 0.001, 'rad', 'b')
[rrcp, vvcp] = par2car(a3, e3, i_f, OMf, om3, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');

%% cambio anomalia

[DeltaV4, theta_cwi, theta_cwf] = changePericenterArg(a3, e3, om3, omf+pi);
theta_cwi = theta_cwi(2);
theta_cwf = theta_cwf(2);
deltaT4 = TOF(a3, e3, theta_cp, theta_cwi);

plotOrbit(a3, e3, i_f, OMf, omf+pi, 0, 2*pi, 0.001, 'rad', 'c')
[rrcw, vvcw] = par2car(a3, e3, i_f, OMf, omf+pi, theta_cwf, "rad");
plot3(rrcw(1), rrcw(2), rrcw(3), 'k*');


%% 

rpf = af*(1-ef);
raf = af*(1+ef)
rp5 = rpf;
rp3 = a3*(1-e3);
ra5 = rp3;
a5 = (rp5 + ra5)/2;
e5 = (ra5 - rp5)/(ra5 + rp5);
plotOrbit(a5, e5, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'c')


%% trasferimento al pericentro di 5 sulla finale

DeltaV5 = sqrt(2*mu*((1/rp5)-(1/(2*af)))) - sqrt(2*mu*((1/rp5)-(1/(2*a5))))



%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4) + abs(DeltaV5) 




















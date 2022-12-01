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

%% trasferimento su ellittica con rpi ma grande

rp1 = ai*(1-ei);
rp2 = rp1;
ra2 = 29100;
a2 = (rp2 + ra2)/2;
e2 = (ra2 - rp2)/(ra2 + rp2);
mu = 398600;
DeltaV1 = sqrt(2*mu*((1/rp1)-(1/(2*a2)))) - sqrt(2*mu*((1/rp1)-(1/(2*ai))))

% arco bitangente
plotOrbit(a2, e2, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'b')

%% raggiungo apocentro dell'orbita ellittica 2

deltaT2 = TOF(a2, e2, 0, pi);

%% bitangente PA fino a distanza a scelta, circolarizzazione

r3c = 51500; 
e3c = 0; 

[DeltaV2, DeltaV3, deltaT3, om_f_new, omt3, at3, et3] = bitangentTransfer(a2, e2, r3c, e3c, 'ap', omi);

% arco bitangente
plotOrbit(at3, et3, ii, OMi, omt3, 0, pi, 0.001, 'rad', 'c')

[rrpt, vvpt] = par2car(at3, et3, ii, OMi, omt3, pi, "rad");
plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
[rrat, vvat] = par2car(at3, et3, ii, OMi, omt3, 2*pi, "rad");
plot3(rrat(1), rrat(2), rrat(3), 'k*');

plotOrbit(r3c, e3c, ii, OMi, omt3, 0, 2*pi, 0.001, 'rad', 'b')

%% cambio piano

% theta_cp è punto di cambio piano
[DeltaV4, om4, theta_cp] = changeOrbitalPlane(r3c, e3c, ii, OMi, omi, i_f, OMf);
% prendo il delta v minore
DeltaV4 = DeltaV4(1);
theta_cp = theta_cp(1);

% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltaT4 = TOF(r3c, e3c, 0, theta_cp);

plotOrbit(r3c, e3c, i_f, OMf, om4, 0, 2*pi, 0.001, 'rad', 'm')
[rrcp, vvcp] = par2car(r3c, e3c, i_f, OMf, om4, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');

%% raggiungo


%% 

rpf = af*(1-ef);
rp5 = rpf;
ra5 = 30000;
a5 = (rp5 + ra5)/2;
e5 = (ra5 - rp5)/(ra5 + rp5);
plotOrbit(a5, e5, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'm')

[DeltaV5, DeltaV6, deltaT6, om_f_new, omt5, at5, et5] = bitangentTransfer(r3c, e3c, a5, e5, 'pa', omf);


% arco bitangente
plotOrbit(at5, et5, i_f, OMf, omt5, pi, 2*pi, 0.001, 'rad', 'c')

[rrpt, vvpt] = par2car(at5, et5, i_f, OMf, omt5,0, "rad");
plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
[rrat, vvat] = par2car(at5, et5, i_f, OMf, omt5, pi, "rad");
plot3(rrat(1), rrat(2), rrat(3), 'k*');


%% trasferimento al pericentro di 5 sulla finale

DeltaV7 = sqrt(2*mu*((1/rpf)-(1/(2*af)))) - sqrt(2*mu*((1/rpf)-(1/(2*a5))))



%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4) + abs(DeltaV5) + abs(DeltaV6) + abs(DeltaV7)



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

%% bitangente PA fino a distanza apocentro finale, circolarizzazione

raf = af*(ef+1); % dev'essere uguale a rat e raggio della circolare su cui ci inseriamo
e_2 = 0; % eccentricità orbita circolare con raggio raf

[DeltaV1, DeltaV2, deltaT2, om_f_new, omt, at, et] = bitangentTransfer(ai, ei, raf, e_2, 'pa', omi);

% arco bitangente
plotOrbit(at, et, ii, OMi, omt, 0, pi, 0.001, 'rad', 'b')

[rrpt, vvpt] = par2car(at, et, ii, OMi, omt, 0, "rad");
plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
[rrat, vvat] = par2car(at, et, ii, OMi, omt, pi, "rad");
plot3(rrat(1), rrat(2), rrat(3), 'k*');

plotOrbit(raf, e_2, ii, OMi, omt, 0, 2*pi, 0.001, 'rad', 'k')

%% cambio piano

% theta_cp è punto di cambio piano
[DeltaV3, om2, theta_cp] = changeOrbitalPlane(raf, e_2, ii, OMi, omi, i_f, OMf);
% prendo il delta v minore
DeltaV3 = DeltaV3(2);
theta_cp = theta_cp(2);

% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltaT3 = TOF(raf, e_2, pi, theta_cp);

plotOrbit(raf, e_2, i_f, OMf, om2, 0, 2*pi, 0.001, 'rad', 'm')
[rrcp, vvcp] = par2car(raf, e_2, i_f, OMf, om2, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'r*');

%% raggiungo apocentro finale sulla circolare cambiata di piano

deltaT4 = TOF(raf, e_2, theta_cp, pi);

%% entro sull'orbita finale e raggiungo il punto finale
mu = 398600;
DeltaV4 = sqrt(2*mu*((1/raf)-(1/(2*af)))) - sqrt(mu/raf);

deltaT5 = TOF(af, ef, pi, thf);



%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4);

deltat_tot = deltaT1 + deltaT2 + deltaT3 + deltaT4 + deltaT5; %tempo in secondi

deltat_tot_h = deltat_tot/3600 %tempo in ore





clear, clc, close all

%% Dati
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330 ]';

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

mu = 398600;

%% Conversioni
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

%% Bitangente PA fino a distanza apocentro finale, circolarizzazione

raf = af  * (1 + ef); % dev'essere uguale a rat e raggio della circolare su cui ci inseriamo
e2 = 0; % eccentricità orbita circolare con raggio raf

[DeltaV1, DeltaV2, deltaT2, ~, omt, at, et] = bitangentTransfer(ai, ei, raf, e2, 'pa', omi);

[rrpt, vvpt] = par2car(at, et, i_i, OMi, omt, 0);
[rrat, vvat] = par2car(at, et, i_i, OMi, omt, pi);

%% Cambio piano

[deltaV3, om2, theta_cp] = changeOrbitalPlane(raf, e2, i_i, OMi, omi, i_f, OMf);

% prendo il delta v minore
deltaV3 = deltaV3(2);
theta_cp = theta_cp(2);

[rrcp, vvcp] = par2car(raf, e2, i_f, OMf, om2, theta_cp, "rad");

%% Velocità
% deltaV1 da bitangentTransfer
% deltaV2 da bitangentTransfer
% deltaV3 da changeOrbitalPlane
deltaV4 = sqrt(2*mu*((1/raf)-(1/(2*af)))) - sqrt(mu/raf);

deltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(deltaV3) + abs(deltaV4)

%% Tempo
deltaT1 = TOF(ai, ei, thi, 2*pi);
% deltaT2 da bitangentTransfer
deltaT3 = TOF(raf, e2, pi, theta_cp);
deltaT4 = TOF(raf, e2, theta_cp, pi);
deltaT5 = TOF(af, ef, pi, thf);

deltaT_tot = deltaT1 + deltaT2 + deltaT3 + deltaT4 + deltaT5; % tempo in secondi

deltaT_tot_h = deltaT_tot / 60^2 % tempo in ore

%% Plot
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, thi, 0, 0.001, 'rad', 'r')


plotOrbit(at, et, i_i, OMi, omt, 0, pi, 0.001, 'rad', 'b')                  % bitangente
plotOrbit(raf, e2, i_i, OMi, omt, pi, theta_cp, 0.001, 'rad', 'k')          % circolare
plotOrbit(raf, e2, i_f, OMf, om2, theta_cp, pi + omf - om2, 0.001, 'rad', 'm')    % cambio piano

plotOrbit(af, ef, i_f, OMf, omf, pi, thf, 0.001, 'rad', 'g')

plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');

plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
plot3(rrat(1), rrat(2), rrat(3), 'k*');
plot3(rrcp(1), rrcp(2), rrcp(3), 'r*');
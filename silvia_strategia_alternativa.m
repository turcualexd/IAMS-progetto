clear; clc; close all

%% dati iniziali
rri = [-1169.7791 -8344.5289 977.8062 ]';
vvi = [4.2770 -1.9310 -4.9330 ]';
[ai, ei, ii, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, "rad");

%% 2: changeorbitalplane, campio piano orbita
% theta_cp è punto di cambio piano
[DeltaV1, om2, theta_cp] = changeOrbitalPlane(ai, ei, ii, OMi, omi, i_f, OMf);

% prendo il delta v minore
DeltaV1 = DeltaV1(2);
theta_cp = theta_cp(2);
% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltat1 = TOF(ai, ei, thi, theta_cp);

[rrcp, vvcp] = par2car(ai, ei, i_f, OMf, om2, theta_cp, "rad");


%% trasferimento
[rrpi, vvpi] = par2car(ai, ei, i_f, OMf, om2, 0, "rad");
[rraf, vvaf] = par2car(af, ef, i_f, OMf, omf, pi, "rad");

[at, et, it, OMt, omt, deltat2, delta_th,  deltaV2, deltaV3, deltavtot_t] = directTransfer(rrcp, rrf, vvcp, vvf);

%%

deltat_tot = deltat1 + deltat2;
deltat_toth = deltat_tot/3600

deltaV_tot = abs(DeltaV1) + abs(deltaV2) + abs(deltaV3)

%% plot

% iniziale
Terra_3D
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r') %bianco per vedere
hold on
plot3(rri(1), rri(2), rri(3), 'ko'); %bianco per vedere

% cambio orbita 
plotOrbit(ai, ei, i_f, OMf, om2, 0, 2*pi, 0.001, 'rad', 'm')

[rrcp, vvcp] = par2car(ai, ei, i_f, OMf, om2, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');


% trasferimento
plotOrbit(at, et, it, OMt, omt, 0, 2*pi, 1e-3, 'rad', 'k')

% finale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'g')
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rrf(1), rrf(2), rrf(3), 'ko');









% %% apo e peri iniziali, cambio piano e finali
% 
% [rrpi, vvpi] = par2car(ai, ei, ii, OMi, omi, 0, "rad")
% plot3(rrpi(1), rrpi(2), rrpi(3), 'b*');
% [rrai, vvai] = par2car(ai, ei, ii, OMi, omi, pi, "rad")
% plot3(rrai(1), rrai(2), rrai(3), 'b*');
% 
% [rrcp1, vvcp1] = par2car(ai, ei, i_f, OMf, om2, 0, "rad");
% plot3(rrcp1(1), rrcp1(2), rrcp1(3), 'b*');
% [rrcp2, vvcp2] = par2car(ai, ei, i_f, OMf, om2, pi, "rad");
% plot3(rrcp2(1), rrcp2(2), rrcp2(3), 'b*');
% 
% [rrpf, vvpf] = par2car(af, ef, i_f, OMf, omf, 0, "rad")
% plot3(rrpf(1), rrpf(2), rrpf(3), 'b*');
% [rraf, vvaf] = par2car(af, ef, i_f, OMf, omf, pi, "rad")
% plot3(rraf(1), rraf(2), rraf(3), 'b*');

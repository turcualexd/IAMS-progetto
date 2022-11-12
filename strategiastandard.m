clear; clc;

%% dati iniziali
rr = [1e4 2e4 1e4]';
vv = [-2.5 -2.5 3]';

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% 0: car2par
[ai, ei, ii, OMi, omi, thi] = car2par(rr, vv, 'rad');

%% 1: arrivo al punto di cambio piano theta_cp

%% 2: changeorbitalplane
[DeltaV1, om2, theta_cp] = changeOrbitalPlane(ai, ei, ii, OMi, omi, i_f, OMf);

% prendo il delta v minore 
DeltaV1 = DeltaV1(2);
theta_cp = theta_cp(2);
% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltat1 = TOF(ai, ei, thi, theta_cp);

%% 3: arrivo a punto di cambio anomalia theta_cw 1 e 2

%% 4: changePericenterArg
[DeltaV2, theta_cwi, theta_cwf] = changePericenterArg(ai, ei, om2, omf);

deltat2 = TOF(ai, ei, theta_cp, theta_cwi(2));
% decidere quale theta considerare, non incide su delta v ma incide sul
% tempo e su qualcosa dopo!!!!!!
%
% in teoria ho risolto.
% ho preso il theta 2, quindi quello in alto (seconda componente dei
% vettori) e ho considerato il valore iniziale per il tempo 2 e il valore
% finale per il delta tempo 3 

%% 5: vado al pericentro theta = 0 rad
deltat3 = TOF(ai, ei, theta_cwf(2), 0);

%% 6: bitangentTransfer

% mi servono anche i dati dell'arco bitangente e non solo delle orbite
% iniziali e finali quindi:
rpt = ai * (1 - ei);
rat = af * (1 + ef);
at = (rpt + rat)/2;
et = (rat - rpt)/(rat + rpt);
[DeltaV3, DeltaV4, deltat4] = bitangentTransfer(ai, ei, af, ef, 'pa', omf);
% sto andando da theta 0 a theta pi
th6 = pi; %apocentro


%% 7: attesa fino a theta finale
deltat5 = TOF(af, ef, th6, thf);

%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4);

deltat_tot = deltat1 + deltat2 + deltat3 + deltat4 + deltat5; %tempo in secondi

deltat_tot_h = deltat_tot/3600; %tempo in ore


%% plot

Terra_3D

% iniziale
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad')
hold on
plot3(rr(1), rr(2), rr(3), 'ko');

% cambio orbita
plotOrbit(ai, ei, i_f, OMf, om2, 0, 2*pi, 0.001, 'rad')
[rrcp, vvcp] = par2car(ai, ei, i_f, OMf, om2, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');

% cambio anomalia pericentro
plotOrbit(ai, ei, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad')
[rrcw, vvcw] = par2car(ai, ei, i_f, OMf, omf, theta_cwf(2), "rad");
plot3(rrcw(1), rrcw(2), rrcw(3), 'k*');

% arco biellittico
plotOrbit(at, et, i_f, OMf, omf, 0, pi, 0.001, 'rad')
[rrpt, vvpt] = par2car(at, et, i_f, OMf, omf, 0, "rad");
plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');

[rrat, vvat] = par2car(at, et, i_f, OMf, omf, pi, "rad");
plot3(rrat(1), rrat(2), rrat(3), 'k*');

% finale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad')
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rr2(1), rr2(2), rr2(3), 'ko');

%% plottare su grafici diversi (?)

% %Terra_3D
% % 
% % iniziale
% plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad' )
% plot3(rr(1), rr(2), rr(3), 'o');
% figure
% % cambio orbita
% 
% figure
% Terra_3D
% plotOrbit(ai, ei, i_f, OMf, om2, 0, 2*pi, 0.001, 'rad')
% 
% % cambio anomalia pericentro
% figure
% Terra_3D
% plotOrbit(ai, ei, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad')
% 
% % arco biellittico
% figure
% Terra_3D
% plotOrbit(at, et, i_f, OMf, omf, 0, pi, 0.001, 'rad')
% 
% % finale
% figure
% Terra_3D
% plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad')
% 
% 
% 

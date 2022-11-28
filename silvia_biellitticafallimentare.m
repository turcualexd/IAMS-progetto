clear; clc; close all

%% dati iniziali
rr = [-1169.7791 -8344.5289 977.8062 ]';
vv = [4.2770 -1.9310 -4.9330 ]';

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% 0: car2par, trovo dati orbita iniziale
[ai, ei, ii, OMi, omi, thi] = car2par(rr, vv, 'rad');

%% 1: arrivo al punto di cambio piano theta_cp

%% 2: changeorbitalplane, campio piano orbita
% theta_cp è punto di cambio piano
[DeltaV1, om2, theta_cp] = changeOrbitalPlane(ai, ei, ii, OMi, omi, i_f, OMf);

% prendo il delta v minore
DeltaV1 = DeltaV1(2);
theta_cp = theta_cp(2);
% tempo di attesa 1: da theta iniziale a theta di cambio piano
deltat1 = TOF(ai, ei, thi, theta_cp);

%% 3: arrivo a punto di cambio anomalia theta_cw 1 e 2

%% 4: changePericenterArg, cambio argomento pericentro
[DeltaV2, theta_cwi, theta_cwf] = changePericenterArg(ai, ei, om2, omf);
theta_cwi = theta_cwi(1);
theta_cwf = theta_cwf(1);
deltat2 = TOF(ai, ei, theta_cp, theta_cwi);
% decidere quale theta considerare, non incide su delta v ma incide sul
% tempo e su qualcosa dopo!!!!!!
%
% in teoria ho risolto.
% ho preso il theta 1 quindi quello in alto (seconda componente dei
% vettori) e ho considerato il valore iniziale per il tempo 2 e il valore
% finale per il delta tempo 3 

%% 5: vado al pericentro theta = 0 rad
deltat3 = TOF(ai, ei, theta_cwf, 0);


%% biellittica

rat = 80000;
[DeltaV3, DeltaV4, DeltaV5, Deltat1, Deltat2] = biellipticTransfer(ai, ei, af, ef, rat);

% t1
rpt1 = ai * (1 - ei);
rat1 = rat;
at1 = (rpt1 + rat1)/2;
et1 = (rat1 - rpt1)/(rat1 + rpt1);

% t2
rat2 = rat1;
rpt2 = af * (1 - ef);
at2 = (rat2 + rpt2)/2;
et2 = (rat2 - rpt2)/(rat2 + rpt2);

%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4) + abs(DeltaV5);


%% plot

% iniziale
Terra_3D
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
hold on

plot3(rr(1), rr(2), rr(3), 'ko');

% cambio orbita 
plotOrbit(ai, ei, i_f, OMf, om2, 0, 2*pi, 0.001, 'rad', 'm')

[rrcp, vvcp] = par2car(ai, ei, i_f, OMf, om2, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');

% cambio anomalia pericentro
plotOrbit(ai, ei, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'c')

[rrcw, vvcw] = par2car(ai, ei, i_f, OMf, omf, theta_cwf, "rad");
plot3(rrcw(1), rrcw(2), rrcw(3), 'k*');

% arco biellittico
plotOrbit(at1, et1, i_f, OMf, omf, 0, pi, 0.001, 'rad', 'b')
plotOrbit(at2, et2, i_f, OMf, omf, pi, 2*pi, 0.001, 'rad', 'k')

% [rrpt, vvpt] = par2car(at, et, i_f, OMf, om_t, pi, "rad");
% plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
% [rrat, vvat] = par2car(at, et, i_f, OMf, om_t, 2*pi, "rad");
% plot3(rrat(1), rrat(2), rrat(3), 'k*');


% finale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'g')

[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rr2(1), rr2(2), rr2(3), 'ko');
hold off




%% altra biellittica senza cambio piano

% clear; clc; close all
% 
% %% dati iniziali
% rr = [-1169.7791 -8344.5289 977.8062 ]';
% vv = [4.2770 -1.9310 -4.9330 ]';
% [ai, ei, ii, OMi, omi, thi] = car2par(rr, vv, 'rad');
% Terra_3D
% plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
% hold on
% plot3(rr(1), rr(2), rr(3), 'ko');
% 
% %% dati finali
% af = 10860;
% ef = 0.2332;
% i_f = 0.5284;
% OMf = 3.0230;
% omf = 0.4299;
% thf = 0.3316;
% 
% plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'g')
% [rr2, vv2] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
% plot3(rr2(1), rr2(2), rr2(3), 'ko');
% 
% 
% %% raggiungere pericentro iniziale 
% 
% deltaT1 = TOF(ai, ei, thi, 2*pi);
% 
% %% 
% 
% %% biellittica
% 
% rat = 50000;
% [DeltaV1, DeltaV2, DeltaV3, DeltaT2, DeltaT3] = biellipticTransfer(ai, ei, af, ef, rat);
% 
% % t1
% rpt1 = ai * (1 - ei);
% rat1 = rat;
% at1 = (rpt1 + rat1)/2;
% et1 = (rat1 - rpt1)/(rat1 + rpt1);
% 
% % t2
% rat2 = rat1;
% rpt2 = af * (1 - ef);
% at2 = (rat2 + rpt2)/2;
% et2 = (rat2 - rpt2)/(rat2 + rpt2);
% 
% % arco biellittico
% plotOrbit(at1, et1, ii, OMi, omi, 0, pi, 0.001, 'rad', 'b')
% plotOrbit(at2, et2, ii, OMi, omi, pi, 2*pi, 0.001, 'rad', 'k')

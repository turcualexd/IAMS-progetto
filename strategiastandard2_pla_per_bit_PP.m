clear; clc;

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


%% 5: vado al pericentro theta = 0 rad
deltat3 = TOF(ai, ei, theta_cwf, 0);

%% 6: bitangentTransfer

[DeltaV3, DeltaV4, deltat4, om_f_new, om_t, at, et] = bitangentTransfer(ai, ei, af, ef, 'pp', omf);


%% plot

% iniziale
Terra_3D
plotOrbit(ai, ei, ii, OMi, omi, thi, theta_cp, 0.001, 'rad', 'r');

% cambio piano
plotOrbit(ai, ei, i_f, OMf, om2, theta_cp, theta_cwi, 0.001, 'rad', 'm'); 

% cambio anomalia pericentro
plotOrbit(ai, ei, i_f, OMf, omf, theta_cwf, 0, 0.001, 'rad', 'c');

% arco bitangente
plotOrbit(at, et, i_f, OMf, om_t, 0, pi, 0.001, 'rad', 'g'); 

% orbita finale
plotOrbit(af, ef, i_f, OMf, omf, 0, thf, 0.001, 'rad', 'b'); 



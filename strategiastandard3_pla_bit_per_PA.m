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

%% 3: arrivo a pericentro

deltat2 = TOF(ai, ei, theta_cp, 0);

%% 4: bitangentTransfer PA

[DeltaV2, DeltaV3, deltat3, om_f_new, om_t, at, et] = bitangentTransfer(ai, ei, af, ef, 'pa', om2);


%% 5: changePericenterArg, cambio argomento pericentro

[DeltaV4, theta_cwi, theta_cwf] = changePericenterArg(af, ef, om2, omf);
theta_cwi = theta_cwi(1);
theta_cwf = theta_cwf(1);
deltat4 = TOF(ai, ei, pi, theta_cwi);


%% 6: 
deltat5 = TOF(ai, ei, theta_cwf, thf);

%% velocità totali e tempi totali

DeltaV_tot = abs(DeltaV1) + abs(DeltaV2) + abs(DeltaV3) + abs(DeltaV4);
 
deltat_tot = deltat1 + deltat2 + deltat3 + deltat4 + deltat5; %tempo in secondi
 
deltat_tot_h = deltat_tot/3600; %tempo in ore
 

%% plot

% iniziale
Terra_3D
plotOrbit(ai, ei, ii, OMi, omi, thi, theta_cp, 0.001, 'rad', 'r');

% cambio piano
plotOrbit(ai, ei, i_f, OMf, om2, theta_cp, 2*pi, 0.001, 'rad', 'm'); 

% arco bitangente
plotOrbit(at, et, i_f, OMf, om_t, 0, pi, 0.001, 'rad', 'c');

% cambio anomalia pericentro
plotOrbit(af, ef, i_f, OMf, om2, pi, theta_cwi, 0.001, 'rad', 'g'); 

% orbita finale
plotOrbit(af, ef, i_f, OMf, omf, theta_cwf, thf, 0.001, 'rad', 'b'); 

plotOrbit_leggero(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r--')
plotOrbit_leggero(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b--')

% intersezioni
plot3(rr(1), rr(2), rr(3), 'ko');

[rrcp, vvcp] = par2car(ai, ei, i_f, OMf, om2, theta_cp, "rad");
plot3(rrcp(1), rrcp(2), rrcp(3), 'k*');

[rrpt, vvpt] = par2car(at, et, i_f, OMf, om_t, 0, "rad");
plot3(rrpt(1), rrpt(2), rrpt(3), 'k*');
[rrat, vvat] = par2car(at, et, i_f, OMf, om_t, pi, "rad");
plot3(rrat(1), rrat(2), rrat(3), 'k*');

[rrcw, vvcw] = par2car(af, ef, i_f, OMf, omf, theta_cwf, "rad");
plot3(rrcw(1), rrcw(2), rrcw(3), 'k*');


[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rrf(1), rrf(2), rrf(3), 'ko');

hold off


% legenda
legend('', ...
        'Initial Orbit', ...   %r
        'Change Plane Orbit',...    %m
        'Bitangent Orbit', ...   %c
        'Change Pericenter Argument Orbit', ...  % g
        'Final Orbit', ...   %b
        '',...
        '',...
        'Initial and Final Point', ...  %ko
        'Maneuver Points', fontsize = 15)   %k*
clear, clc, close all

%% Dati iniziali
rri = [1e4 2e4 1e4]';
vvi = [-2.5 -2.5 3]';

%% Dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% Conversioni
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, 'rad');
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% Utilizzo directTransfer_opt per trovare tutte le orbite possibili
[at, et, i_t, OMt, omt, deltaV, deltaT, th1, th2] = directTransfer_opt(rri, rrf, vvi, vvf);

%% Caratterizzo orbita con deltaV minore
[~, kv] = min(deltaV);
deltaV_minV = deltaV(kv)
deltaT_minV = deltaT(kv)

% plotto orbita
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b')
plotOrbit(at(kv), et(kv), i_t, OMt, omt(kv), 0, 2*pi, 1e-3, 'rad', 'green')
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
title('Orbita per minimizzare \DeltaV')
legend('', 'Orbita iniziale', 'Orbita finale', 'Orbita di trasferimento', 'Punti iniziale e finale')

%% Caratterizzo orbita con deltaT minore
[~, kt] = min(deltaT);
deltaV_minT = deltaV(kt)
deltaT_minT = deltaT(kt)

% plotto orbita
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b')
plotOrbit(at(kt), et(kt), i_t, OMt, omt(kt), th1(kt), th2(kt), 1e-3, 'rad', 'green')
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
title('Orbita per minimizzare \DeltaT')
legend('', 'Orbita iniziale', 'Orbita finale', 'Orbita di trasferimento', 'Punti iniziale e finale')
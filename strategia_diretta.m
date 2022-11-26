clear, clc, close all

%% Dati iniziali
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

%% Dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% Conversioni
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);

[rri, vvi] = par2car(ai, ei, i_i, OMi, omi, thi);

%% Utilizzo directTransfer_opt per trovare tutte le orbite possibili
[at, et, i_t, OMt, omt, deltaV, deltaT, th1, th2] = directTransfer_opt(rri, rrf, vvi, vvf, 100, 5, 1e-4);

%% Caratterizzo orbita con deltaV minore
[~, k] = min(deltaV);
deltaV_min = deltaV(k)
deltaT_min = deltaT(k) / 60

th1_min = th1(k);
th2_min = th2(k);
if th1_min > th2_min
    th1_min = th1_min - 2*pi;
end

% plotto orbita
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b')
plotOrbit(at(k), et(k), i_t, OMt, omt(k), th1_min, th2_min, 1e-3, 'rad', 'green')
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
title('Orbita per minimizzare \DeltaV')
legend('', 'Orbita iniziale', 'Orbita finale', 'Orbita di trasferimento', 'Punti iniziale e finale')
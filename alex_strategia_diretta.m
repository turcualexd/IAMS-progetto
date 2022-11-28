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

%% Utilizzo secante_ottimale con punti di manovra coincidenti a punti iniziale e finale
[at, et, i_t, OMt, omt, th1_trasf, th2_trasf, th1_iniziale, th2_finale, deltaV_tot, deltaT_tot, rr1, rr2] = secante_ottimale(rri, vvi, rrf, vvf, thi, thf, true);

deltaV_tot
deltaT_tot_h = deltaT_tot / 60^2
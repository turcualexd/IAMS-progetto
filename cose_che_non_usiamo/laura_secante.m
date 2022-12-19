clear, clc, close all

%% Dati iniziali
rri = [-6294.9615 4615.4673 5295.5566]';
vvi = [-4.6440 -4.7640 -0.3764]';

%% Dati finali
af = 15920;
ef = 0.2353;
i_f = 1.2240;
OMf = 1.1530;
omf = 1.7330;
thf = 2.3420;

%% Conversioni
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

%% Utilizzo secante ottimale con partenza coincidente al punto iniziale
[at, et, i_t, OMt, omt, th1_trasf, th2_trasf, th1_iniziale, th2_finale, deltaV_tot, deltaT_tot, rr1, rr2] = secante_ottimale(rri, vvi, rrf, vvf, nan, nan, true);

deltaV_tot
deltaT_tot
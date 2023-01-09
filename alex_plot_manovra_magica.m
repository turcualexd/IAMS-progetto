clear, clc, close all;
load("alex_manovra_magica_workspace.mat")

Terra_3D

% Orbita iniziale
plotOrbit_leggero(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r--');

% Orbita di trasferimento
plotOrbit(at, et, i_t, OMt, omt, th1_trasf, th2_trasf, 0.001, 'rad', 'g');
plotOrbit_leggero(at, et, i_t, OMt, omt, th2_trasf, th1_trasf, 0.001, 'rad', 'g--');

% Orbita finale
plotOrbit(af, ef, i_f, OMf, omf, th2_finale, thf, 0.001, 'rad', 'b');
plotOrbit_leggero(af, ef, i_f, OMf, omf, thf, th2_finale, 0.001, 'rad', 'b--');

% Punto iniziale
plot3(rri(1), rri(2), rri(3), 'ks', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='r')

% Punto di manovra 1 (coincide con punto iniziale)
% plot3(rr1(1), rr1(2), rr1(3), 'ko', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='g')

% Punto di manovra 2
plot3(rr2(1), rr2(2), rr2(3), 'ko', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='b')

% Punto finale
plot3(rrf(1), rrf(2), rrf(3), 'ks', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='b')

% Legenda
legend('',...
        'Initial Orbit', ...
        'Transfer Orbit', '', ...
        'Final Orbit', ...
         fontsize=15)
clear, clc, close all;
load('alex_strategia_tangente_workspace.mat')

Terra_3D

% Orbita iniziale
plotOrbit_leggero(a_i, e_i, i_i, OM_i, om_i, th_i, th_i_tan_1, 0.001, 'rad', 'r--');
%plotOrbit_leggero(a_i, e_i, i_i, OM_i, om_i, th_i_tan_1, th_i, 0.001, 'rad', 'r--');

% Orbita tangente
plotOrbit_leggero(a_tan, e_tan, i_tan, OM_tan, om_tan, th_i_tan_2, th_tan_cp, 0.001, 'rad', 'm--');
%plotOrbit_leggero(a_tan, e_tan, i_tan, OM_tan, om_tan, th_tan_cp, th_i_tan_2, 0.001, 'rad', 'm--');

% Orbita di cambio piano
plotOrbit(a_cp, e_cp, i_cp, OM_cp, om_cp, th_tan_cp, th_cp_bit, 0.001, 'rad', 'c');
%plotOrbit_leggero(a_cp, e_cp, i_cp, OM_cp, om_cp, th_cp_bit, th_tan_cp, 0.001, 'rad', 'c--');

% Orbita bitangente
plotOrbit_leggero(a_bit, e_bit, i_bit, OM_bit, om_bit, th_cp_bit, th_bit_f, 0.001, 'rad', 'g--');
%plotOrbit_leggero(a_bit, e_bit, i_bit, OM_bit, om_bit, th_bit_f, th_cp_bit, 0.001, 'rad', 'g--');

% Orbita finale
plotOrbit_leggero(a_f, e_f, i_f, OM_f, om_f, th_bit_f, th_f, 0.001, 'rad', 'b--');
%plotOrbit_leggero(a_f, e_f, i_f, OM_f, om_f, th_f, th_bit_f, 0.001, 'rad', 'b--');

% Punto iniziale
%plot3(rr_i(1), rr_i(2), rr_i(3), 'ks', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='r')

% Punto di manovra i_tan
%plot3(rr_i_tan(1), rr_i_tan(2), rr_i_tan(3), 'ko', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='m')

% Punto di manovra tan_cp
plot3(rr_tan_cp(1), rr_tan_cp(2), rr_tan_cp(3), 'ko', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='c')

% Punto di manovra cp_bit
%plot3(rr_cp_bit(1), rr_cp_bit(2), rr_cp_bit(3), 'ko', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='g')

% Punto di manovra bit_f
%plot3(rr_bit_f(1), rr_bit_f(2), rr_bit_f(3), 'ko', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='b')

% Punto finale
%plot3(rr_f(1), rr_f(2), rr_f(3), 'ks', MarkerSize=10, MarkerEdgeColor='k', MarkerFaceColor='b')

% Legenda
legend('',...
        'Initial Orbit', ...
        'Tangent Orbit', ...
        'Change Plane Orbit', ...
        'Bitangent Orbit', ...
        'Final Orbit', ...
         fontsize=15)
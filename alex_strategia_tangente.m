clear, clc, close all

%% Notazione utilizzata

% th_tan_cp_1_vect = 'theta di intersezione tra orbita tangente e orbita di
%                     cambio piano, nel riferimento della prima (quella
%                     tangente)'    N.B.: se non c'è il numero il
%                                         riferimento è indifferente
%                     'vect' vuol dire vettore

% ----------------------------------------------------------------------------------------------
% Manovra: i (iniziale) -> tan (tangente) -> cp (cambio piano) -> bit (bitangente) -> f (finale)
% ----------------------------------------------------------------------------------------------

%% Dati iniziali
rr_i = [-1169.7791 -8344.5289 977.8062]';
vv_i = [4.2770 -1.9310 -4.9330]';

a_f = 10860;
e_f = 0.2332;
i_f = 0.5284;
OM_f = 3.0230;
om_f = 0.4299;
th_f = 0.3316;

[a_i, e_i, i_i, OM_i, om_i, th_i] = car2par(rr_i, vv_i);
[rr_f, vv_f] = par2car(a_f, e_f, i_f, OM_f, om_f, th_f);

%% Trovo om per l'orbita tangente in modo che l'orbita di cambio piano risulti allineata a quella finale
[om_tan, th_tan_cp_vect] = changeOrbitalPlane_mod(i_f, OM_f, om_f, i_i, OM_i);
th_tan_cp = th_tan_cp_vect(2);

%% Orbita tangente (a partire dal deltaV iniziale e om assegnato)
deltaV_i_tan = 0.6212;
i_tan = i_i;
OM_tan = OM_i;
[a_tan, e_tan, th_i_tan_1, th_i_tan_2] = tan_omf_opt(a_i, e_i, om_i, om_tan, deltaV_i_tan);

%% Orbita di cambio piano
a_cp = a_tan;
e_cp = e_tan;
i_cp = i_f;
OM_cp = OM_f;
om_cp = om_f;
deltaV_tan_cp_vect = changeOrbitalPlane(a_tan, e_tan, i_tan, OM_tan, om_tan, i_cp, OM_cp);
deltaV_tan_cp = deltaV_tan_cp_vect(2);

%% Orbita bitangente
i_bit = i_cp;
OM_bit = OM_cp;
th_cp_bit = pi;
th_bit_f = 0;
[deltaV_cp_bit, deltaV_bit_f, ~, ~, om_bit, a_bit, e_bit] = bitangentTransfer(a_cp, e_cp, a_f, e_f, 'ap', om_cp);

%% Costo complessivo
deltaV_tot = abs(deltaV_i_tan) + abs(deltaV_tan_cp) + abs(deltaV_cp_bit) + abs(deltaV_bit_f)

%% Tempo complessivo
T1 = TOF(a_i, e_i, th_i, th_i_tan_1);
T2 = TOF(a_tan, e_tan, th_i_tan_2, th_tan_cp);
T3 = TOF(a_cp, e_cp, th_tan_cp, th_cp_bit);
T4 = TOF(a_bit, e_bit, th_cp_bit, th_bit_f);
T5 = TOF(a_f, e_f, th_bit_f, th_f);
T_tot = T1 + T2 + T3 + T4 + T5

%% Plot
Terra_3D

% orbita iniziale
plotOrbit(a_i, e_i, i_i, OM_i, om_i, th_i, th_i_tan_1, 0.001, 'rad', 'r');

% orbita tangente
plotOrbit(a_tan, e_tan, i_tan, OM_tan, om_tan, th_i_tan_2, th_tan_cp, 0.001, 'rad', 'g');

% orbita cambio piano
plotOrbit(a_cp, e_cp, i_cp, OM_cp, om_cp, th_tan_cp, th_cp_bit, 0.001, 'rad', 'k');

% orbita bitangente
plotOrbit(a_bit, e_bit, i_bit, OM_bit, om_bit, th_cp_bit, th_bit_f, 0.001, 'rad', 'c');

% orbita finale
plotOrbit(a_f, e_f, i_f, OM_f, om_f, th_bit_f, th_f, 0.001, 'rad', 'b');

% punto iniziale
plot3(rr_i(1), rr_i(2), rr_i(3), 'ro');

% intersezione iniziale - tangente
rr_i_tan = par2car(a_i, e_i, i_i, OM_i, om_i, th_i_tan_1);
plot3(rr_i_tan(1), rr_i_tan(2), rr_i_tan(3), 'ko');

% intersezione tangente - cambio piano
rr_tan_cp = par2car(a_tan, e_tan, i_tan, OM_tan, om_tan, th_tan_cp);
plot3(rr_tan_cp(1), rr_tan_cp(2), rr_tan_cp(3), 'ko');

% intersezione cambio piano - bitangente
rr_cp_bit = par2car(a_cp, e_cp, i_cp, OM_cp, om_cp, th_cp_bit);
plot3(rr_cp_bit(1), rr_cp_bit(2), rr_cp_bit(3), 'ko');

% intersezione bitangente - finale
rr_bit_f = par2car(a_bit, e_bit, i_bit, OM_bit, om_bit, th_bit_f);
plot3(rr_bit_f(1), rr_bit_f(2), rr_bit_f(3), 'ko');

% punto finale
plot3(rr_f(1), rr_f(2), rr_f(3), 'ro');

% titolo
title(sprintf('\\DeltaV = %g km/s   -   \\DeltaT = %g h', deltaV_tot, T_tot/60^2))

% legenda
legend('', ...
        'Orbita iniziale', ...
        'Orbita tangente', ...
        'Orbita cambio piano', ...
        'Orbita bitangente', ...
        'Orbita finale', ...
        'Punti iniziale e finale', ...
        'Punti di intersezione')

%% Animated plot
Terra_3D

% orbita iniziale
plotOrbit_anime(a_i, e_i, i_i, OM_i, om_i, th_i, th_i_tan_1, 'r');

% orbita tangente
plotOrbit_anime(a_tan, e_tan, i_tan, OM_tan, om_tan, th_i_tan_2, th_tan_cp, 'g');

% orbita cambio piano
plotOrbit_anime(a_cp, e_cp, i_cp, OM_cp, om_cp, th_tan_cp, th_cp_bit, 'k');

% orbita bitangente
plotOrbit_anime(a_bit, e_bit, i_bit, OM_bit, om_bit, th_cp_bit, th_bit_f, 'c');

% orbita finale
plotOrbit_anime(a_f, e_f, i_f, OM_f, om_f, th_bit_f, th_f, 'b');
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
n = 300;
deltaV_i_tan_vect = linspace(0, 2.6, n);
deltaV_tot_vect = nan(1, n);

w = waitbar(0, 'Calcolando le velocità... (0%)', Name='Plottando il grafico');

for k = 1 : n

    x = k / n;
    waitbar(x, w, sprintf('Calcolando le velocità... (%g%%)', x * 100));

    deltaV_i_tan = deltaV_i_tan_vect(k);
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
    deltaV_tot_vect(k) = abs(deltaV_i_tan) + abs(deltaV_tan_cp) + abs(deltaV_cp_bit) + abs(deltaV_bit_f);

end

close(w);

plot(deltaV_i_tan_vect, deltaV_tot_vect)

[deltaV_tot_min, kmin] = min(deltaV_tot_vect);
deltaV_i_tan_vect(kmin)

title('Costo totale della strategia')
xlabel('\Deltav_{tangente}')
ylabel('\Deltav_{totale}')
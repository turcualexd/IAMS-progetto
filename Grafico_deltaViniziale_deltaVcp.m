clear, clc, close all

%% Dati iniziali
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);

%% Trovo om per l'orbita tangente in modo che l'orbita di cambio piano risulti allineata a quella finale
[om_tan, th_tan_cp_vect] = changeOrbitalPlane_mod(i_f, OMf, omf, i_i, OMi);
th_tan_cp = th_tan_cp_vect(2);

%% Orbita tangente (a partire dal deltaV iniziale e om assegnato)
n = 1000;
deltaV_i_vect = linspace(0, 2.6, n);
deltaV_cp_vect = nan(1, n);

w = waitbar(0, 'Calcolando le velocità... (0%)', Name='Plottando il grafico');

for k = 1 : n

    x = k / n;
    waitbar(x, w, sprintf('Calcolando le velocità... (%g%%)', x * 100));

    deltaV_i = deltaV_i_vect(k);
    [a_tan, e_tan] = tan_omf_opt(ai, ei, omi, om_tan, deltaV_i);
    
    %% Orbita di cambio piano
    deltaV_tan_cp_vect = changeOrbitalPlane(a_tan, e_tan, i_i, OMi, om_tan, i_f, OMf);
    deltaV_cp_vect(k) = deltaV_tan_cp_vect(2);

end

close(w);

plot(deltaV_i_vect, deltaV_cp_vect, 'LineWidth', 3)
grid on
set(gca, 'FontSize', 25, 'GridAlpha', 0.5)
xlabel('\Deltav_{tan} [km/s]', 'FontSize', 30)
ylabel('\Deltav_{cp} [km/s]', 'FontSize', 30)
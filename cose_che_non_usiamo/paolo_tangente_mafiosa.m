clear, clc, close all

%% Parametri
n1 = 1000;
n2 = 1000;

%% Dati
mu = 398600;
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

%% Definisco vettori utilizzati
at = nan(1, n1);
et = nan(1, n1);
omt = nan(1, n1);
tht = nan(1, n1);
deltaV_cp = nan(1, n1);
om_cp = nan(1, n1);
th_cp = nan(1, n1);
thv = linspace(0, 2*pi, n1);

%% Trovo vettore di deltaV totali minimi per i possibili deltaV iniziali
vel_fuga = sqrt(2 * mu / (ai * (1 - ei))) - sqrt(mu / ai * (1 + ei) / (1 - ei));    % non è velocità di fuga, ma il deltaV da fornire al pericentro dell'orbita iniziale per andare in fuga
deltaV_vect = linspace(0, vel_fuga, n2);
deltaV_min_vect = nan(1, n2);

for j = 1 : n2
    
    deltaV = deltaV_vect(j);
   
    for k = 1 : n1
        th_manovra = thv(k);                                        % angolo dell'orbita iniziale in cui compio la manovra tangente
        [rrt, vvt] = par2car(ai, ei, i_i, OMi, omi, th_manovra);    % ottengo posizione e velocità nel punto di manovra
        vvt = vvt * (1 + deltaV / norm(vvt));                       % aumento la velocità in maniera tangente di deltaV
        [at(k), et(k), ~, ~, omt(k), tht(k)] = car2par(rrt, vvt);   % ottengo informazioni sull'orbita tangente ottenuta
        
        [v_temp, om_cp(k), th_temp] = changeOrbitalPlane(at(k), et(k), i_i, OMi, omt(k), i_f, OMf); % effettuo il cambio piano
        [deltaV_cp(k), k2] = min(v_temp);     % ottengo informazioni su costo, om e theta di arrivo
        th_cp(k) = th_temp(k2);
    end
    deltaV_min_vect(j) = min(deltaV_cp) + deltaV;
end

%% Trovo informazioni sulla manovra scelta attraverso il vettore di deltaV trovato precedentemente
[vmin, kmin] = min(deltaV_min_vect);

deltaV_min = deltaV_vect(kmin);
deltaV_min = deltaV;
for k = 1 : n1
    th_manovra = thv(k);                                        % angolo dell'orbita iniziale in cui compio la manovra tangente
    [rrt, vvt] = par2car(ai, ei, i_i, OMi, omi, th_manovra);    % ottengo posizione e velocità nel punto di manovra
    vvt = vvt * (1 + deltaV_min / norm(vvt));                   % aumento la velocità in maniera tangente di deltaV
    [at(k), et(k), ~, ~, omt(k), tht(k)] = car2par(rrt, vvt);   % ottengo informazioni sull'orbita tangente ottenuta
    
    [v_temp, om_cp(k), th_temp] = changeOrbitalPlane(at(k), et(k), i_i, OMi, omt(k), i_f, OMf); % effettuo il cambio piano
    [deltaV_cp(k), k2] = min(v_temp);     % ottengo informazioni su costo, om e theta di arrivo
    th_cp(k) = th_temp(k2);
end

[vel_min_cp, k_temp] = min(deltaV_cp);

delta_v_sofar = vel_min_cp + vmin; % 3.2457

%% cerco dati orbita circolare di raggio apocentro finale

rc = af * ( 1 + ef );
ec = 0;
omc = omf;
OMc = OMf;
[rr_pc, vv_pc] = par2car(rc, ec, i_f, OMc, omc, pi); % dati punto di arrivo

[DeltaV1, DeltaV2, Deltat, om_f_new, om_t, a_t, e_t] = bitangentTransfer(at(k_temp), et(k_temp), rc, ec, 'pa', omt(k_temp));

delta_v_spfar = delta_v_sofar + abs(DeltaV1) + abs(DeltaV2); %5.3928 ap / 5.9 pa

[rr_pf, vv_pf] = par2car(af, ef, i_f, OMf, omf, pi);

norm(vv_pc - vv_pf) % 0.7645

%% Plotto orbite

% Dati iniziali
Terra_3D

plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b')
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
zoom
% Orbite tangenti e di cambio piano
plotOrbit(at(k_temp), et(k_temp), i_i, OMi, omt(k_temp), 0*pi/2, 5/2 *pi, 1e-3, 'rad', 'g') % tg
plotOrbit(at(k_temp), et(k_temp), i_f, OMf, om_cp(k_temp), 0*pi/2, 5/2 *pi, 1e-3, 'rad', 'r') % cambio piano
plotOrbit(rc, ec, i_f, OMc, omc, 0, 2*pi, 1e-3, 'rad', 'm') % circolare
plotOrbit(a_t, e_t, i_f, OMf, om_cp(k_temp), 0, 2*pi, 1e-3, 'rad', 'k') % bit

legend('', 'orbita iniziale', 'orbita finale', 'punto iniziale', 'punto finale', 'orbita tg', 'cambio piano', 'orbita circolare', 'orbita bitan')
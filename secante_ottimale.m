function [at, et, i_t, OMt, omt, th1_trasf, th2_trasf, th1_iniziale, th2_finale, deltaV_tot, deltaT_tot, rr1, rr2] = secante_ottimale(rri, vvi, rrf, vvf, th1_fixed, th2_fixed, plot, risol_angolare, dim_dt, it_dt, toll_dt)

%
% Dati posizioni e velocità iniziali (ed eventualmente punti di manovra
% assegnati, tolleranze, iterazioni), restituisce informazioni sull'orbita
% secante che minimizza al massimo il deltaV complessivo, tra cui parametri
% orbitali, un plot, le posizioni e gli angoli dei punti di manovra nei
% vari riferimenti, il deltaV e il deltaT totali per arrivare da punto
% iniziale a punto finale.
%
% [at, et, i_t, OMt, omt, th1_trasf, th2_trasf, th1_iniziale, th2_finale,
% deltaV_tot, deltaT_tot, rr1, rr2] = secante_ottimale(rri, vvi, rrf, vvf,
% th1_fixed, th2_fixed, plot, risol_angolare, dim_dt, it_dt, toll_dt)
%
% ----------------------------------------------------------------------------------------
% Input:
%
% rri                       vettore posizione iniziale                      [km]
%
% vvi                       vettore velocità iniziale                       [km/s]
%
% rrf                       vettore posizione finale                        [km]
%
% vvf                       vettore velocità finale                         [km/s]
%
% th1_fixed (opz.)          angolo del punto di inizio manovra nel          [rad]
%                           riferimento dell'orbita iniziale
%                           (default = nan, porre uguale a nan)
%                           se si vuole trovare il punto ottimale)
%
% th2_fixed (opz.)          angolo del punto di fine manovra nel            [rad]
%                           riferimento dell'orbita finale
%                           (default = nan, porre uguale a nan)
%                           se si vuole trovare il punto ottimale)
%
% plot (opz.)               booleano, se vero plotta il persorso            [true - false]
%                           da punto iniziale a punto finale
%                           (default = false)
%
% risol_angolare (opz.)     numero di punti in cui suddividere le           [-]
%                           orbite di cui deve trovare gli angoli
%                           ottimali di manovra (default = 100)
%
% dim_dt (opz.)             dimensione del vettore restituito               [-]
%                           dalla funzione directTransfer_opt,
%                           ovvero il numero di orbite passanti per
%                           due punti che discretizzano l'intervallo
%                           di validità (default = 100)
%
% it_dt (opz.)              numero di punti in cui si discretizza           [-]
%                           l'intervallo tra 0 e 2*pi per trovare
%                           gli estremi dell'intervallo di
%                           validità nella funzione directTransfer_opt
%                           (default = 50)
%
% toll_dt (opz.)            tolleranza con cui gli estremi                  [-]
%                           dell'intervallo di validità vengono
%                           affinati nella funzione directTransfer_opt
%                           (default = 1e-4)
%
% ----------------------------------------------------------------------------------------
% Output:
%
% at                        semiasse maggiore di trasferimento              [km]
%
% et                        eccentricità di trasferimento                   [-]
%
% i_t                       inclinazione di trasferimento                   [rad]
%
% OMt                       RAAN (ascensione retta del nodo ascendente)     [rad]
%
% omt                       anomalia del pericentro                         [rad]
%
% th1_trasf                 angolo del punto di inizio manovra nel          [rad]
%                           riferimento dell'orbita di trasferimento
%
% th2_trasf                 angolo del punto di fine manovra nel            [rad]
%                           riferimento dell'orbita di trasferimento
%
% th1_iniziale              angolo del punto di inizio manovra nel          [rad]
%                           riferimento dell'orbita iniziale
%
% th2_finale                angolo del punto di fine manovra nel            [rad]
%                           riferimento dell'orbita finale
%
% deltaV_tot                costo complessivo della manovra                 [km/s]
%
% deltaT_tot                tempo totale impiegato per passare dal punto    [s]
%                           iniziale al punto finale
%
% rr1                       vettore posizione del punto di inizio manovra   [km]
%
% rr2                       vettore posizione del punto di fine manovra     [km]
%
% ----------------------------------------------------------------------------------------


%% Valori di default
switch nargin
    case 4
        th1_fixed = nan;
        th2_fixed = nan;
        plot = false;
        risol_angolare = 100;
        dim_dt = 100;
        it_dt = 50;
        toll_dt = 1e-4;
    case 5
        th2_fixed = nan;
        plot = false;
        risol_angolare = 100;
        dim_dt = 100;
        it_dt = 50;
        toll_dt = 1e-4;
    case 6
        plot = false;
        risol_angolare = 100;
        dim_dt = 100;
        it_dt = 50;
        toll_dt = 1e-4;
    case 7
        risol_angolare = 100;
        dim_dt = 100;
        it_dt = 50;
        toll_dt = 1e-4;
    case 8
        dim_dt = 100;
        it_dt = 50;
        toll_dt = 1e-4;
    case 9
        it_dt = 50;
        toll_dt = 1e-4;
    case 10
        toll_dt = 1e-4;
end

%% Trovo parametri orbitali
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[af, ef, i_f, OMf, omf, thf] = car2par(rrf, vvf);

%% Trovo deltaV minimo

% creo una waitbar se la richiesta è di trovare entrambi gli angoli ottimali
if isnan(th1_fixed) && isnan(th2_fixed)
    w = waitbar(0, 'Provando le orbite... (0%)', Name='Esecuzione di secante_ottimale');
end

th_range = linspace(0, 2*pi, risol_angolare);
deltaV_tot = realmax;

for k1 = 1 : risol_angolare                % giro su orbita iniziale

    % aggiorno la waitbar
    if isnan(th1_fixed) && isnan(th2_fixed)
        x = k1 / risol_angolare;
        waitbar(x, w, sprintf('Provando le orbite... (%g%%)', x * 100));
    end

    % se th1_fixed è assegnato, evito di girare su orbita iniziale
    if isnan(th1_fixed)
        thi_k = th_range(k1);
    else
        thi_k = th1_fixed;
    end

    [rri_k, vvi_k] = par2car(ai, ei, i_i, OMi, omi, thi_k);

    for k2 = 1 : risol_angolare            % giro su orbita finale

        % se th2_fixed è assegnato, evito di girare su orbita finale
        if isnan(th2_fixed)
            thf_k = th_range(k2);
        else
            thf_k = th2_fixed;
        end

        [rrf_k, vvf_k] = par2car(af, ef, i_f, OMf, omf, thf_k);

        % trovo deltaV minore per l'orbita passante per i due punti selezionati
        [~, ~, ~, ~, ~, deltaV_k] = directTransfer_opt(rri_k, rrf_k, vvi_k, vvf_k, dim_dt, it_dt, toll_dt);
        deltaV_min_k = min(deltaV_k);

        % se deltaV è minore dei precedenti lo aggiorno
        if deltaV_min_k < deltaV_tot
            deltaV_tot = deltaV_min_k;
            th1_iniziale = thi_k;
            th2_finale = thf_k;
        end

        % se th2_fixed è assegnato, rompo subito il ciclo evitando inutili passaggi
        if ~isnan(th2_fixed)
            break
        end

    end

    % se th1_fixed è assegnato, rompo subito il ciclo evitando inutili passaggi
    if ~isnan(th1_fixed)
        break
    end

end

% chiudo la waitbar
if isnan(th1_fixed) && isnan(th2_fixed)
    close(w);
end

%% Caratterizzo orbita con deltaV minore
[rr1, vv1] = par2car(ai, ei, i_i, OMi, omi, th1_iniziale);
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, th2_finale);

[at_vect, et_vect, i_t, OMt, omt_vect, deltaV, deltaT, th1_trasf_vect, th2_trasf_vect] = directTransfer_opt(rr1, rr2, vv1, vv2, dim_dt, it_dt, toll_dt);
[~, k] = min(deltaV);

at = at_vect(k);
et = et_vect(k);
omt = omt_vect(k);

t_trasf = deltaT(k);
th1_trasf = th1_trasf_vect(k);
th2_trasf = th2_trasf_vect(k);

deltaT_tot = t_trasf + TOF(ai, ei, thi, th1_iniziale) + TOF(af, ef, th2_finale, thf);

%% Plot
if plot
    
    % plotto orbita
    Terra_3D
    
    plotOrbit(ai, ei, i_i, OMi, omi, thi, th1_iniziale, 1e-3, 'rad', 'r')
    plotOrbit(at, et, i_t, OMt, omt, th1_trasf, th2_trasf, 1e-3, 'rad', 'green')
    plotOrbit(af, ef, i_f, OMf, omf, th2_finale, thf, 1e-3, 'rad', 'b')
    
    plot3(rri(1), rri(2), rri(3), 'ko');
    plot3(rrf(1), rrf(2), rrf(3), 'ko');
    
    plot3(rr1(1), rr1(2), rr1(3), 'ro');
    plot3(rr2(1), rr2(2), rr2(3), 'ro');
    
    title('Plot di secante\_ottimale')
    legend('', 'Orbita iniziale', 'Orbita di trasferimento', 'Orbita finale', 'Punti iniziale e finale', '', 'Punti di traferimento')

end
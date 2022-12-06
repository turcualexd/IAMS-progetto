function [af, ef, thi, thf] = tan_omf_opt(ai, ei, omi, omf, deltaV, toll, it_iniziali, mu)

%% Iterazioni iniziali e tolleranza di default (+ mu)
switch nargin
    case 5
        toll = 1e-6;
        it_iniziali = 300;
        mu = 3.986 * 10^5;
    case 6
        it_iniziali = 300;
        mu = 3.986 * 10^5;
    case 7
        mu = 3.986 * 10^5;
end

%% Definisco le variabili in funzione di thf (x)
thi_f = @(x) x + omf - omi;
tan_gamma = @(x) ei .* sin( thi_f(x) ) ./ (1 + ei .* cos( thi_f(x) ));
r_f = @(x) ai .* (1 - ei.^2) ./ (1 + ei .* cos( thi_f(x) ));

ef_f = @(x) tan_gamma(x) ./ (sin(x) - tan_gamma(x) .* cos(x));
af_f = @(x) r_f(x) .* (1 + ef_f(x) .* cos(x)) ./ (1 - ef_f(x).^2);
deltaV_f = @(x) sqrt( 2*mu .* ( 1./r_f(x) - 1./( 2.*af_f(x) ) ) ) - sqrt( 2*mu .* ( 1./r_f(x) - 1./( 2*ai ) ) );

%% Trovo per che valore di thf ottengo il deltaV assegnato (2 soluzioni)

% Pongo thf_vect vettore tra 0 e 2*pi e trovo vettore di deltaV
thf_vect = linspace(0, 2*pi, it_iniziali);
deltaV_vect = deltaV_f(thf_vect + 2*pi);

%% Trovo la prima soluzione

thf = nan;
for k = 1 : it_iniziali - 1
    if imag(deltaV_vect(k)) == 0 && deltaV_vect(k) >= deltaV && deltaV_vect(k+1) < deltaV && deltaV_vect(k+1) > 0
        thf = thf_vect(k+1);
        deltaV_temp = deltaV_vect(k+1);
        break
    end
end

% Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
if isnan(thf)
    thf = thf_vect(it_iniziali);
    deltaV_temp = deltaV_vect(it_iniziali);
end

% Miglioro l'approssimazione di thf
while deltaV_temp < deltaV
    thf = thf - toll;
    deltaV_temp = deltaV_f(thf);
end
thf = thf + toll;

%% Se la prima soluzione non è valida trovo la seconda soluzione
if ef_f(thf) < 0 || ef_f(thf) >= 1

    thf = nan;
    for k = 1 : it_iniziali - 1
        if imag(deltaV_vect(k)) == 0 && deltaV_vect(k) < deltaV && deltaV_vect(k+1) >= deltaV && deltaV_vect(k) > 0
            thf = thf_vect(k);
            deltaV_temp = deltaV_vect(k);
            break
        end
    end
    
    % Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
    if isnan(omf)
        thf = thf_vect(it_iniziali);
        deltaV_temp = deltaV_vect(it_iniziali);
    end
    
    % Miglioro l'approssimazione di thf
    while deltaV_temp < deltaV
        thf = thf + toll;
        deltaV_temp = deltaV_f(thf);
    end
    thf = thf - toll;

    % Verifico che la seconda soluzione sia valida
    if ef_f(thf) < 0 || ef_f(thf) >= 1
        error('thf non trovato')
    end
    
end

%% Trovo i valori dell'orbita così ottenuta
af = af_f(thf);
ef = ef_f(thf);
thi = thi_f(thf);
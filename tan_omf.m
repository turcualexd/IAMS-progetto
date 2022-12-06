function [af, ef, thi, thf] = tan_omf(ai, ei, omi, omf, deltaV, toll, it_iniziali, mu)

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

%% Trovo per che valori di thf ottengo il deltaV assegnato (2 soluzioni)

% Pongo thf_vect vettore tra 0 e 2*pi
thf_vect = linspace(0, 2*pi, it_iniziali);

% Definisco le deltaV (molte sono negative o complesse)
deltaV_vect = deltaV_f(thf_vect + 2*pi);

% Inizializzo le variabili da trovare a nan (thf1 e thf2)
thf1 = nan;
thf2 = nan;

% Inizio con il cercare thf1, che è il valore per cui deltaV è più
% vicino a deltaV assegnato e con pendenza negativa
for k = 1 : it_iniziali - 1
    if imag(deltaV_vect(k)) == 0 && deltaV_vect(k) >= deltaV && deltaV_vect(k+1) < deltaV && deltaV_vect(k+1) > 0
        thf1 = thf_vect(k+1);
        deltaV1 = deltaV_vect(k+1);
        break
    end
end

% Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
if isnan(thf1)
    thf1 = thf_vect(it_iniziali);
    deltaV1 = deltaV_vect(it_iniziali);
end

% Ora trovo thf2, che è il valore per cui deltaV è più vicino a deltaV
% assegnato e con pendenza positiva
for k = 1 : it_iniziali - 1
    if imag(deltaV_vect(k)) == 0 && deltaV_vect(k) < deltaV && deltaV_vect(k+1) >= deltaV && deltaV_vect(k) > 0
        thf2 = thf_vect(k);
        deltaV2 = deltaV_vect(k);
        break
    end
end

% Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
if isnan(omf)
    thf2 = thf_vect(it_iniziali);
    deltaV2 = deltaV_vect(it_iniziali);
end

% Trovati thf1 e thf2 indicativi, voglio avvicinarli il più possibile a
% deltaV assegnato (con una certa tolleranza)

% Miglioro l'approssimazione di thf1
while deltaV1 < deltaV
    thf1 = thf1 - toll;
    deltaV1 = deltaV_f(thf1);
end
thf1 = thf1 + toll;

% Miglioro l'approssimazione di thf2
while deltaV2 < deltaV
    thf2 = thf2 + toll;
    deltaV2 = deltaV_f(thf2);
end
thf2 = thf2 - toll;

% Scelgo la soluzione valida tra le due ottenute
if ef_f(thf1) >= 0 && ef_f(thf1) < 1
    thf = thf1;
elseif ef_f(thf2) >= 0 && ef_f(thf2) < 1
    thf = thf2;
else
    error('thf non trovato')
end

%% Trovo i valori dell'orbita così ottenuta
af = af_f(thf);
ef = ef_f(thf);
thi = thi_f(thf);
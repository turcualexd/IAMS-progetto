function [a, e, i, OM, om, deltaV, deltaT, thi, thf] = directTransfer_opt(rri, rrf, vvi, vvf, dim, it_iniziali, toll)


%% Iterazioni iniziali e tolleranza di default
switch nargin
    case 4
        dim = 100;
        it_iniziali = 50;
        toll = 1e-4;
    case 5
        it_iniziali = 50;
        toll = 1e-4;
    case 6
        toll = 1e-4;
end

%% Scrivo i moduli dei vettori
ri = norm(rri);
rf = norm(rrf);

%% Calcolo il versore normale al piano orbitale (lo prendo direzionato come k)
rri_x_rrf = cross(rri, rrf);
n = rri_x_rrf / norm(rri_x_rrf);
if n(3) < 0
    n = -n;
end

%% Calcolo inclinazione (deve essere tra 0 e pi)
i = acos(n(3));

%% Trovo asse dei nodi
k_x_N = cross([0 0 1]', n);
N = k_x_N / (norm(k_x_N));

%% Calcolo il RAAN
OM = acos(N(1));
if N(2) < 0
    OM = 2*pi - OM;
end

%% Calcolo ui = thi + om e uf = thf + om (angolo tra N e i raggi)
ui = acos(dot(N, rri) / ri);
if rri(3) < 0
    ui = 2*pi - ui;
end

uf = acos(dot(N, rrf) / rf);
if rrf(3) < 0
    uf = 2*pi - uf;
end

%% Trovo gli om validi (parte complicata)

% Pongo om_vect vettore tra 0 e 2*pi e trovo thi_vect e thf_vect
om_vect = linspace(0, 2*pi, it_iniziali);
thi_vect = ui - om_vect;
thf_vect = uf - om_vect;

% Definisco le eccentricità (molte sono negative o in modulo maggiori di 1)
e_vect = (ri - rf) ./ (rf .* cos(thf_vect) - ri .* cos(thi_vect));

% Inizializzo le variabili da trovare a nan (om iniziale e om finale)
omi = nan;
omf = nan;

% Inizio con il cercare omi, che è il valore per cui l'eccentricità è più
% vicina a 1 e con pendenza negativa
for k = 1 : length(om_vect) - 1
    if e_vect(k) >= 1 && e_vect(k+1) < 1 && e_vect(k+1) > 0
        omi = om_vect(k+1);
        ei = e_vect(k+1);
        break
    end
end

% Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
if isnan(omi)
    omi = om_vect(it_iniziali);
    ei = e_vect(it_iniziali);
end

% Ora trovo omf, che è il valore per cui l'eccentricità è più vicina a 1 e
% con pendenza positiva
for k = 1 : length(om_vect) - 1
    if e_vect(k) < 1 && e_vect(k+1) >= 1 && e_vect(k) > 0
        omf = om_vect(k);
        ef = e_vect(k);
        break
    end
end

% Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
if isnan(omf)
    omf = om_vect(it_iniziali);
    ef = e_vect(it_iniziali);
end

% Trovati omi e omf indicativi, voglio avvicinarli il più possibile a
% eccentricità pari a 1 (con una certa tolleranza)

% Miglioro l'approssimazione di omi
while ei < 1
    omi = omi - toll;
    thi_temp = ui - omi;
    thf_temp = uf - omi;
    ei = (ri - rf) / (rf * cos(thf_temp) - ri * cos(thi_temp));
end
omi = omi + toll;

% Miglioro l'approssimazione di omf
while ef < 1
    omf = omf + toll;
    thi_temp = ui - omf;
    thf_temp = uf - omf;
    ef = (ri - rf) / (rf * cos(thf_temp) - ri * cos(thi_temp));
end
omf = omf - toll;

%% Sistemo range se gli estremi risultano invertiti nell'intervallo 0 - 2*pi
if omi > omf
    omi = omi - 2*pi;
end

%% Creo vettore di tutte le om valide e trovo le thi e thf corrispondenti
om = linspace(omi, omf, dim);

thi = ui - om;
thf = uf - om;

%% Calcolo le eccentricità e i semiassi maggiori delle orbite valide
e = (ri - rf) ./ (rf .* cos(thf) - ri .* cos(thi));
a = ri .* (1 + e .* cos(thi)) ./ (1 - e.^2);

%% Calcolo le differenze di velocità totali di tutte le orbite
deltaV = nan(1, dim);
for k = 1 : dim
    [~, vv1] = par2car(a(k), e(k), i, OM, om(k), thi(k));
    [~, vv2] = par2car(a(k), e(k), i, OM, om(k), thf(k));
    deltaV(k) = norm(vv1 - vvi) + norm(vvf - vv2);
end

%% Calcolo i tempi di trasferimento di tutte le orbite
deltaT = TOF(a, e, thi, thf);
function [a, e, i, OM, om, deltaV, deltaT, thi, thf] = directTransfer_opt(rri, rrf, vvi, vvf)


%% Scrivo i moduli dei vettori
ri = norm(rri);
rf = norm(rrf);

%% Calcolo il versore normale al piano orbitale (lo prendo direzionato come k)
n = cross(rri, rrf) / norm(cross(rri, rrf));
if n(3) < 0
    n = -n;
end

%% Calcolo inclinazione (deve essere tra 0 e pi)
i = acos(n(3));

%% Trovo asse dei nodi
kk = [0 0 1]';
N = cross(kk, n)/(norm(cross(kk, n)));

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

% Pongo omv vettore tra 0 e 2*pi e trovo thiv e thfv
omv = 0 : 0.01 : 2*pi;
thiv = ui - omv;
thfv = uf - omv;

% Definisco le eccentricità (molte sono negative o in modulo maggiori di 1)
ev = (ri - rf) ./ (rf .* cos(thfv) - ri .* cos(thiv));

% Inizializzo le variabili da trovare a nan
omi = nan;
omf = nan;
flag = nan;

% Inizio con il cercare omi, che deve essere il primo valore positivo
% inferiore a 1 dopo il primo asintoto verticale sul grafico
% dell'eccentricità; appena lo trovo, salvo omi e la posizione flag di k
for k = 1 : length(omv) - 1
    if ev(k) >= 1 && ev(k+1) < 1
        omi = omv(k+1);
        ei = ev(k+1);
        flag = k+1;
        break
    end
end

% Ora trovo omf, che deve essere l'ultimo valore positivo inferiore a 1
% prima del secondo asintoto verticale sul grafico dell'eccentricità
for k = flag : length(omv) - 1
    if ev(k) < 1 && ev(k+1) >= 1
        omf = omv(k);
        ef = ev(k);
        break
    end
end

% Trovati omi e omf indicativi, voglio avvicinarli il più possibile a
% eccentricità pari a 1 (con una certa tolleranza)
toll = 1e-6;

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

%% Creo vettore di tutte le om valide e trovo le thi e thf corrispondenti
om = linspace(omi, omf, 10000);
thi = ui - om;
thf = uf - om;

%% Calcolo le eccentricità e i semiassi maggiori delle orbite valide
e = (ri - rf) ./ (rf .* cos(thf) - ri .* cos(thi));
a = ri .* (1 + e .* cos(thi)) ./ (1 - e.^2);

%% Calcolo le differenze di velocità totali di tutte le orbite
deltaV = nan(1, length(om));
for k = 1 : length(om)
    [~, vv1] = par2car(a(k), e(k), i, OM, om(k), thi(k), 'rad');
    [~, vv2] = par2car(a(k), e(k), i, OM, om(k), thf(k), 'rad');
    deltav1_vect = vv1 - vvi;
    deltav2_vect = vvf - vv2;
    deltav1 = norm(deltav1_vect);
    deltav2 = norm(deltav2_vect);
    deltaV(k) = deltav1 + deltav2;
end

%% Calcolo i tempi di trasferimento di tutte le orbite
deltaT = TOF(a, e, thi, thf);
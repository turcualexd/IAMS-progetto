clear, clc, close all;

%% Dati
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

it_iniziali = 1000;

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
for k = 1 : it_iniziali - 1
    if e_vect(k) >= 1 && e_vect(k+1) < 1 && e_vect(k+1) > 0
        ki = k + 1;
        omi = om_vect(ki);
        ei = e_vect(ki);
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
for k = 1 : it_iniziali - 1
    if e_vect(k) < 1 && e_vect(k+1) >= 1 && e_vect(k) > 0
        kf = k;
        omf = om_vect(kf);
        ef = e_vect(kf);
        break
    end
end

% Se non lo trova vuol dire che è agli estremi (a 0 o 2*pi)
if isnan(omf)
    omf = om_vect(it_iniziali);
    ef = e_vect(it_iniziali);
end

%% Sistemo range se gli estremi risultano invertiti nell'intervallo 0 - 2*pi
omi_i = omi;
if omi > omf
    omi = omi - 2*pi;
end

om = om_vect;

thi = ui - om;
thf = uf - om;

%% Calcolo le eccentricità e i semiassi maggiori delle orbite valide
e = (ri - rf) ./ (rf .* cos(thf) - ri .* cos(thi));
a = ri .* (1 + e .* cos(thi)) ./ (1 - e.^2);

%% Plot
plot(om_vect, e_vect, 'b', 'LineWidth', 4)
hold on
grid on
plot(omi_i, e_vect(ki), 'rx', 'MarkerSize', 20, 'LineWidth', 3)
plot(omf, e_vect(kf), 'rx', 'MarkerSize', 20, 'LineWidth', 3)
plot(om_vect(ki:it_iniziali), e_vect(ki:it_iniziali), 'r', 'LineWidth', 4)
plot(om_vect(1:kf), e_vect(1:kf), 'r', 'LineWidth', 4)
set(gca, 'FontSize', 25)
xlabel('\omega', 'FontSize', 45)
ylabel('e', 'FontSize', 45)
legend('$ e<0 \cup e \ge 1 $', '', '', '$ 0 \le e < 1 $', 'Interpreter', 'latex', fontsize = 40)
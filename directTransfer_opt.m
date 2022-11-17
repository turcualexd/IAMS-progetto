function [a, e, i, OM, om] = directTransfer_opt(rri, rrf)

ri = norm(rri);
rf = norm(rrf);

% calcolo il versore normale al piano orbitale (lo prendo direzionato come k
n = cross(rri, rrf) / norm(cross(rri, rrf));
if n(3) < 0
    n = -n;
end

% inclinazione (da 0 a pi)
i = acos(n(3));
k = [0 0 1]';

% asse dei nodi
N = cross(k, n)/(norm(cross(k, n)));

% RAAN
OM = acos(N(1));
if N(2) < 0
    OM = 2*pi - OM;
end

% thi + om
ui = acos(dot(N, rri) / ri);
if rri(3) < 0
    ui = 2*pi - ui;
end

% thf + om
uf = acos(dot(N, rrf) / rf);
if rrf(3) < 0
    uf = 2*pi - uf;
end

% trovo om limite
omv = 0 : 0.01 : 2*pi;
thiv = ui - omv;
thfv = uf - omv;
ev = (ri - rf) ./ (rf .* cos(thfv) - ri .* cos(thiv));

omi = 0;
omf = 0;
flag = 0;

for k = 1:length(omv) - 1
    if ev(k) >= 1 && ev(k+1) < 1
        omi = omv(k+1);
        ei = ev(k+1);
        flag = k+1;
        break
    end
end

for k = flag:length(omv) - 1
    if ev(k) < 1 && ev(k+1) >= 1
        omf = omv(k);
        ef = ev(k);
        break
    end
end

while ei < 1
    omi = omi - 1e-5;
    thi_temp = ui - omi;
    thf_temp = uf - omi;
    ei = (ri - rf) / (rf * cos(thf_temp) - ri * cos(thi_temp));
end
omi = omi + 1e-5;

while ef < 1
    omf = omf + 1e-5;
    thi_temp = ui - omf;
    thf_temp = uf - omf;
    ef = (ri - rf) / (rf * cos(thf_temp) - ri * cos(thi_temp));
end
omf = omf - 1e-5;

% vario om come parametro
om = linspace(omi, omf, 100);
thi = NaN(length(om), 1);
thf = NaN(length(om), 1);

for k = 1:length(om)
    thi(k) = ui - om(k);
    if thi(k) < 0
        thi(k) = thi(k) + 2*pi;
    end
end

for k = 1:length(om)
    thf(k) = uf - om(k);
    if thf(k) < 0
        thf(k) = thf(k) + 2*pi;
    end
end

e = (ri - rf) ./ (rf .* cos(thf) - ri .* cos(thi));

a = ri .* (1 + e .* cos(thi)) ./ (1 - e.^2);
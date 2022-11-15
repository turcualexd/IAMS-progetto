function [a, e, i, OM, om] = directTransfer(rri, rrf)

% calcolo il versore normale al piano orbitale (lo prendo direzionato come k)
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

% trovo raggio minore e maggiore
if norm(rri) <= norm(rrf)
    rmin = rri;
    rmax = rrf;
else
    rmin = rrf;
    rmax = rri;
end

% N.B.: come scelta per orbita pongo rmin come perigeo (ma si può cambiare)

% angolo del perigeo rispetto a N
om = acos( dot(N, rmin) / norm(rmin) );
if rmin(3) < 0
    om = 2*pi - om;
end

% trovo il coseno dell'angolo di arrivo rispetto a quello di partenza
cos_thf = dot(rri, rrf) / (norm(rri) * norm(rrf));

% eccentricità
e = (norm(rmax) - norm(rmin)) / (norm(rmin) - cos_thf * norm(rmax));

% semiasse maggiore
a = norm(rmin) / (1 - e);
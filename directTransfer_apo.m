function [a, e, i, OM, om, delta_t, delta_th,  deltav1, deltav2, deltavtot] = directTransfer_apo(rri, rrf, vvi, vvf)

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

% N.B.: come scelta per orbita pongo rmax come apogeo (ma si può cambiare)

% angolo dell'apogeo rispetto a N
om = acos( dot(N, -rmax) / norm(rmax) );
if rmax(3) > 0
    om = 2*pi - om;
end

% trovo il coseno dell'angolo di arrivo rispetto a quello di partenza
cos_thi = dot(rmin, -rmax) / (norm(rmin) * norm(rmax));

% eccentricità
e = (norm(rmax) - norm(rmin)) / (norm(rmax) + cos_thi * norm(rmin));

% semiasse maggiore
a = norm(rmax) / (1 + e);

% trovo tempo di volo

delta_th = acos(cos_thi);
delta_t = TOF(a, e, pi, 2*pi - delta_th);

[~, vv_1] = par2car(a, e, i, OM, om, pi, 'rad');
[~, vv_2] = par2car(a, e, i, OM, om, 2*pi - delta_th, 'rad');

if nargin > 2
    delta_v1_vect = vv_1 - vvi;
    delta_v2_vect = vvf - vv_2;

    deltav1 = norm(delta_v1_vect);
    deltav2 = norm(delta_v2_vect);
    deltavtot = deltav1 + deltav2;
end

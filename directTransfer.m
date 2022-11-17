function [a, e, i, OM, om, delta_t, delta_th,  deltav1, deltav2, deltavtot] = directTransfer(rri, rrf, vvi, vvf)

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

% trovo tempo di volo

delta_th = acos(cos_thf);
delta_t = TOF(a, e, -delta_th, 2*pi);

[~, vv_1] = par2car(a, e, i, OM, om, -delta_th, 'rad');
[~, vv_2] = par2car(a, e, i, OM, om, 0, 'rad');

if nargin > 2
    delta_v1_vect = vv_1 - vvi;
    delta_v2_vect = vv_2 - vvf;

    deltav1 = norm(delta_v1_vect);
    deltav2 = norm(delta_v2_vect);
    deltavtot = deltav1 + deltav2;
end
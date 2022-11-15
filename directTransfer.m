function [a, e, i, OM, om] = directTransfer(rri, rrf)

n = cross(rri, rrf) / norm(cross(rri, rrf));
if n(3) < 0
    n = -n;
end

i = acos(n(3));

N = cross([0 0 1]', n);

OM = acos(N(1));
if N(2) < 0
    OM = 2*pi - OM;
end

[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi, 'rad')
[af, ef, i_f, OMf, omf, thf] = car2par(rrf, vvf, 'rad')

if norm(rri) <= norm(rrf)
    rmin = rri;
    rmax = rrf;
else
    rmin = rrf;
    rmax = rri;
end

% Pongo rmin come perigeo

om = acos( dot(N, rmin) / norm(rmin) );
if rmin(3) < 0
    om = 2*pi - om;
end

cos_thf = dot(rri, rrf) / (norm(rri) * norm(rrf));

e = (norm(rmax) - norm(rmin)) / (norm(rmin) - cos_thf * norm(rmax));

a = norm(rmin) / (1 - e);
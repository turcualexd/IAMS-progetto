function [af, ef, i_f, OMf, omf, thf] = tangente(rri, vvi, deltaV, mu)

if nargin == 3
    mu = 3.986 * 10^5;
end

[~, ei, i_f, OMf, omi, thi] = car2par(rri, vvi);

ri = norm(rri);
vi = norm(vvi);

tan_gamma = ei * sin(thi) / (1 + ei * cos(thi));

af = (2 / ri - (vi + deltaV)^2 / mu)^-1;

ef_f = @(x) tan_gamma ./ (sin(x) - tan_gamma * cos(x));
r_f = @(x) af * (1 - ef_f(x).^2) ./ (1 + ef_f(x) .* cos(x));

syms x;
thf_vect = real(double(solve(r_f(x) == ri, x)));
thf_vect = wrapTo2Pi(thf_vect);

ef_vect = ef_f(thf_vect);

if ef_vect(1) > 0
    ef = ef_vect(1);
    thf = thf_vect(1);
else
    ef = ef_vect(2);
    thf = thf_vect(2);
end

omf = omi - (thf - thi);
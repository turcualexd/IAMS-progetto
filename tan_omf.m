function [af, ef, i_f, OMf, omf, thi, thf] = tan_omf(ai, ei, i_i, OMi, omi, omf, deltaV, mu)

if nargin == 7
    mu = 3.986 * 10^5;
end

i_f = i_i;
OMf = OMi;

thi_f = @(x) x + omf - omi;
tan_gamma = @(x) ei .* sin( thi_f(x) ) ./ (1 + ei .* cos( thi_f(x) ));
r_f = @(x) ai .* (1 - ei.^2) ./ (1 + ei .* cos( thi_f(x) ));

ef_f = @(x) tan_gamma(x) ./ (sin(x) - tan_gamma(x) .* cos(x));
af_f = @(x) r_f(x) .* (1 + ef_f(x) .* cos(x)) ./ (1 - ef_f(x).^2);
deltaV_f = @(x) sqrt( 2*mu .* ( 1./r_f(x) - 1./( 2.*af_f(x) ) ) ) - sqrt( 2*mu .* ( 1./r_f(x) - 1./( 2*ai ) ) );

syms x;
thf = double(vpasolve(deltaV_f(x) - deltaV == 0, x, 0.5));

af = af_f(thf);
ef = ef_f(thf);
thi = thi_f(thf);
clear, clc, close all

%% Dati
mu = 3.986 * 10^5;
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

[om_cp, th_cp_vect] = changeOrbitalPlane_mod(i_f, OMf, omf, i_i, OMi);
th_cp = th_cp_vect(2);

%%
deltaV = 1.3;

thi_f = @(x) x + om_cp - omi;
tan_gamma = @(x) ei .* sin( thi_f(x) ) ./ (1 + ei .* cos( thi_f(x) ));
r_f = @(x) ai .* (1 - ei.^2) ./ (1 + ei .* cos( thi_f(x) ));

ef_f = @(x) tan_gamma(x) ./ (sin(x) - tan_gamma(x) .* cos(x));
af_f = @(x) r_f(x) .* (1 + ef_f(x) .* cos(x)) ./ (1 - ef_f(x).^2);
deltaV_f = @(x) sqrt( 2*mu .* ( 1./r_f(x) - 1./( 2.*af_f(x) ) ) ) - sqrt( 2*mu .* ( 1./r_f(x) - 1./( 2*ai ) ) );

xx = linspace(0, 2*pi, 10000);
plot(xx, deltaV_f(xx))

syms x;
vpasolve(deltaV_f(x) == deltaV, x, 2.5)
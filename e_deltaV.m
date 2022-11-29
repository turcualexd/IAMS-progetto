clear, clc, close all

%% Dati
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';
mu = 398600;

[ai, ei] = car2par(rri, vvi);

%% Funzioni analitiche
c1 = @(deltaV) 1 + ei/2 - deltaV.^2 * ai * (1 - ei) / (2*mu);
c2 = @(deltaV) c1(deltaV) - ei - 1;
c3 = @(deltaV) 4 * (c1(deltaV).^2 - ei - 1);

e = @(deltaV) -2 * c2(deltaV) + sqrt(abs(4*c2(deltaV).^2 - c3(deltaV)));
a = @(deltaV) ai * (1 - ei) ./ (1 - e(deltaV));

%% Plot grafici a e e
vel_fuga = sqrt(2 * mu / (ai * (1 - ei))) - sqrt(mu / ai * (1 + ei) / (1 - ei)) - 1e-4;

vv = linspace(0, vel_fuga, 10000);

figure
e_plot = e(vv);
plot(vv, e_plot)

figure
a_plot = a(vv);
plot(vv, a_plot)

%% Cambio piano
deltaV_cp = @(alpha, deltaV) 2 * sqrt(abs( mu ./ a(deltaV) .* (1 - e(deltaV)) ./ 1 + e(deltaV) )) .* sin(alpha / 2);
deltaV_tot = @(alpha, deltaV) deltaV + deltaV_cp(alpha, deltaV);

figure
vvtt = deltaV_tot(1, vv);
plot(vv, vvtt)
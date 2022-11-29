clear, clc, close all

%% Dati
mu = 398600;

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

%% Funzioni analitiche
c1 = @(deltaV) 1 + ei/2 - deltaV.^2 * ai * (1 - ei) / (2*mu);
c2 = @(deltaV) c1(deltaV) - ei - 1;
c3 = @(deltaV) 4 * (c1(deltaV).^2 - ei - 1);

e = @(deltaV) -2 * c2(deltaV) + sqrt(abs(4*c2(deltaV).^2 - c3(deltaV)));
a = @(deltaV) ai * (1 - ei) ./ (1 - e(deltaV));

%% Orbita enorme
deltaV_fuga = sqrt(2 * mu / (ai * (1 - ei))) - sqrt(mu / ai * (1 + ei) / (1 - ei));
v = deltaV_fuga * 0.8;
[rrt, vvt] = par2car(a(v), e(v), i_i, OMi, omi, pi);

%% Plot
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b')

plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');

legend('', 'Orbita iniziale', 'Orbita finale', 'Punti iniziale e finale')

plotOrbit(a(v), e(v), i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')

[at, et, i_t, OMt, omt, th1_trasf, th2_trasf, th1_iniziale, th2_finale, deltaV_tot, deltaT_tot, rr1, rr2] = secante_ottimale(rrt, vvt, rrf, vvf, nan, nan, true);

deltaV = deltaV_tot + v
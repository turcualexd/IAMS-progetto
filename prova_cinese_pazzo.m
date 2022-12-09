clear, clc, close all

%% Dati
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

%%
if thi > thf
    thi = thi - 2*pi;
end

dth = 1e-2;
th = (0 : dth : 2*pi)';
n = length(th);

rr = nan(3, n);
vv = nan(3, n);

for j = 1 : n
    [rr(:, j), vv(:, j)] = par2car(af, ef, i_f, OMf, omf, th(j));
end

vv_norm = vecnorm(vv);
rr_diff = vecnorm([diff(rr, 1, 2), zeros(3, 1)]);
tt = rr_diff ./ vv_norm;

speed = 1000;
dt = tt / speed;

%% Plot
Terra_3D
rotate3d on
marker = plot3(NaN, NaN, NaN, 'r');
line = plot3(NaN, NaN, NaN, 'b');

for j = 1 : n
    set(marker, 'Marker','o','XData', rr(1, j), 'YData', rr(2, j), 'ZData', rr(3, j));
    set(line, 'XData', rr(1, 1:j), 'YData', rr(2, 1:j), 'ZData', rr(3, 1:j));
    pause(dt(j));
    drawnow;
end
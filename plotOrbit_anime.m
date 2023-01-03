function [rri, rrf] = plotOrbit_anime(a, e, i, OM, om, thi, thf, line_color, marker_color, dth, speed)

switch nargin
    case 7
        line_color = 'b';
        marker_color = 'k';
        dth = 1e-2;
        speed = 2000;
    case 8
        marker_color = 'k';
        dth = 1e-2;
        speed = 2000;
    case 9
        dth = 1e-2;
        speed = 2000;
    case 10
        speed = 2000;
end

if thi > thf
    thi = thi - 2*pi;
end

th = (thi : dth : thf)';
n = length(th);

rr = nan(3, n);
vv = nan(3, n);

for j = 1 : n
    [rr(:, j), vv(:, j)] = par2car(a, e, i, OM, om, th(j));
end

vv_norm = vecnorm(vv);
rr_diff = vecnorm([diff(rr, 1, 2), zeros(3, 1)]);
tt = rr_diff ./ vv_norm;
dt = tt / speed;

rri = rr(:, 1);
rrf = rr(:, end);

%% Plot
rotate3d on
marker = plot3(NaN, NaN, NaN, 'Color', marker_color, 'MarkerSize',10);
line = plot3(NaN, NaN, NaN, 'Color', line_color, LineWidth=2);

for j = 1 : n
    set(marker, 'Marker','o','XData', rr(1, j), 'YData', rr(2, j), 'ZData', rr(3, j));
    set(line, 'XData', rr(1, 1:j), 'YData', rr(2, 1:j), 'ZData', rr(3, 1:j));
    %view(rr(:, j));
    pause(dt(j));
end
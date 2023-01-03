function [rri, rrf] = plotOrbit(a, e, i, OM, om, thi, thf, dth, unit, color_orbit)

if unit == "deg"
    thi = deg2rad(thi);
    thf = deg2rad(thf);
    dth = deg2rad(dth);
end

if thi > thf
    thi = thi - 2*pi;
end

th = [thi : dth : thf]';

rr = [];
vv = [];
for j = 1:length(th)
    [r, v] = par2car(a, e, i, OM, om, th(j), unit);
    rr = [rr r];
    vv = [vv v];
end

plot3(rr(1,:), rr(2,:), rr(3,:), 'color', color_orbit, LineWidth=2);
%comet3(rr(1,:), rr(2,:), rr(3,:));

rri = rr(:, 1);
rrf = rr(:, end);
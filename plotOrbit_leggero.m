function [rri, rrf] = plotOrbit_leggero(a, e, i, OM, om, thi, thf, dth, unit, Color)

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

plot3(rr(1,:), rr(2,:), rr(3,:), Color);
%comet3(rr(1,:), rr(2,:), rr(3,:));

rri = rr(:, 1);
rrf = rr(:, end);
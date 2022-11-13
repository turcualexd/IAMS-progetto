function plotOrbit(a, e, i, OM, om, thi, thf, dth, unit, Color)

if unit == "deg"
    thi = deg2rad(thi);
    thf = deg2rad(thf);
    dth = deg2rad(dth);
end

th = [thi : dth : thf]';

rr = [];
vv = [];
for j = 1:length(th)
    [r, v] = par2car(a, e, i, OM, om, th(j), unit);
    rr = [rr r];
    vv = [vv v];
end

grid on
plot3(rr(1,:), rr(2,:), rr(3,:), Color);
%comet3(rr(1,:), rr(2,:), rr(3,:));
xlabel('X [km]');
ylabel('Y [km]');
zlabel('Z [km]');
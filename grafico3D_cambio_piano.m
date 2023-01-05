close all
clear
clc

run("alex_strategia_tangente.m");
close all

aa = a_i:150:a_f;
ee = linspace(e_i, e_f, length(aa));
costoV = zeros(length(aa), length(ee));

for k = 1:length(aa)
    a = aa(k);

    for j = 1:length(ee)
        e = ee(j);

        [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OM_i, om_i, i_f, OM_f);
        costoV(k, j) = min(DeltaV);

    end

end

[X, Y] = meshgrid(aa, ee);

p1 = plot3(aa(end), ee(end), costoV(end, end), 'ro', 'DisplayName','cambio piano in manovra standard', LineWidth=3);
hold on
p2 = plot3(a_tan, e_tan, deltaV_tan_cp, 'bo', 'DisplayName','cambio piano in manovra tangente', LineWidth=3);
grid minor

xlabel('semiasse maggiore [km]');
ylabel('eccentricità []');
zlabel('Costo cambio piano [km/s]');

p3 = surf(X, Y, costoV, 'DisplayName','Standard');

legend([p1 p2 p3], FontSize=15);

c = colorbar;
c.Label.String = '[km/s]';

hold off
%%

for u = 1:length(aa)

    plot(ee, costoV(u, :), '-o');
    hold on

end

grid minor






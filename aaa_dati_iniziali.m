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

%% Plot
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b')

plot3(rri(1), rri(2), rri(3), 'ro', LineWidth=2);
plot3(rrf(1), rrf(2), rrf(3), 'bo', LineWidth=2);

% % quiver3(rri(1), rri(2), rri(3), vvi(1), vvi(2), vvi(3), 1e3, color="#D00A00", LineWidth=2);
% quiver3(rrf(1), rrf(2), rrf(3), vvf(1), vvf(2), vvf(3), 1e3, color = "#3724AA", LineWidth=2);
% 'Initial Velocity', 'Final Velocity'

legend('', 'Initial Orbit', 'Final Orbit',...
    'Initial Point', 'Final Point', fontsize=15)


%% 

Terra_3D

plot3(rri(1), rri(2), rri(3), 'ro', LineWidth=1);
quiver3(rri(1), rri(2), rri(3), vvi(1), vvi(2), vvi(3), 1e3, 'r', LineWidth=2);
plotOrbit_leggero(ai, ei, i_i, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r--');

legend('', 'Initial position', 'Initial velocity', 'Found Orbit',fontsize=15)

%%

Terra_3D

plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'b');

plot3(rrf(1), rrf(2), rrf(3), 'ko', LineWidth=2);

quiver3(rrf(1), rrf(2), rrf(3), vvf(1), vvf(2), vvf(3),1e3,...
    'k', LineWidth=1,ShowArrowHead='on');

legend('', 'Final Orbit','Final Point', 'Final Velocity', fontsize=15)




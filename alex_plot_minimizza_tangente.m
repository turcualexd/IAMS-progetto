clear, clc, close all;
load('alex_minimizza_tangente_workspace.mat')

plot(deltaV_i_tan_vect, deltaV_tot_vect, 'LineWidth', 3)
grid on
set(gca, 'FontSize', 25, 'GridAlpha', 0.5)
xlabel('\Deltav_{tangent} [km/s]', 'FontSize', 30)
ylabel('\Deltav_{total} [km/s]', 'FontSize', 30)
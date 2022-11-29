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
vel_fuga = sqrt(2 * mu / (ai * (1 - ei))) - sqrt(mu / ai * (1 + ei) / (1 - ei)) - 5e-2;

n = 1000;
vv = linspace(0, vel_fuga, n);

% figure
% e_plot = e(vv);
% plot(vv, e_plot)
% xlabel('\DeltaV_i')
% ylabel('e')
% 
% figure
% a_plot = a(vv);
% plot(vv, a_plot)
% xlabel('\DeltaV_i')
% ylabel('a')

%% Cambio piano
deltaV_cp = @(alpha, deltaV) 2 * sqrt(abs( mu ./ a(deltaV) .* (1 - e(deltaV)) ./ 1 + e(deltaV) )) .* sin(alpha / 2);
deltaV_tot = @(alpha, deltaV) 2*deltaV + deltaV_cp(alpha, deltaV);

alpha = linspace(0, pi, 1000);
% for i = alpha
% 
%     figure
%     vvcp = deltaV_tot(i, zeros(1, n));
%     vvtt = deltaV_tot(i, vv);
%     plot(vv, vvtt)
%     hold on
%     plot(vv, vvcp)
%     xlabel('\DeltaV_i')
%     ylabel('\DeltaV_{tot}')
%     title(sprintf('alpha = %g', i))
% 
% end

[X, Y] = meshgrid(alpha, vv);
figure
surf(X, Y, deltaV_tot(X, Y), 'EdgeColor','none')
xlabel('Alpha')
ylabel('\DeltaV_i')
zlabel('\DeltaV_{tot}')
close all
clear
clc

% descrive la velocità di cambio piano in funzione dei parametri assegnati

rr = [-1169.7791 -8344.5289 977.8062 ]';
vv = [4.2770 -1.9310 -4.9330 ]';
[ai, ei, i_i, OMi, omi, thi] = car2par(rr, vv, 'rad');

af = 10860;
e = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

DeltaOM = OMf - OMi;
Deltai = i_f - i_i;

mu = 3.986e5;

passo = 10;

aaa = [ai:passo:af]';

if Deltai == 0
    error("The variation of inclination is zero")

elseif DeltaOM == 0
    alpha = Deltai;
    omf = omi;
    theta1 = 2*pi - omf;

elseif i_i == 0
    alpha = Deltai;
    omf = omi - OMf;
    theta1 = 2*pi - omf;

elseif i_f == 0
    alpha = Deltai;
    omf = omi + OMi;
    theta1 = 2*pi - omi;

elseif i_i == pi
    alpha = Deltai;
    omf = omi - OMf;
    theta1 = 2*pi - omf;

elseif i_f == pi
    alpha = Deltai;
    omf = omi + OMi;
    theta1 = 2*pi - omi;

else
    alpha = acos( cos(i_i) * cos(i_f) + sin(i_i) * sin(i_f) * cos(abs(DeltaOM)) );
    sin_ui = sin(abs(DeltaOM)) / sin(alpha) * sin(i_f);
    sin_uf = sin(abs(DeltaOM)) / sin(alpha) * sin(i_i);

    if DeltaOM > 0 && Deltai > 0
        cos_ui = (-cos(i_f) + cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
        cos_uf = (cos(i_i) - cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
        ui = atan2(sin_ui, cos_ui);
        uf = atan2(sin_uf, cos_uf);
        theta1 = ui - omi;
        omf = uf - theta1;

        elseif DeltaOM > 0 && Deltai < 0
            cos_ui = (cos(i_f) - cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
            cos_uf = (-cos(i_i) + cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
            ui = atan2(sin_ui, cos_ui);
            uf = atan2(sin_uf, cos_uf);
            theta1 = 2*pi - ui - omi;
            omf = 2*pi - uf - theta1;

        elseif DeltaOM < 0 && Deltai > 0
            cos_ui = (-cos(i_f) + cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
            cos_uf = (cos(i_i) - cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
            ui = atan2(sin_ui, cos_ui);
            uf = atan2(sin_uf, cos_uf);
            theta1 = 2*pi - ui - omi;
            omf = 2*pi - uf - theta1;
            
        elseif DeltaOM < 0 && Deltai < 0
            cos_ui = (cos(i_f) - cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
            cos_uf = (-cos(i_i) + cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
            ui = atan2(sin_ui, cos_ui);
            uf = atan2(sin_uf, cos_uf);
            theta1 = ui - omi;
            omf = uf - theta1;

    end
end

if theta1 < 0
    theta1 = theta1 + pi;
elseif theta1 >= pi
    theta1 = theta1 - pi;
end

theta2 = theta1 + pi;
theta = [theta1; theta2];


dv = @(a) 2 * sqrt(mu ./ (a .* (1 - e^2)) .* (1 + e .* cos(theta(1)))) .* sin(alpha / 2);

plot(aaa, dv(aaa));
hold on

dv2 = @(a) 2 * sqrt(mu ./ (a .* (1 - e^2)) .* (1 + e .* cos(theta(2)))) .* sin(alpha / 2);

plot(aaa, dv2(aaa));

title('Costs of \DeltaV');
xlabel('major semiaxis [km]')
ylabel('cost [km/s]');
grid minor

plot(aaa(end), dv2(aaa(end)), 'go')


legend('Costs of \DeltaV in \theta 1', 'Costs of \DeltaV in \theta 2', 'Chosen Point')
dv(aaa(end))




clear, clc, close all

%% Dati iniziali
rri = [-1169.7791 -8344.5289 977.8062]';
vvi = [4.2770 -1.9310 -4.9330]';

%% Dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% Mega stronzata
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi);
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);

deltaV_min = realmax;
n = 100;

th_range = linspace(0, 2*pi, n);

for k1 = 1:n                % giro su orbita iniziale
    thi_k = th_range(k1);
    [rri_k, vvi_k] = par2car(ai, ei, i_i, OMi, omi, thi_k);

    for k2 = 1:n            % giro su orbita finale
        thf_k = th_range(k2);
        [rrf_k, vvf_k] = par2car(af, ef, i_f, OMf, omf, thf_k);

        % trovo deltaV minore per l'orbita passante per i due punti selezionati
        [~, ~, ~, ~, ~, deltaV_k] = directTransfer_opt(rri_k, rrf_k, vvi_k, vvf_k);
        deltaV_min_k = min(deltaV_k);

        % se deltaV è minore dei precedenti lo aggiorno
        if deltaV_min_k < deltaV_min
            deltaV_min = deltaV_min_k;
            th1 = thi_k;
            th2 = thf_k;
        end

    end

end

%% Caratterizzo orbita con deltaV minore
[rr1, vv1] = par2car(ai, ei, i_i, OMi, omi, th1);
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, th2);

[at, et, i_t, OMt, omt, deltaV, deltaT, th1_trasf_vect, th2_trasf_vect] = directTransfer_opt(rr1, rr2, vv1, vv2);
[~, k] = min(deltaV);

t_trasf = deltaT(k);
th1_trasf = th1_trasf_vect(k);
th2_trasf = th2_trasf_vect(k);

thi_p = thi;
if thi > th1
    thi_p = thi_p - 2*pi;
end

th2_p = th2;
if th2 > thf
    th2_p = th2_p - 2*pi;
end

th1_trasf_p = th1_trasf;
if th1_trasf > th2_trasf
    th1_trasf_p = th1_trasf_p - 2*pi;
end

% plotto orbita
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, thi_p, th1, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, th2_p, thf, 1e-3, 'rad', 'b')
plotOrbit(at(k), et(k), i_t, OMt, omt(k), th1_trasf_p, th2_trasf, 1e-3, 'rad', 'green')
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
plot3(rr1(1), rr1(2), rr1(3), 'ro');
plot3(rr2(1), rr2(2), rr2(3), 'ro');
title('Orbita per minimizzare \DeltaV')
legend('', 'Orbita iniziale', 'Orbita finale', 'Orbita di trasferimento', 'Punti iniziale e finale', '', 'Punti di traferimento')

deltaV_min
T = ( t_trasf + TOF(ai, ei, thi, th1) + TOF(af, ef, th2, thf) ) / 60^2
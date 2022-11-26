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

vmin = realmax;
n = 100;

th1_range = linspace(0, 2*pi, n);
th2_range = linspace(0, 2*pi, n);
for k1 = 1:n
    thik = th1_range(k1);
    [rri, vvi] = par2car(ai, ei, i_i, OMi, omi, thik);
    for k2 = 1:n
        thfk = th2_range(k2);
        [rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thfk);
        [~, ~, ~, ~, ~, deltaV] = directTransfer_opt(rri, rrf, vvi, vvf);
        deltaV_min = min(deltaV);

        if deltaV < vmin
            vmin = deltaV_min;
            rri_min = rri;
            rrf_min = rrf;
            vvi_min = vvi;
            vvf_min = vvf;
            thi_min = thik;
            thf_min = thfk;
        end

    end
end

%% Caratterizzo orbita con deltaV minore
[at, et, i_t, OMt, omt, deltaV, deltaT, th1, th2] = directTransfer_opt(rri_min, rrf_min, vvi_min, vvf_min);
[~, kmin] = min(deltaV);
tmin = deltaT(kmin);

th1v = th1(kmin);
th2v = th2(kmin);
if th1v > th2v
    th1v = th1v - 2*pi;
end

% plotto orbita
Terra_3D
plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b')
plotOrbit(at(kmin), et(kmin), i_t, OMt, omt(kmin), th1v, th2v, 1e-3, 'rad', 'green')
plot3(rri(1), rri(2), rri(3), 'ko');
plot3(rrf(1), rrf(2), rrf(3), 'ko');
plot3(rri_min(1), rri_min(2), rri_min(3), 'ro');
plot3(rrf_min(1), rrf_min(2), rrf_min(3), 'ro');
title('Orbita per minimizzare \DeltaV')
legend('', 'Orbita iniziale', 'Orbita finale', 'Orbita di trasferimento', 'Punti iniziale e finale', '', 'Punti di traferimento')

vmin
T = ( tmin + TOF(ai, ei, thi, thi_min) + TOF(af, ef, thf_min, thf) ) / 60
deltaV(kmin)
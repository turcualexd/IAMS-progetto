clear; close all

%% dati iniziali
rr = [-1169.7791 -8344.5289 977.8062]';
vv = [4.2770 -1.9310 -4.9330]';
[ai, ei, ii, OMi, omi, thi] = car2par(rr, vv);
[rrp, vvp] = par2car(ai, ei, ii, OMi, omi, 0);

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf);
[rrfp, vvfp] = par2car(af, ef, i_f, OMf, omf, 0);


vel = [];

% faccio fondere il pc

% ee = 0:1e-1:1;
aa = ai:1e2:af;
aaa = aa(10):1e1:aa(12);
aaaa = aaa(2):1:aaa(4);
aaaaa = aaaa(8):1e-1:aaaa(10);
valore_ottimale = aaaaa(11);
minimo = [1e10 0 0 0 0];

for j = 1:1

    deltav = 0;
    deltat = 0;
    raf = aaaaa(11);

    ec = 0;
    deltat1 = TOF(ai, ei, thi, 2*pi); % arrivo al punto di trasferimento
    
    [DeltaV1, DeltaV2, Deltat, om_f_new, om_t, a_t, e_t] = bitangentTransfer(ai, ei, raf, ec, 'pa' , omi);
    
    deltat2 = TOF(a_t, e_t, 0, pi); % questo va messo a posto, non arrivo a pi ma al punto definito dopo
    
    deltav = deltav + abs(DeltaV1);
    deltat = deltat + deltat1;
    
    %% cerco secante ottimale per arrivare sull'orbita finale
    
    [rr1, vv1] = par2car(a_t, e_t, ii, OMi, om_t, 0); % punto di arrivo dell'orbita bitangente
    
    [at_s, et_s, i_t_s, OMt_s, omt_s, th1_trasf, th2_trasf, th1_iniziale, th2_finale, deltaV_tot, deltaT_tot, rr1_s, rr2_s] = secante_ottimale(rr1, vv1, rrf, vvf, nan, nan, 1);
    
    deltav = deltav + deltaV_tot;
    deltat = deltat + deltaT_tot;

    vel = [vel; deltav]

    if deltav < minimo(1,1)
        minimo = [deltav aa(j) j];
    end
   
end
%% plot

%Terra_3D
hold on

plotOrbit(ai, ei, ii, OMi, omi, thi, 2*pi, 0.001, 'rad', 'r'); % orbita iniziale
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r--'); % orbita iniziale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi + thf, 0.001, 'rad', 'b--'); % orbita finale
plotOrbit(a_t, e_t, ii, OMi, om_t, 0, th1_iniziale, 0.001, 'rad', 'c'); % orbita di trasferimento


plot3(rr(1), rr(2), rr(3), 'r*'); % posizione iniziale
plot3(rrf(1), rrf(2), rrf(3), 'bo'); % posizione finale

quiver3(0,0,0, rrp(1), rrp(2), rrp(3), 'off', 'r'); % eccentricità iniziale
quiver3(0,0,0, rrfp(1), rrfp(2), rrfp(3), 'off', 'b'); % eccentricità finale

quiver3(rr(1), rr(2), rr(3), vv(1), vv(2), vv(3), 1e3, 'r');
quiver3(rrf(1), rrf(2), rrf(3), vvf(1), vvf(2), vvf(3), 1e3, 'b');

% legend('', 'orbita iniziale', '', 'orbita finale', 'orbita di trasferimento', 'orbita circolare', 'inserzione diretta', 'punto iniziale', 'punto finale', 'ecc iniziale', 'ecc finale', 'v iniziale');

quiver3(0,0,0,1,0,0, 1e4);
quiver3(0,0,0,0,1,0, 1e4);
quiver3(0,0,0,0,0,1, 1e4);


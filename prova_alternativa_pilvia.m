clear; clc;

%% dati iniziali
rri = [1e4 2e4 1e4]';
vvi = [-2.5 -2.5 3]';
[ai, ei, ii, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, "rad");

%% trasferimento

[at, et, it, OMt, omt, delta_t, delta_th] = directTransfer(rri, rrf);

%% velocità

deltat_t_h = delta_t/3600 %tempo in ore


%% plot

% iniziale
Terra_3D
plotOrbit(ai, ei, ii, OMi, omi, 0, 2*pi, 0.001, 'rad', 'r') %bianco per vedere
hold on
plot3(rri(1), rri(2), rri(3), 'ko'); %bianco per vedere

% trasferimento
plotOrbit(at, et, it, OMt, omt, 0, 2*pi, 1e-3, 'rad', 'k')

% finale
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, 'rad', 'g')
plot3(rrf(1), rrf(2), rrf(3), 'ko');





























% %% apo e peri iniziali, cambio piano e finali
% 
% [rrpi, vvpi] = par2car(ai, ei, ii, OMi, omi, 0, "rad")
% plot3(rrpi(1), rrpi(2), rrpi(3), 'b*');
% [rrai, vvai] = par2car(ai, ei, ii, OMi, omi, pi, "rad")
% plot3(rrai(1), rrai(2), rrai(3), 'b*');
% 
% [rrcp1, vvcp1] = par2car(ai, ei, i_f, OMf, om2, 0, "rad");
% plot3(rrcp1(1), rrcp1(2), rrcp1(3), 'b*');
% [rrcp2, vvcp2] = par2car(ai, ei, i_f, OMf, om2, pi, "rad");
% plot3(rrcp2(1), rrcp2(2), rrcp2(3), 'b*');
% 
% [rrpf, vvpf] = par2car(af, ef, i_f, OMf, omf, 0, "rad")
% plot3(rrpf(1), rrpf(2), rrpf(3), 'b*');
% [rraf, vvaf] = par2car(af, ef, i_f, OMf, omf, pi, "rad")
% plot3(rraf(1), rraf(2), rraf(3), 'b*');
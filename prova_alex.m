clear, clc, close all

%% dati iniziali
rri = [1e4 2e4 1e4]';
vvi = [-2.5 -2.5 3]';

%% dati finali
af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;

%% conversioni
[rrf, vvf] = par2car(af, ef, i_f, OMf, omf, thf, 'rad');
[ai, ei, i_i, OMi, omi, thi] = car2par(rri, vvi, 'rad');

%% directTransfer
[at, et, i_t, OMt, omt] = directTransfer_opt(rri, rrf);

figure
plot(omt, et)
hold on
plot(omt, 1)

%% plot
for i = 1:length(omt)
    Terra_3D

    plotOrbit(ai, ei, i_i, OMi, omi, 0, 2*pi, 1e-3, 'rad', 'r')
    plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 1e-3, 'rad', 'b')
    plotOrbit(at(i), et(i), i_t, OMt, omt(i), 0, 2*pi, 1e-3, 'rad', 'k')
end
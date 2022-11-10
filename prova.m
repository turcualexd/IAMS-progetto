clear
clc
close all

rr = [1e4 2e4 1e4]';
vv = [-2.5 -2.5 3]';


[a, e, i, OM, om, th] = car2par(rr, vv, "rad");
i = 0;
OM = 0;

%[rr2, vv2] = par2car(a, e, i, OM, om, th, "rad");
Terra_3D
hold on
plotOrbit(a, e, i, OM, om, 0, 10*pi, 0.001, "rad"); %orbita iniziale
%hold on
plot3(rr(1), rr(2), rr(3), 'o');
i_i = i;
i_f = pi/2;
OM_i = OM;
OMf = pi/4; 


[DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OM, om, i_f, OMf);

%plot3(rr2(1), rr2(2), rr2(3), 'o');
omf = om + OM;

plotOrbit(a, e, i_f, OMf, omf, 0, 2*pi, 0.001, "rad");

quiver3(0,0,0,1,0,0, 1e4);
quiver3(0,0,0,0,1,0, 1e4);
quiver3(0,0,0,0,0,1, 1e4);
R1  = par2car(a, e, i, OM, om, theta(1), 'rad');
quiver3(0,0,0, R1(1), R1(2), R1(3));
R2  = par2car(a, e, i, OM, om, theta(2), 'rad');
quiver3(0,0,0, R2(1), R2(2), R2(3));

R3  = par2car(a, e, i_f, OMf, omf, theta(1), 'rad');
quiver3(0,0,0, R3(1), R3(2), R3(3));
R4  = par2car(a, e, i_f, OMf, omf, theta(2), 'rad');
quiver3(0,0,0, R4(1), R4(2), R4(3));





%% parametri finali

af = 10860;
ef = 0.2332;
i_f = 0.5284;
OMf = 3.0230;
omf = 0.4299;
thf = 0.3316;
plotOrbit(af, ef, i_f, OMf, omf, 0, 2*pi, 0.001, "rad");
[rr2, vv2] = par2car(af, ef, i_f, OMf, omf, thf, "rad");
plot3(rr2(1), rr2(2), rr2(3), 'o');

quiver3(0,0,0,1,0,0, 1e4);
quiver3(0,0,0,0,1,0, 1e4);
quiver3(0,0,0,0,0,1, 1e4);
title('Orbits');
legend("","initial orbit", "i3nitial point", "final orbit", "final point");


% se i = 0 (orbita equatoriale) non posso ricavare N, OM, om, uso N = 0 0
% 1, OM = 0, om = dot(ee,i) (?)
% controllo su h = 0,
% su orbita circolare con ee = 0, om, th non posso calcolarle, impongo  
